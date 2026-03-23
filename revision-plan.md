- [x] prophets
  + [x] shorten the section on prophecies
  + [x] move it to a later section of the paper

- [x] vertex
  + [ ] move it to an appendix, OR
  + [x] remove it from the paper
  
- [ ] API documentation
  + [ ] document the API of Ws_deque
  + [ ] document the API of Pool
  + [ ] document the API of Future
    (in particular: no direct way to force a Future.iter)
    (note: consider renaming 'kill' which gives the wrong intuition; 'drain'?)
  + [ ] document the API of Vertex (in appendix)
  + [ ] document the API of Algo iterators

- [ ] benchmarks
  + [ ] tweak Fibonacci benchmarks and include Taskflow baseline

- [ ] writing clarifications
  + [ ] "reason about termination" => completion
  + [ ] "liveness": reformulate/clarify
  + [ ] clarify that we verified some simple clients
  + [ ] include code- and proof-line estimates in the paper
  + [ ] discuss persistent vs. non-persistent outputs for Pool and Future
  + [ ] use the improved specification without the 2.depth+1 laters
  + [ ] consider saying more about 'wait' using the callstack

- [ ] go over reviews to check for remaining comments
