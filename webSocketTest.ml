open Base
open OUnit
open WebSocket

let _ = begin "webSocket.ml" >::: [
  "handshake" >:: begin fun () ->
    (* copy from draft-03 *)
    let key1 =
      "18x 6]8vM;54 *(5:  {   U1]8  z [  8vM" in
    let key2 =
      "1_ tx7X d  <  nw  334J702) 7]o}` 0" in
    let key3 =
      "Tm[K T2u" in
      assert_equal "fQJ,fN/4F4!~K~MH" @@ handshake ~key1 ~key2 ~key3
  end;
  "read frame" >:: begin fun () ->
    let s =
      Stream.of_string "\000hogehoge\xFF" in
      assert_equal (Text "hogehoge") @@ read_frame s
  end
] end +> run_test_tt_main

