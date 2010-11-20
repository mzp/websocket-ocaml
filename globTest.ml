open Base
open OUnit
open Glob

let assert_fields expect t =
  match t with
    | Some t ->
	assert_equal ~printer:Std.dump expect (fields t)
    | None ->
	assert false

let _ = begin "glob.ml" >::: [
  "マッチ成功" >:: begin fun _ ->
    assert_fields [] @@
      match_ ~pat:"/foo/bar/baz" "/foo/bar/baz"
  end;
  "マッチ失敗" >:: begin fun _ ->
    assert_equal None @@ match_ ~pat:"/foo/bar/baz" "/";
    assert_equal None @@ match_ ~pat:"/foo/bar/baz" "/foo";
    assert_equal None @@ match_ ~pat:"/foo/bar/baz" "/foo/bar";
    assert_equal None @@ match_ ~pat:"/foo/bar/baz" "/foo/bar/baz/xyzzy";
    assert_equal None @@ match_ ~pat:"/foo/bar/baz" "/foo/:bar/buggy";
  end;
  "フィールドのキャプチャ" >:: begin fun _ ->
    assert_fields ["baz","baz"] @@
      match_ ~pat:"/foo/bar/:baz" "/foo/bar/baz";
    assert_fields ["a","bar"; "b","baz"] @@
      match_ ~pat:"/foo/:a/:b" "/foo/bar/baz";
    assert_fields ["a","bar"; "b","baz"] @@
      match_ ~pat:"/:a/foo/:b" "/bar/foo/baz";
  end
] end +> run_test_tt_main

