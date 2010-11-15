open Base
open Big_int
open ExtString

module BigIntOp = struct
  let (+)   = add_big_int
  let (-)   = sub_big_int
  let ( * ) = mult_big_int
  let (/)   = div_big_int
  let (=)   = eq_big_int
  let (<)   = lt_big_int
  let (>)   = gt_big_int
  let (<=)  = le_big_int
  let (>=)  = ge_big_int
end

let big_int =
  big_int_of_int

let big_endian w bi =
  range 0 w
  +> List.map (( * ) 8)
  +> List.map (fun m -> extract_big_int bi m 8)
  +> List.map int_of_big_int
  +> List.rev

let pack ~n bi =
  big_endian n bi
  +> List.map Char.chr
  +> String.implode

let unpack str =
  str
  +> String.explode
  +> List.map Char.code
  +> List.map big_int
  +> List.fold_left (fun x y -> BigIntOp.(shift_left_big_int x 8 + y)) (big_int 0)
