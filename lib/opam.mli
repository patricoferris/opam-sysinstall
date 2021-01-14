val source_compiler : Ocaml_version.t -> Bos.Cmd.t
(** A command to get the source code for a specific version of an OCaml compiler *)

val build_cmds : Ocaml_version.t list -> (Ocaml_version.t * Bos.Cmd.t list) list
(** [build_cmds ocv] gets the commands to run before [configure] from the OCaml
    base compiler opam file *)
