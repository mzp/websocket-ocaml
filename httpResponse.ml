open Base
open Printf

type t = {
  version : string;
  status  : string;
  fields  : (string * string) list;
  body    : string
}

let to_string { version; status; fields; body } =
  String.concat "\r\n" [
    sprintf "HTTP/%s %s" version status;
    String.concat "\r\n" @@ List.map (fun (k,v) -> sprintf "%s: %s" k v) fields;
    "";
    body
  ]

