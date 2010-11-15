open Big_int

module BigIntOp = struct
  let (+)   = add_big_int
  let (-)   = sub_big_int
  let ( * ) = mult_big_int
  let (/)   = div_big_int
  let (=)   = eq_big_int
end

let big_int =
  big_int_of_int

let to_string ~n _ = ignore n; assert false

