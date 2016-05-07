open Core.Std
open Async.Std
open Stationary_std_internal

type t =
  | Html of string * Html.t
  | Of_path of string

let of_html ~name html =
  validate_filename name;
  Html (name, html)

let of_path path = Of_path path

let build t ~in_directory =
  match t with
  | Html (name, html) ->
    Writer.save (in_directory ^/ name)
      ~contents:(Html.to_string html)
  | Of_path path ->
    Process.run_expect_no_output_exn ~prog:"cp"
      ~args:[ path; in_directory ^/ Filename.basename path ]
      ()
;;
