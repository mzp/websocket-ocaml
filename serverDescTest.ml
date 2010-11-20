open Base
open OUnit
open ServerDesc

let desc = ServerDesc.server begin fun t ->
  t#post "/a" (fun _ _ -> "");
  t#get  "/b" (fun _ _ -> "");
  t#websocket  "/c" (fun _ _ -> ());

  t#post "/foo" (fun _ _ -> "");
  t#get  "/foo" (fun _ _ -> "");

  t#get "/bar" (fun _ _ -> "");
  t#websocket "/bar" (fun _ _ -> ())
end

let meth = function
  | Some (Post _ ) ->
      `Post
  | Some (Get _) ->
      `Get
  | Some (WebSocket _) ->
      `Ws
  | None ->
      `None

let _ = begin "serverDesc.ml" >::: [
  "POSTをさがせる" >:: begin fun _ ->
    assert_equal `Post @@ meth @@ ServerDesc.find desc ~meth:"POST" ~path:"/a"
  end;
  "GETをさがせる" >:: begin fun _ ->
    assert_equal `Get @@ meth @@ ServerDesc.find desc ~meth:"GET" ~path:"/b"
  end;
  "Websokectをさがせる" >:: begin fun _ ->
    assert_equal `Ws @@ meth @@ ServerDesc.find desc ~meth:"GET" ~path:"/c"
  end;
  "POST/GETは区別できる" >:: begin fun _ ->
    assert_equal `Get @@ meth @@ ServerDesc.find desc ~meth:"GET" ~path:"/foo";
    assert_equal `Post @@ meth @@ ServerDesc.find desc ~meth:"POST" ~path:"/foo"
  end;
  "Websocket/GETは区別できない" >:: begin fun _ ->
    assert_equal `Ws @@ meth @@ ServerDesc.find desc ~meth:"GET" ~path:"/bar"
  end
] end +> run_test_tt_main
