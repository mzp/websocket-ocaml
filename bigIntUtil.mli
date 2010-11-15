module BigIntOp : sig
  val (+)   : Big_int.big_int -> Big_int.big_int -> Big_int.big_int
  val (-)   : Big_int.big_int -> Big_int.big_int -> Big_int.big_int
  val ( * ) : Big_int.big_int -> Big_int.big_int -> Big_int.big_int
  val (/)   : Big_int.big_int -> Big_int.big_int -> Big_int.big_int
  val (=)   : Big_int.big_int -> Big_int.big_int -> bool
end

val big_int : int -> Big_int.big_int
val to_string : n:int -> Big_int.big_int -> string

