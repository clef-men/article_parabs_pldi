# The 'zoo' monorepo (which contains our code, proofs and benchmarks)
wget https://github.com/clef-men/zoo/archive/refs/heads/pldi26-artifact.zip

# Our research paper that contains fine-grained links to the OCaml code and Rocq proofs
wget https://clef-men.github.io/drafts/parabs.pdf

# our experimental branch of OCaml with some specific concurrency
# features we added for programming and verification; in the build
# instructions of 'zoo' it is fetched from the web, but you can also get it from this archive
wget https://github.com/clef-men/ocaml/archive/refs/heads/generative_constructors.zip -O ocaml-compiler-with-generative-constructors.zip

# standard Rocq dependencies, as found in 'rocq-zoo.opam'
mkdir -p rocq-dependencies
cd rocq-dependencies

for dep in \
  coq-core.9.1.1 \
  rocq-prover.9.0.0 \
  rocq-stdpp.dev.2026-01-28.0.6f3f2617 \
  rocq-iris.dev.2026-02-05.0.9815f03b \
  rocq-diaframe.dev.2026-02-11.0.bb960675
do
  opam source $dep
  tar cvJf $dep.tar.xz $dep
  rm -fR $dep
done
