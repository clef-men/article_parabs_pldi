- [x] prophets
  + [x] shorten the section on prophecies
  + [x] move it to a later section of the paper

- [x] vertex
  + [0] move it to an appendix, OR
  + [x] remove it from the paper

- [x] API documentation
  + [x] document the API of Ws_deque
  + [x] document the API of Pool
  + [x] document the API of Future
  + [0] document the API of Vertex (in appendix)
  + [~] document the API of Algo iterators

- [x] benchmarks
  + [x] tweak Fibonacci benchmarks and include Taskflow baseline

- [ ] verified examples
  + [ ] counter (using Pool)
  + [x] fibonacci (using Futures)

- [ ] writing clarifications
  + [x] "reason about termination" => completion
  + [0] "liveness": reformulate/clarify
  + [x] include code- and proof-line estimates in the paper
  + [ ] discuss persistent vs. non-persistent outputs for Pool and Future
    note: we added 'consumer' to Pool as well for consistency
  + [x] use the improved specification without the 2.depth+1 laters
  + [G] consider saying more about 'wait' using the callstack

- extra citations from the author response
  - [G] CertikOS + compare-and-swap
  - [G] others? see the author response

- [x] latexdiff

- [ ] go over reviews to check for remaining comments
