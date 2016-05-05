open Async.Std

type t

val of_html : name:string -> Html.t -> t

val of_path : string -> t

val build : t -> in_directory:string -> unit Deferred.t

