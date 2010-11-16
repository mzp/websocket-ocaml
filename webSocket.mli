val server : Server.t

(* for debug *)
type request = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
  body    : string
}

type frame =
  | Text of string
  | Binary of string
  | ClosingFrame

val handshake : key1:string -> key2:string -> key3:string -> string
val read_frame : char Stream.t -> frame
