open Core

type t = string * string
  [@@deriving sexp]

let to_string (k, v) = sprintf "%s=\"%s\"" k (String.escaped v)

let create k v = (k, v)

let class_ c = create "class" c

let href url = create "href" url

let src url = create "src" url
