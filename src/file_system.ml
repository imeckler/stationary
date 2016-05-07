open Core.Std
open Async.Std
open Stationary_std_internal

type t =
  | File of File.t
  | Directory of directory
and directory =
  | Synthetic of string * t list
  | Copy_directory of string

let file file = File file

let directory name ts =
  validate_filename name;
  Directory (Synthetic (name, ts))

let copy_directory dir = Directory (Copy_directory dir)

let rec build t ~dst =
  match t with
  | File file ->
    File.build file ~in_directory:dst

  | Directory (Copy_directory dir) ->
    Process.run_expect_no_output_exn ~prog:"cp"
      ~args:["-r"; dir; dst ^/ Filename.basename dir] ()

  | Directory (Synthetic (name, ts)) ->
    let name' = dst ^/ name in
    let%bind () = Unix.mkdir name' in
    Deferred.List.iter ts ~f:(fun t' ->
      build t' ~dst:name')
