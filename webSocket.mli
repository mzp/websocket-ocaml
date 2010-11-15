val server : Server.t

(* for debug *)
type request = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
  body    : string
}

val handshake : key1:string -> key2:string -> key3:string -> string
