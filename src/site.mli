open Async.Std

type t

val create : File_system.t list -> t

val build : t -> dst:string -> unit Deferred.t
