open ServerDesc

let echo =
  server begin fun s ->
    s#websocket "/echo" begin fun _ t ->
      while true do
	t#send t#read
      done
    end;
    s#get "/echo.html" begin fun _ _ ->
      html "echo.html"
    end;
    s#get "/hi" begin fun _ _ ->
      "hello"
    end
  end
