open Base
open OUnit

let _ = begin "webSocket.ml" >::: [
  "handshake" >:: begin fun () ->
    ()
  end
] end +> run_test_tt_main

