open Async.Std

type t

val file : File.t -> t

val directory : string -> t list -> t

val copy_directory : string -> t

val build : t -> dst:string -> unit Deferred.t
