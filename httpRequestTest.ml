open Base
open OUnit

let _ = begin "httpRequest.ml" >::: [
  "request" >:: begin fun () ->
    let input =
      Stream.of_string @@ String.concat "\r\n" [
	"GET / HTTP/1.1";
	"Upgrade: WebSocket";
	"Connection: Upgrade";
	"";
	"hog"
      ] in
    let expect = {
      HttpRequest.path = "/";
      method_ = "GET";
      fields = ["Upgrade",   "WebSocket";
		"Connection","Upgrade"]
    } in
      assert_equal expect @@  HttpRequest.parse input
  end;
  "body部分は読まない">:: begin fun () ->
    let input =
      Stream.of_string @@ String.concat "\r\n" [
	"GET / HTTP/1.1";
	"Upgrade: WebSocket";
	"Connection: Upgrade";
	"";
	"hoge"
      ] in
      ignore @@  HttpRequest.parse input;
      assert_equal 'h' @@ Stream.next input
  end;
] end +> run_test_tt_main

