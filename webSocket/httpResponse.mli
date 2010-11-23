type t = {
  version : string;
  status  : string;
  fields  : (string * string) list;
  body    : string
}

val to_string : t -> string
