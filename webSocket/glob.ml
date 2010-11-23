open Base
open ExtString

type t = (string * string) list

let is_pattern name =
  String.starts_with name ":"

let (>>=) x f =
  match x with
      None -> None
    | Some y -> f y

let rec match_impl xs ys =
  match xs,ys with
    | [], [] ->
	Some []
    | _, [] ->
	None
    | [], _ ->
	None
    | x :: xs, y :: ys when is_pattern x ->
	match_impl xs ys >>= (fun zs -> Some ((String.slice ~first:1 x,y)::zs))
    | x :: xs, y :: ys when x = y ->
	match_impl xs ys
    | _,_ ->
	None

let match_ ~pat path =
  let pat' =
    String.nsplit pat "/" in
  let path' =
    String.nsplit path "/" in
    match_impl pat' path'

let fields = id
