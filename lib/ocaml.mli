val configure : ?prefix:string -> unit -> Bos.Cmd.t

val make_world_opt : jobs:int -> Bos.Cmd.t

val make_install : Bos.Cmd.t
