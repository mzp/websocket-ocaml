open Base
open ExtString
type request = {
  method_ : string;
  path    : string;
  fields  : (string * string) list;
  body    : string
}

let rec parse_fields read =
  let line =
    read () in
    if line = "\r" then
      []
    else
      let (key,value) =
	String.split line ":" in
	(String.strip key, String.strip value)::parse_fields read

let parse_request read =
  match String.nsplit (read ()) " " with
      [method_; path; _version] ->
	let fields =
	  parse_fields read in
	  { method_; path; fields; body = "" }
    | _ ->
	failwith "invalid request"

let input_nbytes n ch =
  let buf =
    String.make n ' ' in
    really_input ch buf 0 n;
    buf

let handshake _ = assert false

let handle input _output =
  let request =
    parse_request begin fun () ->
      input_line input
      +> tee Logger.debug
    end in
  let request =
    { request with
	body = input_nbytes 8 input
    } in
    Logger.debug @@ Std.dump request

let server =
  let open Server in
    { handle }
