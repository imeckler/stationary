open Core.Std
open Config

type t =
  { title   : string
  ; date    : Date.t
  ; content : Html.t
  }

let basename { title; _ } =
  let s =
    let allow_char =
      let allowed = Char.Set.of_list [ '-'; '_' ] in
      fun c ->
        Set.mem allowed c || Char.is_alphanum c
    in
    String.filter ~f:allow_char
      (String.map title ~f:(fun c -> if c = ' ' then '-' else c))
  in
  sprintf "%s.html" s

let url t = sprintf "/%s/%s" posts_dir (basename t)

let html ((prev, post, next) : t Window.t) =
  let open Html in
  let nav_button dir =
    let class_, nav_post =
      match dir with
      | `Left -> "arrow-left", prev
      | `Right -> "arrow-right", next
    in
    node "div" [ Attribute.class_ "nav-button-wrapper" ]
      begin match nav_post with
        | None -> []
        | Some nav_post ->
          [ node "a"
            [ Attribute.href (url nav_post)
            ]
            [ node "div" [ Attribute.class_ class_ ] []
            ]
          ]
      end
  in
  node "div"
    [ Attribute.class_ "post-container"
    ]
    [ node "h2"
        [ Attribute.class_ "date" ]
        [ text (Date.format post.date "%B %e, %Y") ]
    ; node "h1" [ Attribute.class_ "post-title" ] [ text post.title ]
    ; node "div"
      [ Attribute.class_ "nav-wrapper" ]
      [ nav_button `Left
      ; node "div"
          [ Attribute.class_ "post-content" ]
          [ post.content ]
      ; nav_button `Right
      ]
    ]

