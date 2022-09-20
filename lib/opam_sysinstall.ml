open Bos
open Rresult.R.Infix
module Ov = Ocaml_version

let error ppf s = Fmt.(pf ppf "[ %a ] %s\n%!" (styled `Red string) "ERROR" s)

let success ppf s =
  Fmt.(pf ppf "[ %a ] %s\n%!" (styled `Green string) "SUCCESS" s)

let handle_error quiet s = function
  | Ok t ->
      if quiet then t
      else (
        success Fmt.stdout s;
        t )
  | Error (`Msg e) ->
      Fmt.pf Fmt.stdout "%a -- reason: %s" error s e;
      exit (-1)

let info ppf s = Fmt.(pf ppf "[ %a ] %s\n%!" (styled `Cyan string) "INFO" s)

let check_versions = function
  | Some s -> s
  | None ->
      Fmt.pf Fmt.stdout "%a" error
        "Expected either OCaml versions (e.g. --versions=4.10,4.11) or the \
         number of latest versions to install (e.g. --latest=3)";
      exit (-1)

let bound_check ocv = Ov.compare ocv Ov.Releases.v4_00 >= 0

let first_n n =
  let rec aux m acc = function
    | [] -> List.rev acc
    | _ when m <= 0 -> List.rev acc
    | x :: xs -> aux (m - 1) (x :: acc) xs
  in
  aux n []

let info_run ?env ?err ?(no_log = false) cmd =
  info Fmt.stdout (Cmd.to_string cmd);
  OS.Cmd.in_stdin
  |> OS.Cmd.run_io ?env ?err cmd
  |> if no_log then OS.Cmd.to_null else OS.Cmd.to_stdout

let run ocvs latest conf quiet no_log jobs dry_run =
  let ocvs =
    if List.length ocvs = 0 then
      first_n (check_versions latest) (Ov.Releases.recent |> List.rev)
    else
      List.map
        (fun v ->
          Ov.of_string v |> handle_error quiet "Parsing Compiler Versions")
        ocvs
  in
  let ocvs = List.filter bound_check ocvs in
  let build_cmds = Opam.build_cmds ocvs in
  let len = List.length ocvs in
  if len = 0 then (
    error Fmt.stdout "Filtered out all OCaml Versions";
    exit (-1) |> ignore );
  let mk_prefix ocv =
    match conf.Ocaml.prefix with
    | Some p ->
        if len > 1 then Some (Filename.concat p (Ov.to_string ocv)) else Some p
    | None ->
        if len > 1 then Some (Filename.concat "/usr/local" (Ov.to_string ocv))
        else None
  in
  let r =
    if dry_run then fun ?env:_ ?err:_ cmd ->
      Ok (info Fmt.stdout (Bos.Cmd.to_string cmd))
    else if quiet then OS.Cmd.run
    else info_run ~no_log
  in
  let dry f = if dry_run then Ok () else f () in
  let run_list r lst =
    let rec aux xs () =
      match xs with [] -> Ok () | x :: xs -> r x >>= aux xs
    in
    aux lst ()
  in
  let f tmpdir ocv =
    let pre_configure =
      List.find (fun (o, _) -> Ov.equal o ocv) build_cmds |> snd
    in
    let res =
      dry (fun () -> OS.Dir.set_current tmpdir) >>= fun () ->
      r @@ Opam.source_compiler ocv >>= fun () ->
      dry (fun () ->
          OS.Dir.set_current
            Fpath.(tmpdir / ("ocaml-base-compiler." ^ Ov.to_string ocv)))
      >>= fun () ->
      let conf = { conf with prefix = mk_prefix ocv } in
      run_list r
        ( pre_configure
        @ [
            Ocaml.configure ocv conf;
            Ocaml.make_world_opt ~jobs;
            Ocaml.make_install;
          ] )
    in
    res
    |> handle_error quiet ("system compiler " ^ Ov.to_string ocv ^ " installed")
  in
  List.iter
    (fun ocv ->
      OS.Dir.with_tmp "opam-sysinstall-%s" f ocv |> handle_error true "")
    ocvs

open Cmdliner

let ocvs =
  let doc = "OCaml version to build and install" in
  Arg.(
    value & opt (list string) [] & info ~docv:"OCVS" ~doc [ "versions"; "v" ])

let quiet =
  let docv = "QUIET" in
  let doc = "Don't print any success or info messages, only failure ones" in
  Arg.(value & flag & info ~doc ~docv [ "quiet"; "q" ])

let dry_run =
  let docv = "DRY-RUN" in
  let doc = "Just print information, don't actually do anything" in
  Arg.(value & flag & info ~doc ~docv [ "dry-run"; "d" ])

let no_log =
  let docv = "NOLOG" in
  let doc = "Put OCaml compiler log to null" in
  Arg.(value & flag & info ~doc ~docv [ "no-log"; "n" ])

let latest =
  let docv = "LATEST" in
  let doc = "Install the `n' latest compiler versions" in
  Arg.(value & opt (some int) None & info ~doc ~docv [ "latest"; "l" ])

let jobs =
  let docv = "JOBS" in
  let doc = "Use `n' jobs when bulding the compiler" in
  Arg.(value & opt int 1 & info ~doc ~docv [ "jobs"; "j" ])

let info =
  let doc = "Build and install a system compiler." in
  Cmd.info ~doc "build"

let term =
  Term.(
    const run $ ocvs $ latest $ Ocaml.cmdliner $ quiet $ no_log $ jobs $ dry_run)

let cmds = Cmd.v info term

let main =
  let doc = "Opam plugin for installing system compilers" in
  let info = Cmd.info "opam-sysinstall" ~doc in
  let default = Term.ret @@ Term.const (`Help (`Pager, None)) in
  Cmd.group info ~default [ cmds ]

let cli () =
  Fmt_tty.setup_std_outputs ();
  exit (Cmd.eval main)
