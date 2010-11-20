open Base
open ExtList

class type ws = object
  method read : Frame.t
  method send : Frame.t -> unit
end

class type dsl = object
  method get : string -> (Glob.t -> unit -> string) -> unit
  method post : string -> (Glob.t -> unit -> string) -> unit
  method websocket : string -> (Glob.t -> ws -> unit) -> unit
end

type desc =
  | WebSocket of (ws   -> unit)
  | Get       of (unit -> string)
  | Post      of (unit -> string)

type 'a table = (string * (Glob.t -> 'a)) list

type t = {
  mutable ws   : (ws->unit) table;
  mutable get  : (unit->string) table;
  mutable post : (unit->string) table
}

let server f : t =
  let xs =
    { ws = []; get = []; post = [] } in
  let t =  object
    method websocket path f =
      xs.ws <- (path,f)::xs.ws
    method post path f =
      xs.post <- (path,f)::xs.post
    method get path f =
      xs.get <- (path,f)::xs.get
  end in
    f t;
    xs

let match_ f xs =
  let open Maybe in
  xs
  +> List.filter_map begin fun (pat, g) ->
    f pat >>= (fun t -> return (g, t))
  end
  +> function [] -> None | (x::_) -> Some x

let find desc ~meth ~path =
  let find' wrap table =
    let open Maybe in
      match_ (fun pat -> Glob.match_ ~pat path) table
      >>= (fun (g, t) -> return @@ wrap (g t)) in
      match meth with
	| "POST" ->
	    find' (fun x -> Post x) desc.post
	| "GET" ->
	    let ws =
	      find' (fun x -> WebSocket x) desc.ws in
	      begin match ws with
		  Some _ ->
		    ws
		| None ->
		    find' (fun x -> Get x) desc.get
	      end
	| _ ->
	    failwith "unknown method"

let html path =
  open_in_with path Std.input_all
