val server : Server.t

(* for debug *)
type request = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
  body    : string
}
