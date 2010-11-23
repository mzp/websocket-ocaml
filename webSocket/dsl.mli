type t
val server :
  (< get : string -> (Glob.t -> string) -> unit;
     ws : string ->
          (Glob.t -> < read : Frame.t; send : Frame.t -> unit > -> unit) ->
          unit > -> 'a) -> t
val html : string -> string
val find : t -> string -> (Handler.ctx -> unit) option

