open Base
open ExtString

type t =
    Text of string

let rec unpack s =
  match s with parser
      [< '\x00' = Stream.next; xs = Parsec.until '\xFF'>] ->
	Text (String.implode xs)
    | [< >] ->
	unpack s

let pack = function
  | Text s ->
      Printf.sprintf "\x00%s\xFF" s


