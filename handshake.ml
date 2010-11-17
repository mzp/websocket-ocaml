open Base
open ExtString
open Big_int
open BigIntUtil


let input_nbytes n ch =
  let buf =
    String.make n ' ' in
    really_input ch buf 0 n;
    buf

let is_num = function
    '0'..'9' -> true
  | _ -> false

let is_space c =
  c = ' '

let decode s =
  let xs =
    String.explode s in
  let num =
    List.filter is_num xs
    +> String.implode
    +> big_int_of_string in
  let spaces =
    List.filter is_space xs
    +> List.length
    +> big_int in
    BigIntOp.( num / spaces)

let handshake key1 key2 key3 =
  String.concat "" [
    pack ~n:4 @@ decode key1;
    pack ~n:4 @@ decode key2;
    key3
  ]
  +> Digest.string
