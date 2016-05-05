type t
  [@@deriving sexp]

val to_string : t -> string
val create : string -> string -> t

val class_ : string -> t

val href : string -> t
