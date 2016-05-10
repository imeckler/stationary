open Core.Std
open Async.Std
open Stationary

let wrap =
  let open Html in
  let navbar =
    let page title url =
      node "li" []
        [ node "a" [ Attribute.href url ] [ text title ] ]
    in
    node "div" [ Attribute.class_ "navbar-collapse" ]
      [ node "ul" [ Attribute.class_ "nav navbar-nav" ]
          [ page "Home" "/"
          ; page "About" "/about.html"
          ]
      ]
  in
  let footer =
    node "div" []
      [ node "img" [ Attribute.src "/assets/camel.jpg" ] []
      ; node "p" []
          [ node "i" [] [text "This is a camel."]
          ]
      ]
  in
  fun content ->
    node "html" []
      [ node "head" []
          [ link ~href:"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          ; node "script"
              [ Attribute.create "type" "text/javascript"
              ; Attribute.src "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
              ]
              []
          ]
      ; node "body" []
          [ node "h1" []
              [ text "Stationary example blog" ]
          ; navbar
          ; node "div" [ Attribute.class_ "container" ] [ content ]
          ; hr []
          ; footer
          ]
      ]

let posts () =
  Sys.ls_dir "posts" >>= fun post_paths ->
  Deferred.List.map post_paths ~f:(fun path ->
    Reader.load_sexp_exn path Post.t_of_sexp
  )
  >>| fun posts ->
  List.sort ~cmp:(fun p1 p2 -> - Date.compare p1.date p2.date) posts

let about () =
  Reader.file_contents "about.txt" >>| fun about_txt ->
  wrap (text about_txt)

let main () =
  about () >>= fun about ->
  posts () >>= fun posts ->
  let site =
    let open File_system in
    Site.create
      [ home
      ; about
      ; copy_directory "assets"
      ; directory "posts"
          (List.map posts ~f:(fun p ->
            file (
              File.of_html
                ~name:(Post.filename p) (Post.to_html p))))
      ]
  in
  Site.build site ~dst:"_site"

let () =
  Command.run (
    Command.async Command.Spec.empty
  )
