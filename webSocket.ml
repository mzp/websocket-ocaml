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

let response request =
  String.concat "\r\n" [
    "HTTP/1.1 101 WebSocket Protocol Handshake";
    "Upgrade: WebSocket";
    "Connection: Upgrade";
    "Sec-WebSocket-Origin: " ^ List.assoc "Origin" request.fields;
    "Sec-WebSocket-Location: ws://" ^ List.assoc "Host" request.fields ^ "/";
    "";
    Handshake.handshake
      (List.assoc "Sec-WebSocket-Key1" request.fields)
      (List.assoc "Sec-WebSocket-Key2" request.fields)
      request.body
  ]

let send ch s =
  output_string ch s;
  flush ch

let handle input output =
  let request =
    parse_request begin fun () ->
      input_line input
      +> tee Logger.debug
    end in
  let request =
    { request with
	body = input_nbytes 8 input
    } in
  let _ =
    response request
    +> tee Logger.debug
    +> send output in
  let s =
    Stream.of_channel input in
    while true do
      try
	match Frame.unpack s with
	    (Frame.Text text) as f ->
	      Logger.debug @@ Std.dump text;
	      send output @@ Frame.pack f
      with e ->
	Logger.error (Printexc.to_string e)
    done


let server =
  let open Server in
    { handle }
