type t
val match_ : pat:string -> string -> t option
val fields : t -> (string * string) list

