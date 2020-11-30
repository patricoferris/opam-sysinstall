(lang dune 2.7)

(cram enable)

(name opam-sysinstall)

(generate_opam_files true)

(source
 (github patricoferris/opam-sysinstall))

(license ISC)

(authors "Patrick Ferris")

(maintainers "pf341@patricoferris.com")

(package
 (name opam-sysinstall)
 (synopsis "Plugin to add install OCaml system compilers")
 (description
   "This opam plugin allows you to install a set of OCaml system compilers to a prefix of your choosing")
 (depends bos ocaml-version fmt cmdliner))
