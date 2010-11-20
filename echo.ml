open ServerDesc

let echo =
  server begin fun s ->
    s#websocket "/echo" begin fun t ->
      while true do
	t#send t#read
      done
    end;
    s#get "/echo.html" begin fun _ ->
      html "echo.html"
    end
  end
