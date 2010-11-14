open Base
open Unix

type t = {
  on_accept : in_channel -> out_channel -> unit
}

let echo = {
  on_accept = fun input output ->
    output_string output @@ input_line input;
    output_string output "\n";
    flush output
}

let socket_with host port f =
  let s =
    Unix.socket PF_INET SOCK_STREAM 0 in
  let { ai_addr; _ } =
    List.hd @@ getaddrinfo host (string_of_int port) [] in
    f s ai_addr

let run t host port =
  socket_with host port begin fun _ addr ->
    Unix.establish_server (fun i o -> forever (fun _ -> t.on_accept i o) ()) addr
  end
