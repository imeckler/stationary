type t [@@deriving sexp]

val node
  : string
  -> Attribute.t list
  -> t list
  -> t

val literal : string -> t

val text : string -> t

val to_string : t -> string

val link : href:string -> t

val hr : Attribute.t list -> t
