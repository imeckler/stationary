open Async.Std

(** This type represents a file in the filesystem that is your site. *)
type t

(** Specify that there ought to be a file with the given name containing
    the given HTML. *)
val of_html : name:string -> Html.t -> t

(** Specify that there ought to be a copy of the file at the given path
    with the given name. If no name is provided the basename of the path
    will be used. *)
val of_path : ?name:string -> string -> t

val build : t -> in_directory:string -> unit Deferred.t

