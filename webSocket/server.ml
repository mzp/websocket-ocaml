open Base
open Unix

type t = {
  handle : in_channel -> out_channel -> unit
}

let echo =
  let handle input output =
    output_string output @@ input_line input;
    output_string output "\n";
    flush output in
    { handle }

let socket_with host port f =
  let s =
    Unix.socket PF_INET SOCK_STREAM 0 in
  let { ai_addr; _ } =
    List.hd @@ getaddrinfo host (string_of_int port) [] in
    f s ai_addr

let run t host port =
  socket_with host port begin fun _ addr ->
    Unix.establish_server (fun i o -> forever (fun _ -> t.handle i o) ()) addr
  end
