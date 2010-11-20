open Base
open ExtString
open ServerDesc

let input_nbytes n ch =
  let buf =
    String.make n ' ' in
    really_input ch buf 0 n;
    buf

let send ch s =
  output_string ch s;
  flush ch

let ws_response = {
  HttpResponse.version = "1.1";
  status = "101 WebSocket Protocol Handshake";
  fields = ["Upgrade", "WebSocket";
	    "Connection", "Upgrade"];
  body = ""
}

let make_response { HttpRequest.fields; path; _ } body =
  let origin = [
    "Sec-WebSocket-Origin" , List.assoc "Origin" fields;
    "Sec-WebSocket-Location", Printf.sprintf "ws://%s%s" (List.assoc "Host" fields) path
  ] in
  let handshake =
    Handshake.handshake
      (List.assoc "Sec-WebSocket-Key1" fields)
      (List.assoc "Sec-WebSocket-Key2" fields)
      body in
    { ws_response with
	HttpResponse.fields = fields @ origin;
	body = handshake
    }

let handshake ch request stream =
  let body =
    String.implode @@ Stream.npeek 8 stream in
    make_response request body
    +> HttpResponse.to_string
    +> tee Logger.debug
    +> send ch

let dispatch desc output stream request =
  match List.assoc request.HttpRequest.path desc with
      Get f ->
	send output @@ f ()
    | WebSocket f ->
	let obj = object
	  method read =
	    Frame.unpack stream
	    +> tee (fun s -> Logger.debug @@ Printf.sprintf "Read: %s" @@ Std.dump s)
	  method send s =
	    Logger.debug @@ Printf.sprintf "Send: %s" (Std.dump s);
	    send output @@ Frame.pack s
	end in
	  handshake output request stream;
	  f obj

let handle desc input output =
  let stream =
    Stream.of_channel input in
  let request =
    HttpRequest.parse stream in
    try
      dispatch desc output stream request
    with e ->
      Logger.error (Printexc.to_string e)

let server f =
  { Server.handle = handle f }
