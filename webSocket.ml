open Base
open ExtString
open Big_int
open BigIntUtil

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

let is_num = function
    '0'..'9' -> true
  | _ -> false

let is_space c =
  c = ' '

let decode_key s =
  let xs =
    String.explode s in
  let num =
    List.filter is_num xs
    +> String.implode
    +> big_int_of_string in
  let spaces =
    List.filter is_space xs
    +> List.length
    +> big_int in
    BigIntOp.( num / spaces)

let handshake ~key1 ~key2 ~key3 =
  String.concat "" [
    pack ~n:4 @@ decode_key key1;
    pack ~n:4 @@ decode_key key2;
    key3
  ]
  +> Digest.string

let response request =
  String.concat "\r\n" [
    "HTTP/1.1 101 WebSocket Protocol Handshake";
    "Upgrade: WebSocket";
    "Connection: Upgrade";
    "Sec-WebSocket-Origin: " ^ List.assoc "Origin" request.fields;
    "Sec-WebSocket-Location: ws://" ^ List.assoc "Host" request.fields ^ "/";
    "";
    handshake
      ~key1:(List.assoc "Sec-WebSocket-Key1" request.fields)
      ~key2:(List.assoc "Sec-WebSocket-Key2" request.fields)
      ~key3:request.body
  ]

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
    +> output_string output in
  let _ =
    flush output in
    Logger.debug @@ Std.dump @@ input_nbytes 1 input

let server =
  let open Server in
    { handle }
