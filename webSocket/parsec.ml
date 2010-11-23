open Base

let fail () =
  raise Stream.Failure

let rec times f =
  function
      0 -> ()
    | n -> f () ;times f (n-1)

let rec repeat n f stream =
  if n = 0 then
    []
  else
    match stream with parser
	[<c = f>] ->
	  c::repeat (n-1) f stream
      | [<>] ->
	  raise (Stream.Error "invalid format")

let repeat_l n f stream =
  repeat (Int32.to_int n) f stream

let rec until c stream =
  match Stream.peek stream with
      Some x when x != c ->
	Stream.junk stream;
	x::(until c stream)
    | _ ->
	[]

let rec untilBy f stream =
  match Stream.peek stream with
      Some x when not (f x) ->
	Stream.junk stream;
	x::(untilBy f stream)
    | _ ->
	[]

let option f stream =
  try
    Some (f stream)
  with Stream.Failure ->
    None

let (<|>) f g =
  parser
      [<e = f>] -> e
    | [<e = g>] -> e

let (<?>) f msg stream =
  try
    match stream with parser
	[<e = f>] ->
	  e
  with Stream.Error s ->
    if s = "" then
      raise (Stream.Error msg)
    else
      raise (Stream.Error s)

let char c stream =
  match Stream.peek stream with
      Some x when x = c ->
	Stream.next stream
    | _ ->
	fail ()

let rec many parse stream =
  match stream with parser
      [< e = parse; s>] -> e::many parse s
    | [<>] -> []

let many1 parse stream =
  let x =
    parse stream in
    x::many parse stream

let try_ f stream =
  (*
     Use black-magic to save stream state

     from stream.ml:
     type 'a t = { count : int; data : 'a data }
  *)
  let t =
    Obj.repr stream in
  let count =
    Obj.field t 0 in
  let data =
    Obj.field t 1 in
    try
      f stream
    with Stream.Failure | Stream.Error _ ->
      Obj.set_field t 0 count;
      Obj.set_field t 1 data;
      fail ()

module type STREAM = sig
  type t
  type s

  val npeek : int -> t Stream.t -> char list
  val peek  : t Stream.t -> char option
  val junk  : t Stream.t -> unit
  val next  : t Stream.t -> t
  val shrink : t list  -> s
end

module Parser(S : STREAM) = struct
  let string str stream =
    let cs =
      ExtString.String.explode str in
    let n =
      List.length cs in
      match S.npeek n stream with
	  ys when cs = ys ->
	    S.shrink @@ repeat n S.next stream
	| _ ->
	    fail ()

  let one_of str stream =
    match S.peek stream with
	Some c when String.contains str c ->
	  S.next stream
      | _ ->
	  fail ()

  let alpha stream =
    match S.peek stream with
	Some ('a'..'z') | Some ('A'..'Z') ->
	  S.next stream
      | _ ->
	  fail ()

  let digit stream =
    match S.peek stream with
	Some ('0'..'9') ->
	  S.next stream
      | _ ->
	  fail ()

  let hex_digit stream =
    match S.peek stream with
	Some ('0'..'9') | Some ('A'..'Z') | Some ('a'..'z') ->
	  S.next stream
      | _ ->
	  fail ()

end

module CharS = Parser(
  struct
    type t = char
    type s = char list
    let npeek = Stream.npeek
    let peek  = Stream.peek
    let junk  = Stream.junk
    let next  = Stream.next
    let shrink = id
  end)


let string =
  CharS.string

let one_of =
  CharS.one_of

let alpha =
  CharS.alpha

let digit =
  CharS.digit

