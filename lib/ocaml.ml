open Bos
module Ov = Ocaml_version

type t = { prefix : string option; cc : string option }

module type Configure = sig
  val cmdliner : t Cmdliner.Term.t

  val to_list : t -> string list

  val configure : t -> Cmd.t
end

(* 4.08+ *)
module Auto_Conf : Configure = struct
  open Cmdliner

  let prefix =
    let docv = "PREFIX" in
    let doc =
      "The ./configure prefix parameter to use -- defaults to OCaml's built-in \
       default"
    in
    Arg.(value & opt (some string) None & info ~doc ~docv [ "prefix"; "p" ])

  let cc =
    let docv = "CC" in
    let doc = "C compiler to use for building the system" in
    Arg.(value & opt (some string) None & info ~doc ~docv [ "cc" ])

  let cmdliner =
    let make prefix cc = { prefix; cc } in
    Term.(const make $ prefix $ cc)

  let to_list t =
    [ ("prefix", t.prefix); ("cc", t.cc) ]
    |> List.filter (fun (_, v) -> Option.is_some v)
    |> List.map (function
         | k, Some v -> Fmt.str "--%s=%s" k v
         | _ -> assert false)

  let configure t =
    let mk_list = to_list in
    Cmd.(v "./configure" %% of_list (mk_list t))
end

module Old_Conf : Configure = struct
  include Auto_Conf

  let to_list t =
    [ ("-prefix", t.prefix); ("-cc", t.cc) ]
    |> List.filter (fun (_, v) -> Option.is_some v)
    |> List.map (function k, Some v -> [ k; v ] | _ -> assert false)
    |> List.flatten

  let configure t =
    let mk_list = to_list in
    Cmd.(v "./configure" %% of_list (mk_list t))
end

let cmdliner = Auto_Conf.cmdliner

let configure ocv =
  match Ov.compare ocv (Ov.v 4 8) with
  | n when n >= 0 -> Auto_Conf.configure
  | _ -> Old_Conf.configure

let make_world_opt ~jobs =
  Cmd.(v "make" % ("-j" ^ string_of_int jobs) % "world.opt")

let make_install = Cmd.(v "make" % "install")
