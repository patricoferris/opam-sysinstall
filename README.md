opam-sysinstall
---------------

A small opam plugin for installing OCaml system compilers. The simplest way to use this is: 

```
$ opam sysinstall build --versions=4.11.0
```

This will build and install [base compiler](https://opam.ocaml.org/packages/ocaml-base-compiler/) `4.11.0` with OCaml's [default prefix](https://github.com/ocaml/ocaml/blob/trunk/INSTALL.adoc#configuration). You can specify the prefix by passing the options `--prefix` parameter. 

For a good overview of what is possible have a look at `tests/bin/run.t` for the cram test using `--dry-run`. 

### Installing More Versions

If you want to install more than one version of the system compiler you can do this in two ways. Either comma-separated via the `--versions` parameter or by using `--latest=n` which will try to install the latest `n` system compilers. In order to distinguish them the version will be added to `--prefix` and if no prefix is given then `/usr/local` will be used. 