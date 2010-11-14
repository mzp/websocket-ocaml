open Base
open OUnit
open Logger
open StdLabels

let buffer = ref ""

let _ =
  add_handler (fun s -> buffer := s)

let reset f =
  buffer := "";
  f ();
  !buffer

let t =
  Logger.__set_time 1289693887.

let assert_level expect xs ys f =
  List.iter xs ~f:begin fun l ->
    assert_equal ~printer:Std.dump expect @@ reset begin fun _ ->
      Logger.set_level l;
      f ()
    end
  end;
  List.iter ys ~f:begin fun l ->
    assert_equal "" @@ reset begin fun _ ->
      Logger.set_level l;
      f ()
    end
  end


let _ = begin "logger.ml" >::: [
  "日付とレベルがついてくる" >:: begin fun _ ->
    assert_equal "[2010-11-14 09:18:07] ERROR hi" @@ reset begin fun _ ->
      Logger.error "hi";
    end
  end;
  "Errorはどのレベル設定でも出力される" >:: begin fun _ ->
    assert_level "[2010-11-14 09:18:07] ERROR hi" [ cError; cInfo; cDebug] [] @@
      fun _ -> Logger.error "hi"
  end;
  "InfoはInfoレベルとDebugレベルで出力される" >:: begin fun _ ->
    assert_level "[2010-11-14 09:18:07] INFO hi" [ cInfo; cDebug ] [ cError] @@
      fun _ -> Logger.info "hi"
  end;
  "Errorはどのレベル設定でも出力される" >:: begin fun _ ->
    assert_level "[2010-11-14 09:18:07] DEBUG hi" [ cDebug] [ cError; cInfo ] @@
      fun _ -> Logger.debug "hi"
  end;
] end +> run_test_tt_main

