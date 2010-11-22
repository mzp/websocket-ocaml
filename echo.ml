open Dsl

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
