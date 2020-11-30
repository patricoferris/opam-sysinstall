open Bos

let configure ?prefix () =
  match prefix with
  | None -> Cmd.v "./configure"
  | Some prefix -> Cmd.(v "./configure" % ("--prefix=" ^ prefix))

let make_world_opt ~jobs =
  Cmd.(v "make" % ("-j" ^ string_of_int jobs) % "world.opt")

let make_install = Cmd.(v "make" % "install")
