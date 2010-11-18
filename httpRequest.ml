open Base
open Parsec
open ExtString

type t = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
}

let untilS c = parser
    [< ret = String.implode $ until c; _ = char c >] ->
      ret

let header = parser
    [< method_ = untilS ' '; path = untilS ' '; _version = untilS '\r'; _ = char '\n' >] ->
      (method_, path)

let field = parser
    [< _ = char '\r'; _ = char '\n' >] ->
      fail ()
  | [< key = untilS ':'; value = untilS '\r'; _ = char '\n' >] ->
      (String.strip key, String.strip value)

let parse = parser
    [< (method_, path) = header; fields  = many field >] ->
      { method_; path; fields }
