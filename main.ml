let _ =
  Logger.setup ();
  Logger.set_level Logger.cDebug;
  Logger.info "Websocket/OCaml server start(0.0.0.0:8080)";
  Server.run (Dispatch.make Echo.echo) "0.0.0.0" 8080
