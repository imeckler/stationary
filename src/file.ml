open Core.Std
open Async.Std
open Stationary_std_internal

type t =
  | Html of string * Html.t
  | Of_path of { path : string; name : string }

let of_html ~name html =
  validate_filename name;
  Html (name, html)

let of_path ?name path =
  let name =
    match name with
    | Some name -> name
    | None -> Filename.basename path
  in
  Of_path {path; name}

let build t ~in_directory =
  match t with
  | Html (name, html) ->
    Writer.save (in_directory ^/ name)
      ~contents:(Html.to_string html)
  | Of_path {name; path} ->
    Process.run_expect_no_output_exn ~prog:"cp"
      ~args:[ path; in_directory ^/ name ]
      ()
;;
