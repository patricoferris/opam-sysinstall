(lang dune 2.7)
(cram enable)
(generate_opam_files true)
(name opam-sysinstall)
(source (github patricoferris/opam-sysinstall))
(license ISC)
(authors "Patrick Ferris")
(maintainers "pf341@patricoferris.com")
(package
 (name opam-sysinstall)
 (synopsis "Plugin to add install OCaml system compilers")
 (description
  "This opam plugin allows you to install a set of OCaml system compilers to a prefix of your choosing")
 (depends
  (opam-state (>= 2.1.0~beta2))
  (opam-format (>= 2.1.0~beta2))
  (opam-core (>= 2.1.0~beta2))
  (opam-client (>= 2.1.0~beta2))
  bos
  ocaml-version
  fmt
  (cmdliner (>= 1.1))))
