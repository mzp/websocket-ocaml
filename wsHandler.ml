open Base
open ExtString

let response = {
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
    { response with
	HttpResponse.fields = fields @ origin;
	body = handshake
    }

let handshake ctx =
  let body =
    String.implode @@ Stream.npeek 8 ctx#stream in
    make_response ctx#request body
    +> HttpResponse.to_string
    +> tee Logger.debug
    +> ctx#send

let handle f glob ctx =
  let obj = object
    method read =
      Frame.unpack ctx#stream
      +> tee (fun s -> Logger.debug @@ Printf.sprintf "Read: %s" @@ Std.dump s)
    method send s =
      Logger.debug @@ Printf.sprintf "Send: %s" (Std.dump s);
      ctx#send @@ Frame.pack s
  end in
    handshake ctx;
    f glob obj
