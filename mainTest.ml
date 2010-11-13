open Base
open OUnit

let _ = begin "main.ml" >::: [
  "test" >:: begin fun _ ->
    "the answer" @? (42 = Main.answer ())
  end
] end +> run_test_tt_main

