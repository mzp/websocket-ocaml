type ws =
    < read : Frame.t; send : Frame.t -> unit >

type desc =
  | WebSocket of (ws -> unit)
  | Get of (unit -> string)

type t

val html : string -> string

val server :
  (< get : string -> (Glob.t -> unit -> string) -> unit;
     websocket : string -> (Glob.t -> ws -> unit) -> unit> -> 'a) -> t

val dispatch : t -> string -> desc option

