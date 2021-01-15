Malformed OCaml versions fail

  $ opam sysinstall build --versions=foo
  [ ERROR ] Parsing Compiler Versions
   -- reason: Unable to parse OCaml version 'foo'
  [255]

Dry run should have something sensible 

  $ opam sysinstall build --latest=1 --dry-run
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.1'
  [ INFO ] './configure'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.1 installed

Filter out any compiler versions less than 4.02 and should add the extra prefix

  $ opam sysinstall build --latest=10 --dry-run
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.1'
  [ INFO ] './configure' '--prefix=/usr/local/4.11.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.10.2'
  [ INFO ] './configure' '--prefix=/usr/local/4.10.2'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.10.2 installed
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
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.07.1'
  [ INFO ] './configure' '-prefix' '/usr/local/4.07.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.07.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.06.1'
  [ INFO ] './configure' '-prefix' '/usr/local/4.06.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.06.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.05.0'
  [ INFO ] './configure' '-prefix' '/usr/local/4.05.0'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.05.0 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.04.2'
  [ INFO ] './configure' '-prefix' '/usr/local/4.04.2'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.04.2 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.03.0'
  [ INFO ] './configure' '-prefix' '/usr/local/4.03.0'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.03.0 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.02.3'
  [ INFO ] './configure' '-prefix' '/usr/local/4.02.3'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.02.3 installed

Use the user-define prefix 

  $ opam sysinstall build --latest=2 --dry-run --prefix=/data/ocaml
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11.1'
  [ INFO ] './configure' '--prefix=/data/ocaml/4.11.1'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11.1 installed
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.10.2'
  [ INFO ] './configure' '--prefix=/data/ocaml/4.10.2'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.10.2 installed

Run with ALL the jobs 

  $ opam sysinstall build --versions=4.11 --jobs=64 --dry-run
  [ SUCCESS ] Parsing Compiler Versions
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11'
  [ INFO ] './configure'
  [ INFO ] 'make' '-j64' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11 installed

Add cc option 

  $ opam sysinstall build --versions=4.11 --cc=gcc --dry-run
  [ SUCCESS ] Parsing Compiler Versions
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.11'
  [ INFO ] './configure' '--cc=gcc'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.11 installed

Older versions of the compiler render differently

  $ opam sysinstall build --versions=4.07.0 --prefix=/home/ocaml --cc=gcc --dry-run
  [ SUCCESS ] Parsing Compiler Versions
  [ INFO ] 'opam' 'source' 'ocaml-base-compiler.4.07.0'
  [ INFO ] './configure' '-prefix' '/home/ocaml' '-cc' 'gcc'
  [ INFO ] 'make' '-j1' 'world.opt'
  [ INFO ] 'make' 'install'
  [ SUCCESS ] system compiler 4.07.0 installed
