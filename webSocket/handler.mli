class type ctx = object
  method send : string -> unit
  method stream : char Stream.t
  method request : HttpRequest.t
end

type t =  Glob.t -> ctx -> unit
