open Bos 
module Ov = Ocaml_version

let opam = Cmd.v "opam"

let source_compiler ocv =
  Cmd.(opam % "source" % ("ocaml-base-compiler." ^ Ov.to_string ocv))