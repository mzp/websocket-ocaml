let bind x f =
  match x with
      None -> None
    | Some y -> f y

let (>>=) =
  bind

let return x =
  Some x

