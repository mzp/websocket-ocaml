open Base
open ExtList

type t = (string * Handler.t) list

let server f : t =
  let xs =
    ref [] in
  let add pat f =
    xs := (pat, f) :: !xs in
  let obj = object
    method get pat f = add pat @@ GetHandler.handle f
    method ws  pat f = add pat @@ WsHandler.handle f
  end in
    f obj;
    List.rev !xs

let html path =
  open_in_with path Std.input_all

let find xs path =
  let open Maybe in
  xs
  +> List.filter_map begin fun (pat, g) ->
    Glob.match_ ~pat path >>= (fun t -> return @@ g t)
  end
  +> function [] -> None | (x::_) -> Some x
