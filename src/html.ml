open Core.Std

type t =
  | Text of string
  | Node of string * Attribute.t list * t list
  | No_close of string * Attribute.t list
  [@@deriving sexp]

let node tag attrs children = Node (tag, attrs, children)

let text s = Text s

let hr attrs = No_close ("hr", attrs)

let link ~href =
  No_close
    ( "link"
    , [ Attribute.create "rel" "stylesheet"
      ; Attribute.create "type" "text/css"
      ; Attribute.create "href" href
      ]
    )

(* TODO *)
let escape_for_html s = s

let rec to_lines =
  let indent_lines = List.map ~f:(sprintf "  %s") in
  function
  | No_close (tag, attrs) ->
    [ sprintf "<%s %s>" tag
        (String.concat ~sep:" "
          (List.map ~f:Attribute.to_string attrs))
    ]

  | Text s -> [ escape_for_html s ]

  | Node (tag, attrs, children) ->
    let children =
      List.concat_map children
        ~f:(fun t -> indent_lines (to_lines t))
    in
    let opening =
      match attrs with
      | [] -> sprintf "<%s>" tag
      | _ :: _ ->
        sprintf "<%s %s>" tag
          (String.concat ~sep:" "
            (List.map ~f:Attribute.to_string attrs))
    in
    opening
    :: children
    @ [ sprintf "</%s>" tag]

let to_string t = String.concat ~sep:"\n" (to_lines t)
