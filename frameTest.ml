open Base
open OUnit
open Frame

let _ = begin "frame.ml" >::: [
  "Textフレームの読み込み" >:: begin fun () ->
    assert_equal (Text "hoge") @@ unpack (Stream.of_string "\x00hoge\xFF")
  end;
  "Textフレームの書き込み" >:: begin fun () ->
    assert_equal "\x00hoge\xFF" @@ Frame.pack (Text "hoge")
  end
] end +> run_test_tt_main

