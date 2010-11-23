type t = {
  handle : in_channel -> out_channel -> unit
}
val echo : t

val run : t -> string -> int -> unit
