open Base
open ExtString
open Dsl

let input_nbytes n ch =
  let buf =
    String.make n ' ' in
    really_input ch buf 0 n;
    buf

let send ch s =
  Logger.debug s;
  output_string ch s;
  flush ch

let dispatch map output stream ({ HttpRequest.path; _ } as request) =
  let ctx =  object
    method request = request
    method stream  = stream
    method send s  = send output s
  end in
    match Dsl.find map path with
      | None ->
	  send output @@ HttpResponse.to_string {
	    HttpResponse.version = "1.1";
	    status = "404 Not Found";
	    fields = ["Connection", "close"];
	    body = "not found"
	  };
	  close_out output
      | Some f ->
	  f ctx

let handle desc input output =
  let stream =
    Stream.of_channel input in
  let request =
    HttpRequest.parse stream in
    try
      dispatch desc output stream request;
      Unix.shutdown_connection input
    with e ->
      Logger.error (Printexc.to_string e);
      Unix.shutdown_connection input

let make f =
  { Server.handle = handle f }
