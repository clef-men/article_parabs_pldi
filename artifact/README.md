This archive contains our PLDI'26 artifact for the paper

  A verified parallel scheduler for OCaml 5
  https://clef-men.github.io/drafts/parabs.pdf

It is built of archives downloaded as-is from the web by the
'populate.sh' script:

- our main repository of code, proofs and benchmarks
  https://github.com/clef-men/zoo/tree/pldi26-artifact
  (which depends on specific versions of Rocq and Iris, as
   indicated in the packaging information)
  See its [README.md](https://github.com/clef-men/zoo/blob/pldi26-artifact/README.md) for instructions.

- the paper itself, which contains precise links to the code and proofs throughout

- the sources of an experimental version of the OCaml compiler we use

- the sources of Rocq and all the packages we depend on, at the version we expect

Storing them on Zenodo provides long-term archival, protecting against
changes on our side or Github/Gitlab going away.

We do not provide a virtual machine -- we prefer to ensure that other
people can indeed download and build our software on standard
development systems. Virtual machine images are large and slow, yet
they have a poor track record of remaining usable over time, in
particular through the amd64->arm64 transition of many developers.

