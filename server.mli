type t = {
  on_accept : in_channel -> out_channel -> unit
}
val echo : t

val run : t -> unit
