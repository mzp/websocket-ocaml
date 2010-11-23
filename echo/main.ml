open WebSocket.Dsl

let echo =
  server begin fun s ->
    s#ws "/echo" begin fun _ ws ->
      while true do
	ws#send ws#read
      done
    end;
    s#get "/echo.html" begin fun _ ->
      html "echo.html"
    end;
    s#get "/hi" begin fun _ ->
      "hello"
    end
  end

let _ =
  WebSocket.Logger.setup ();
  WebSocket.Logger.set_level   WebSocket.Logger.cDebug;
  WebSocket.Logger.info "Websocket/OCaml server start(0.0.0.0:8080)";
  WebSocket.Server.run echo "0.0.0.0" 8080
