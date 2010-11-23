type t = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
}

val parse : char Stream.t -> t
