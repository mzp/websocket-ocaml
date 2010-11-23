let _ =
  WebSocket.Logger.setup ();
  WebSocket.Logger.set_level   WebSocket.Logger.cDebug;
  WebSocket.Logger.info "Websocket/OCaml server start(0.0.0.0:8080)";
  WebSocket.Server.run (WebSocket.Dispatch.make Echo.echo) "0.0.0.0" 8080
