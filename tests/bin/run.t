Malformed OCaml versions fail

  $ opam sysinstall build --versions=foo
  [ ERROR ] Parsing Compiler Versions
   -- reason: Unable to parse OCaml version 'foo'
  [255]

Versions earlier than 4.08 are parsed, but fail 

  $ opam sysinstall build --versions=4.07
  [ SUCCESS ] Parsing Compiler Versions
  [ ERROR ] Filtered out all OCaml Versions
  [255]

Quiet removes success message 

  $ opam sysinstall build --versions=4.07 --quiet
  [ ERROR ] Filtered out all OCaml Versions
  [255]

Dry run should have something sensible 

  $ opam sysinstall build --latest=1 --dry-run
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.0'
  [ INFO ] './configure'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.0 installed

Filter out any compiler versions less than 4.08 and should add the extra prefix

  $ opam sysinstall build --latest=7 --dry-run
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.0'
  [ INFO ] './configure' '--prefix=/usr/local/4.11.0'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.0 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.10.1'
  [ INFO ] './configure' '--prefix=/usr/local/4.10.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.10.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.09.1'
  [ INFO ] './configure' '--prefix=/usr/local/4.09.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.09.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.08.1'
  [ INFO ] './configure' '--prefix=/usr/local/4.08.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.08.1 installed

Use the user-define prefix 

  $ opam sysinstall build --latest=2 --dry-run --prefix=/data/ocaml
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.0'
  [ INFO ] './configure' '--prefix=/data/ocaml/4.11.0'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.0 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.10.1'
  [ INFO ] './configure' '--prefix=/data/ocaml/4.10.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.10.1 installed

Run with ALL the jobs 

  $ opam sysinstall build --versions=4.11 --jobs=64 --dry-run
  [ SUCCESS ] Parsing Compiler Versions
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11'
  [ INFO ] './configure'
  [ INFO ] 'make' '-j64' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11 installed
