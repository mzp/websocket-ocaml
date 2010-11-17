open Base
open OUnit

let _ = begin "httpResponse.ml" >::: [
  "response" >:: begin fun () ->
    let expect =
      String.concat "\r\n" [
	"HTTP/1.1 101 WebSocket Protocol Handshake";
	"Upgrade: WebSocket";
	"Connection: Upgrade";
	"Sec-WebSocket-Origin: http://localhost";
	"";
	"hoge"
      ] in
    let actual = HttpResponse.to_string {
      HttpResponse.version = "1.1";
      status = "101 WebSocket Protocol Handshake";
      fields = ["Upgrade",   "WebSocket";
		"Connection","Upgrade";
		"Sec-WebSocket-Origin", "http://localhost"];
      body = "hoge"
    } in
      assert_equal expect actual
  end
] end +> run_test_tt_main

