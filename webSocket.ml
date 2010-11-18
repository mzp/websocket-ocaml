open Base
open ExtString

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

let make_response { HttpRequest.fields; _ } body =
  let origin = [
    "Sec-WebSocket-Origin" , List.assoc "Origin" fields;
    "Sec-WebSocket-Location", Printf.sprintf "ws://%s/" @@ List.assoc "Host" fields
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

let handshake ch stream =
  let request =
    HttpRequest.parse stream in
  let body =
    String.implode @@ Stream.npeek 8 stream in
    make_response request body
    +> HttpResponse.to_string
    +> tee Logger.debug
    +> send ch

let handle f input output =
  let stream =
    Stream.of_channel input in
  let obj = object
    method read =
      Frame.unpack stream
      +> tee (fun s -> Logger.debug @@ Printf.sprintf "Read: %s" @@ Std.dump s)

    method send s =
      Logger.debug @@ Printf.sprintf "Send: %s" (Std.dump s);
      send output @@ Frame.pack s
  end in
    try
      handshake output stream;
      f obj
    with e ->
      Logger.error (Printexc.to_string e)

let server f =
  { Server.handle = handle f }
