open Base
open ExtString
type request = {
  method_ : string;
  path    : string;
  fields : (string * string) list;
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
	  { method_; path; fields }
    | _ ->
	failwith "invalid request"

let handle input _output =
  Logger.debug @@ Std.dump (parse_request (fun () ->
					     input_line input
					     +> tee Logger.debug))

let server =
  let open Server in
    { handle }
