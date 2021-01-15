module Ov = Ocaml_version

type t = { prefix : string option; cc : string option }

module type Configure = sig
  val cmdliner : t Cmdliner.Term.t

  val to_list : t -> string list

  val configure : t -> Bos.Cmd.t
end

val cmdliner : t Cmdliner.Term.t
(** Creating an OCaml configuration from the command line *)

val configure : Ov.t -> t -> Bos.Cmd.t
(** [configure ocv conf] provides a command to run to configure a particular
    version of OCaml. This plugin is trying to cater to older (pre-autoconf)
    versions of the compiler too. *)

val make_world_opt : jobs:int -> Bos.Cmd.t

val make_install : Bos.Cmd.t
