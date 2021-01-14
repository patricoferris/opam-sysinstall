open Bos
module Ov = Ocaml_version

let opam = Cmd.v "opam"

let source_compiler ocv =
  Cmd.(opam % "source" % ("ocaml-base-compiler." ^ Ov.to_string ocv))

let get_opam_file ocv =
  let show =
    Cmd.(opam % "show" % "--raw" % ("ocaml-base-compiler." ^ Ov.to_string ocv))
  in
  OS.Cmd.(to_string (run_out show)) |> function
  | Ok t -> t
  | Error (`Msg m) -> failwith m

let build_cmds ocvs =
  OpamClientConfig.opam_init ();
  OpamGlobalState.with_ `Lock_none @@ fun gt ->
  OpamSwitchState.with_ `Lock_read gt @@ fun t ->
  let filter opam t =
    OpamFilter.commands
      (OpamPackageVar.resolve ~opam ~local:OpamVariable.(Map.of_list []) t)
  in
  let build opam =
    let pkg =
      OpamFile.OPAM.read_from_string opam
      |> OpamFile.OPAM.with_name
           (OpamPackage.Name.of_string "ocaml-base-compiler")
    in
    let cmds = OpamFile.OPAM.build pkg in
    cmds |> filter pkg t
  in
  let filter_before_configure lst =
    let rec aux acc = function
      | [] -> List.rev acc
      | ("./configure" :: _) :: _ -> List.rev acc
      | x :: xs -> aux (x :: acc) xs
    in
    aux [] lst
  in
  List.map
    (fun ocv ->
      ( ocv,
        build (get_opam_file ocv)
        |> filter_before_configure |> List.map Cmd.of_list ))
    ocvs
