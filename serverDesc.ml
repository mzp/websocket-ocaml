open Base

type t =
  | WebSocket of (< read : Frame.t; send : Frame.t -> unit > -> unit)
  | Get of (unit -> string)

let html path =
  open_in_with path Std.input_all

let server f =
  let xs =
    ref [] in
  let t =  object
    method websocket path f =
      xs := (path, WebSocket f)::!xs
    method get path f =
      xs := (path, Get f)::!xs
  end in
    f t;
    !xs
