type t =
  | Text of string

val unpack : char Stream.t -> t
val pack : t -> string
