open Base
open ExtList

type ws =
    < read : Frame.t; send : Frame.t -> unit >

type desc =
  | WebSocket of (ws -> unit)
  | Get of (unit -> string)

type t =
    (string * (Glob.t -> desc)) list

let html path =
  open_in_with path Std.input_all

let server f : t =
  let xs =
    ref [] in
  let t =  object
    method websocket path f =
      xs := (path, fun t -> WebSocket (f t))::!xs
    method get path f =
      xs := (path, fun t -> Get (f t))::!xs
  end in
    f t;
    List.rev !xs

let (>>=) x f =
  match x with
      None -> None
    | Some y -> f y

let dispatch desc path =
  match List.filter_map (fun (pat, f) ->
			   Glob.match_ ~pat path >>= (fun t -> Some (t,f))) desc with
      (t, f)::_ ->
	Some (f t)
    | [] ->
	None
