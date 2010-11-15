open Base
open OUnit
open Big_int
open BigIntUtil

let _ = begin "bigNumUtil.ml" >::: [
  "BigEndianで文字列に変換できる" >:: begin fun () ->
    assert_equal "\000" @@ to_string ~n:1 (big_int 0);
    assert_equal "\000\000" @@ to_string ~n:2 (big_int 0);
    assert_equal "\000\000\001\001" @@ to_string ~n:4 (big_int 256);

  end;
  "四則演算を持ってる" >:: begin fun () ->
    let open BigIntOp in
      "add"  @? (big_int 3 = big_int 1 + big_int 2);
      "sub"  @? (big_int 1 = big_int 2 - big_int 1);
      "mult" @? (big_int 2 = big_int 2 * big_int 1);
      "div"  @? (big_int 2 = big_int 4 / big_int 2);
  end
] end +> run_test_tt_main
