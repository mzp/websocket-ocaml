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
  | WebSocket of (ws -> unit)
  | Get       of (unit -> string)
  | Post      of (unit -> string)

type t

val server : (dsl -> 'a) -> t

val find : t -> meth:string -> path:string -> desc option
val html : string -> string
