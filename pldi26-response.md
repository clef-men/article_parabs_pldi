We thank the reviewers for their time and work on our submission, and their thoughtful feedback. We split our response in two parts, first a high-level summary that includes presentation change proposals, and then per-review detailed answers -- that are longer and, of course, optional.

## High-level comments

You had several remarks on the presentations which could be improved. This is a difficult problem because there is a relatively large amount of program-verification material, and we have to choose what to present, which more technical aspects to zoom in, etc. We are happy to revisit the existing presentation choices with the guidance/suggestions of our reviewers.

We collected the following key remarks on the structure and presentation choices:

- you would like a clearer choice of intended audience for the presentation

- you would welcome a description of how to program with the various libraries, before we get into their specification

- you were globally less convinced by the more technical/detailed section on prophecy variables, and by our section on the Vertex / DAG-calculus implementation.

On the question of the audience: we think that the paper should be optimized for the researchers who are most likely to reuse our work, directly or through its concepts. This suggests that our primary audience should be people working on program verification, in particular of fine-grained concurrent algorithms; and if possible a secondary audience would be expert authors of parallel programs that would be curious to know which implementation choices are more amenable to verification, or which aspects of their work can realistically be verified today. (In particular, the audience is _not_ users of OCaml 5, they should look for dedicated tutorials on how to write concurrent programs.)

In particular we do believe that advanced patterns of prophecy variables have their place in the paper, because they encapsulate subtle proof techniques for concurrent data structures that are likely to be useful to other people verifying other data structures in Iris. Having been exposed, even briefly, to the abstractions we introduce can help them recognize verification patterns in their work and save them substantial time and effort. On the other hand, it was perhaps a mistake to put them in front position in Section 2, while it is more technical content that in particular is hardly relevant for readers with no Iris expertise. (The placement comes from the fact that they are used in the proof of Chase-Lev, and we followed a sort of dependency order from lower building blocks to higher-level abstractions.) We propose to reduce the space given to prophecy variables (prophets) and move them to a later section of the paper.

We agree that taking some space to present the APIs and possibly simple usage examples before going into the specification would make the presentation more approachable, even to experts. We are considering moving the Vertex section to an appendix or removing it entirely to make space for more informal explanations of the other building blocks. (It is also arguably weaker than the rest in that we have not explored using it in practice much, which relates to review B's criticism that we should discuss and expose verified clients as well). This is not a light decision, as a formal implementation of the DAG-calculus is a not-insignificant scientific contribution that would in effect be dropped from the paper; we would appreciate guidance from our reviewers on this.

To summarize, we propose to:

- shorten the section on prophecies and, if it remains very Iris-technical, move it to a later section of the paper
- if the reviewers agree, remove the section on Vertex or at least move it to an appendix
- use the extra space for more informal explanation/document of how to use each API being presented

; note that we already have longer-form descriptions of this material in writing, so adding more detailed content the OCaml APIs in particular does not require writing fully new content.

## Detailed per-review comments (option)

### Review A

> In some cases, I went looking for the interfaces in the anonymized repo and was a bit disappointed to find they weren't commented.

Thanks for giving concrete evidence that providing an anonymized repo was useful!

> * The most notable instance of the above is the use of execution contexts in the Pool specification in order to work around the lack of algebraic effects. While I have some intuition for how these are used, I would have liked more detail in the paper, particularly on how this difference in the interface would affect users of the scheduler (e.g., does it only impact designers of new higher-level parallelism libraries like Futures and Vertex or does it bleed into those interfaces as well)?

The fact that a global 'context' parameter has to be passed around is not uncommon in library-based schedulers. For example TaskFlow functions will pass a `tf::Runtime&` parameter to functions creating new asynchronous tasks. The 'Pool.context' parameter does leak into the API of Future and Vertex which also require a contex. Some programmer appreciate API designs where functions explicitly demand the capability to schedule asynchronous computations; others may want to de-emphasize this aspects by hiding the context as a global/singleton in their application, or using programming-language support for implicit but type-tracked parameter passing (Scala's implicit parameters, or the Reader monad in Haskell for example).

Note: we were unsure what you had in mind about "the lack of algebraic effects". Algebraic effects are useful in some APIs that expose a `yield` operation that would otherwise have to take an explicit continuation parameter. But we would not typically use an effect handler just for dynamic binding, recovering a `context` parameter. And for example Domainslib, which does rely on algebraic effects internally to implement `await`, still has an API where a `pool` parameter is passed around explicitly: https://github.com/ocaml-multicore/domainslib/blob/main/lib/task.mli

> Fig. 13 Maybe I'm missing something about how to read these rules, but I would have expected something else in the postcondition of Vertex-release-spec

The specification of Vertex-Release-Spec does not tell you that the node you release will eventually run, for good reasons: we cannot know at this point whether it will ever run, as it depends on the dependencies of the node.

One may then wonder how to acquire a `finished` proposition for a given node. It is a bit tricky to see, but if you want to know when a given node N is finished, you can attach a successor O (for 'observer') to that node, set to O a `task` that you want to perform when N is finished, and release O. In the `wp` conditions for that "release" call, you know that S will be `ready` when `task` runs, and you know that `predecessor N O` holds, so you can use the rule Vertex-Predecessor-Finished to learn that N is `finished`.

> 1. Who do you feel is the intended audience of this paper (presumably a proper subset of the PLDI audience)?

We tried to answer this point in our high-level discussion above.

> 2. Can you go into more detail on the execution contexts, particularly their impacts on users of the library (see above)?

We tried to discuss this above.

> 3. How easily do you feel the proof is reusable for other parallel schedulers and/or extensions of Parabs?

We strived to have a clean architecture in the code and in the mechanization as well, with separate building blocks with a clear specification -- changing one of the blocks does not require touching the others as long as specifications are preserved. We already show that experimenting with different scheduling policies is possible, and we believe that for other changes as well it would be reasonably easy to reuse, adapt or extend our work. (Relatively to the fact that, in mechanized verification, everything is hard.)

The easiest form of reuse would be to build verified algorithms on top of Parabs and its high-level specification. In particular, the DAG-calculus was originally proposed as a lingua franca for some task abstractions, we believe that verifying concurrency models that can be expressed on top of our Vertex module should be relatively easy.

> 4. How challenging were the verifications of the implementations, once the specifications were worked out? Are there any interesting points/key invariants?

Very challenging! Finding the right invariant is usually the key difficult, and we proceed iteratively (pick a reasonable invariant, try to do a pen-and-paper proof, see where that breaks, refine the invariant and loop until fixpoint). For reasons of space we chose to expose specifications in the paper, and mostly keep the invariants in the mechanized artifact only, with the exception of the Chase-Lev invariant which we believe is a significant, reusable contribution.

The "wise prophets" and "multiplexed prophets" that we present in Section 3 may look like technical details to Iris non-users, but they capture non-trivial proof patterns that we had to invent to verify complex linearization patterns, going beyond what had already been done in the Iris literature. We believe that they could be useful to other people doing mechanized verification (using prophecy variables, which now exist in other logics than Iris) of concurrent programs, and plan to propose them for integration in common Iris libraries.

We hope that the paper can serve as a high-level exposition to the Rocq development, which we view as a key artifact integrated to the scientific contribution. We hope that interested experts will get the high-level idea from the paper first, and use the pointers to navigate to the mechanized proofs to reuse and adapt our work.

> 5. Would it be possible to extend the proof to give a quantitative verification of the scheduler's performance (like Arora, Blumofe and Plaxton [SPAA '98]'s bound for a work-stealing scheduler)?

Our best guess would be that this is possible but likely to be quite difficult, due to difficulties about reasoning about fairness in state-of-the-art concurrent program logics.

We already know that Iris is a reasonable setting to reason about algorithmic complexity in time or space ( see for example https://iris-project.org/pdfs/2019-esop-time.pdf ), and there have been mechanized proofs of complexity-efficient scheduling policies ( for example https://www.chargueraud.org/research/2018/heartbeat/heartbeat.pdf ). (The SPAA'98 proof is with an idealized model of the program and its scheduler, the 'heartbeat' proof uses an abstract machine with an axiomatic treatment of the scheduler; both are far more idealized than an actual scheduler implementation as we present in our work.)

However, lock-free data structures such as the one we use in our implementation are known to create difficulties to reason about termination (and more precise quantiative properties), because their termination relies on a fairness assumption. (The original proof of Arora, Blumofe and Plaxton also needs fairness-like assumptions.) This is discussed in depth in https://www.cs.cmu.edu/~janh/papers/lockfree2013.pdf , and/but currently standard Iris does not provide pleasant tools to reason about fairness and thus state quantitative properties of lock-free implementations. (Our implementation of work-stealing also uses random-number generation to select dequeues to steal from, which would also require fairness assumptions / working with probabilities.)

Remark: Iris is a partial logic so it is non-intuitive that it can be used to prove complexity results, even in settings that do not need to make global fairness assumptions. The time-credits paper we mention earlier has interesting discussions on this; the gist is that (1) the complexity is proved with respect to a number of `tick` instructions that have to be carefully inserted in the program (in particular "silent" loops without ticks could still diverge in a proven-correct program), and (2) proving a precise bound on termination steps as a function of the input (which can then be weakened into a complexity-class result) can turn termination from a liveness property (hard in Iris) to a safety property (easy in Iris), by stating that "no execution path will `tick` more than `f(N)` times".

### Review B

> The second half of the paper is hard to follow even for someone with solid Iris
> experience: the authors seem to assume that the reader already knows how the
> APIs described there are meant to be used, but that is far from clear. Without
> this knowledge, it is difficult to make sense of the specifications.

Apologies for the suboptimal presentation choice. As discussed in our high-level response, we will incorporate API descriptions in the presentation.

> There is no mention of verified clients using these APIs. Space limits preclude
> actually discussing such a client in great detail, but given how easy it is to
> come up with a useless specification, it would still be desirable to verify some
> examples and then just briefly mention them in the text.

We verified the parallel iterators (in paraticular a parallel-for) mentioned in Section 12, which are themselves clients of the Future interface. They are in an Algo module

  interface: https://anonymous.4open.science/r/zoo-A236/lib/zoo_parabs/algo.mli
  implementation: https://anonymous.4open.science/r/zoo-A236/lib/zoo_parabs/algo.ml
  verification: https://anonymous.4open.science/r/zoo-A236/theories/zoo_parabs/algo.v

(Of course, these APIs are convenient to program against but more complex than the direct Future interface, and so their specifications are also a bit of a mouthful.)

Our artifact also includes an implementation of the naive `fibonacci` function using futures

  https://anonymous.4open.science/r/zoo-A236/lib/examples/fibonacci.ml

and a proof that it computes correctly

  https://anonymous.4open.science/r/zoo-A236/theories/examples/fibonacci.v

(Note: the .ml file has two `fibonacci` function with name shadowing, the first is parametrized by a pool and the other wraps it under a simple interface. The first becomes `fibonacci_0` after translation, and the .v file contains proofs about both functions.)

We agree that it would be nice to provide more examples, in particular an example of using the Vertex interface. (But then maybe Vertex will be removed to win space.)

> There is no report on the amount of effort that this verification took. Lines of
> code are not a great metric, but they are better than nothing, and in particular
> the ratio of lines of code vs lines of proof can be quite informative.

A simplistic count (`ls -1 *.v | grep -v '__' | xargs wc -l`) puts `theories/zoo_parabs` at 8900 lines of proofs, with the corresponding implementations (`ls *.ml | xargs wc -l`) at 741 lines, suggesting a 12x code-to-proofs ratio. The work-stealing-related data structures in `zoo_saturn` (`ls *ws*.ml`) exhibit a higher ratio, with 340 lines of code and 7495 lines of proofs, so 22x more proofs.

We are unsure what conclusions to draw from the code-to-proofs ratio. Having massively more proofs than code can be the sign of a lack of attention to proof engineering, for example missed opportunities in proof automation. It can also be the sign of a fundamentally hard problem domain. Of course we believe the second explanation more: we are careful about proof engineering, yet lock-free data structures are exceptionally good at packing quite the verification difficulties in a relatively small number of lines of code. This argument explains why the core data-structure code in `zoo_saturn` has a worse ratio than the scheduler code in `zoo_parabs`.

> - Line 62: Multiple times throughout the paper, the authors mention that the
> stronger spec is needed to "prove termination". However, given that this paper
> uses Iris and that there is no discussion of termination results, I assume no
> proof of termination happened. This is quite misleading and should be clarified.

We agree that our wording was misleading and we will rephrase this.

The proofs were done in a partial-correctness logic, so of course we do not prove termination of the scheduler and we should reformulate -- it was never our intent to suggest this.

What we were trying to say (in a few words) is the following: the API exposes a way to block until all the tasks owned by a scheduler have terminated (and to then prevent the scheduler from accepting new tasks). In this case we want to recover all the resources that were previously owned by those tasks. Reasoning about this requires the stronger specification for Chase-Lev. So here "termination" should not be understood as "we prove formally that running the tasks eventually terminate", but "we let you reason correctly about the point where all tasks have terminated". We should have written that we can "reason after termination", rather mistakenly suggesting that we "prove termination"; maybe "completion" would be a better terminology to avoid the confusion.

> - Line 423: I assume those liveness properties have not been verified? This
> should be clarified.

Our formulation is confusing and we will clarify. What we had in mind when writing this is a different notion of 'liveness' from GC-ed languages: it is bad to retain user-provided values in "unused" slots of a data structure, as it could keep memory alive longer than necessary. The usual trick, which is used by the OCaml data structures of the Saturn library, is add an indirection through a separate memory block in which a `null` (poetically called `Obj.magic ()`) is written after `pop` to recover good "liveness" (in that sense) properties.

Note: The implementation we provided in our artifact does not in fact implement this extra erasing write in `ws_deque_2.ml` -- we did verify this in an earlier version, and during a later rewriting in Zoo this subtlety of the implementation was lost. This is a small mistake on our part that is easy to fix, and which we will address shortly -- it is not hard to add these erasing writes and prove them correct, as the proof setup is done precisely to make this easy.

From the perspective of the paper this is a technical detail, but it leaks through the choice of public postconditions of the `Ws_deque` specification, which we thought was worth mentioning.

> - Line 485: It is not clear to me what is meant by "stable" and "unstable"
> states. I first thought the authors referred to stable/unstable propositions in
> separation logic, but this seems to be something else.

The 'unstable' states correspond to states of the data-structure that can only be observed transiently while concurrent operations on the structure are ongoing. When a program has reached a quiescent state where no operations are ongoing, only stable states may be observed.

(Suggestions for better terminology are welcome; by default we can just state the above more clearly in the paper.)

> - Line 642: Why is the postcondition P of the task in `async` (and in
> `obligation`) apparently always persistent? Why can a task not return exclusive
> ownership?

We designed the Pool interface with the intent to build Future on top of it. With Future you can indeed have non-persistent outputs, so programming examples which require non-persistent outputs are convenient to implement and verify. Doing so directly at the level of Pool is less pleasant (it requires an extra encoding), we could indeed extend the specification a bit to add non-persistent outputs for `async` and make it more direct -- we would be happy to make this change.

An example of program that benefits from non-persistent outputs (and is thus easy to implement on top of our Future, and less easy to implement on top of Pool directly as the non-persistent part must go through an invariant) is 'quicksort', as implemented for example in the PulseCore paper ( https://dl.acm.org/doi/pdf/10.1145/3729311 ) page 21: to know that the `async` task is finished sorting both halves of the array, they call `teardown_pool`, and at this point they want to obtain a non-persistent property. (This also relates to the previous discussion on the need to reason "after completion".)

> - Line 664: How does wait_until behave and how is it used? It seems to support
> waiting until an arbitrary opaque predicate becomes true -- so does it just
> busy-wait, or is it somehow integrated with the scheduler?

This is integrated in the scheduler -- one can think of a user-level equivalent of pthreads condition variables. The scheduler calls the predicate periodically when it considers re-running this task.

(It would be reasonable to also implement more specialized waiting functions whose users would be directly awakened in 'push' fashion, instead of checking in 'pull' mode as in this maximally-expressive version.)

> - Line 728: Here I got quite lost. Apparently futures can have "callbacks"
> attached to them via `iter`? What are those for and when do they get triggered?
> The systems for futures I have encountered in other languages have no such
> mechanism. I tried to reverse engineer this from the specification but was not
> successful.

Future.iter and Future.map are analogous to List.iter and List.map. `iter` runs a callback on the result, but the callback itself returns no result. The callback of `map` returns a value, and `map` itself returns a future to that value.

In lib/zoo_parabs/future.mli:

    val iter : Pool.context -> 'a t -> ('a -> unit) Pool.task -> unit
    val map : Pool.context -> 'a t -> ('a -> 'b) Pool.task -> 'b t

We will try to integrate these APIs in the paper, as suggested previously.

> - Line 747: What is going on with the later modalities here?

We improved on this slightly in the current version of our development, without the `2.depth+1` nesting.
TODO

> - Line 780: Why are persistent and non-persistent output predicates separated?

The idea was to make the interface more convenient to use. This follows the design
patterns of `ivar` in the Zoo standard library.

> - Line 782: Why is there this level of indirection between `inv` and `result`
> and `consumer`? Apparently the goal is to be able to split up the postcondition
> so different parties can own parts of the postcondition of the same async task;
> this could be explained more explicitly -- but more importantly, it is not
> motivated. And then there's also `obligation` which I did not understand at all,
> since it isn't even clear what `iter` actually *does* operationally.

TODO explain `obligation`.

> - Line 802: I got quite lost here. When would they be nested?

TODO show a simple example that uses 'wait' to explain the nesting problem.


> Questions for author response

We believe that your three questions (clients; proof effort and code-to-proofs ratio; reasoning about task completion) have been discussed in response to your longer-form comments above. Thanks for the nice questions!


### Review C

We would like to emphasize that the contribution of our work is not an interesting new work-stealing scheduler as an OCaml 5 library, it is the _verification_ of a realistic scheduler modelled after Domains a pre-existing OCaml library (not written by us). The implementation we verify was done by us (with strong inspiration by Domainslib), designed to have clean building blocks to facilitate verification, but we certainly do not claim that it improves over the state-of-the-art of (unverified) concurrent schedulers.

We reviewed our explicit 'Contributions' paragraph after the feedback from this review; we believe that it does not claim any progress on parallel scheduling implementation techniques, and that it correctly claims _verification_ contributions. We stand by our main claim regarding the implementation: "this is the first verified implementation of a parallel work-stealing task scheduler (for any language) using realistic implementation techniques."

> Strengths
> ---------
> Useful accounts for OCaml audience

We are not aware of fully-verified parallel work-stealing schedulers for _any_ programming language, so we believe our results are interesting beyond an OCaml audience. For example Go or GHC or Cilk runtime authors considering formal verifications, of people considering correctness-critical usage of concurrency libraries such as TaskFlow for C++, Rust `async` schedulers, etc.

> Weaknesses
> ----------
> Incremental progress on parallel scheduling issues

We would like to emphasize that the claimed contribution of this work is the mechanized _verification_ of a realistic implementation. The implementation itself is not novel (it closely follows an existing OCaml library, Domainslib), and should look relatively standard and unsophisticated to parallel-scheduling experts. On the other hand, the formal verification of such an implementation is a significant achievement.

Note: the original inspiration for our implementation, Domainslib, is not our own work, it has been benchmarked for scalability in the past (in particular the benchmarks in https://dl.acm.org/doi/10.1145/3408995 used an earlier version of Domainslib) and received attention and profiling/optimization work from parallelism experts.

> Verification (sec 2-4): The paper should make clear up front exactly what properties are being verified (especially given discussions in sec5+). A simple table or list in sec 1 or 2 would help identify those properties required for any of the many possible variations in implementation.

We verify functional correctness, in a partial-correctness logic: formally we prove that programs run (possibly forever) without crashing, and if it terminates it satisfies the specified postcondition.

Of course one would naturally ask: functional correctness, but with respect to what specification? The answer is a bit of a mouthful, for example the specification of the function `Pool.wait_until` exposed by the Pool interface is given by Pool-Wait-Until-Spec in Figure 11 page 14; informally, it tells us that if `wait_until ctx pred` is called in presence of a concurrency context variable `ctx`, and `pred : unit -> bool` correctly checks whether a certain logical property `P` holds, then when `wait_until ctx pred` returns we know that `P` holds (in particular, we own any logical state included in `P`). The figures 11, 12, 13 are key because they expose precisely what we claim to have proven about our scheduling library.

The flexibility that we mention in Section 5 comes from the fact that our scheduler logic is split in several building blocks with well-specified interfaces and interactions. We could verify several possible implementations for the central data-structure of a task pool, and on top of the middle-level `Pool` interface build different higher-level interfaces exposed to users.

> The motivation for introducing Iris extensions seems to be coverage of an omitted property of push in previous work. It's not clear whether this was an oversight that could have been addressed using the methods in those accounts, or whether the introduced Prophet-based techniques are essential. Please explain. I don't have enough expertise with Iris to determine this, or to evaluate its use here.

Proving this stronger specification required a substantial amount of work designing a more precise invariant to capture the lifecycle of Chase-Lev deques, in particular the logical-state protocol of Figure 9 which we believe is a new contribution of our work. This protocol involves a future-dependent linearization point (paragraph 4.1.4). In Iris, future-dependent linearization is addressed using prophecy variables (prophets). But unlike previously verified concurrent data structures (for instance RDCSS), the linearization point involves multiple prophecies corresponding to multiple indices; this is what multiplexed prophets are designed to address. The earlier work on Chase-Lev ( https://arxiv.org/abs/2309.03642 ) proved a weaker specification where a less precise invariant sufficed with a simpler, non-future-dependent linearization point.

> Sec 9: If the FIFO realization used a dequeue in which owners must "steal" their own tasks, then it would fall under the same characterization as others, with breadth-first execution. Is there a reason not to do this?

We do not understand your suggestion well enough to answer it. When we studied concurrent schedulers, we noticed that some (more naive, but used in production nonetheless) use a single global FIFO stack of tasks. This gives a depth-first execution which offers good locality but behaves poorly on fork-join workflows. We reproduced this implementation approach and verified it correct, but would not recommend this implementation choice. Per-thread work-stealing deques (public or private) behave much better: threads steal tasks from each other on the "LIFO" end of each queue, so they steal "larger" tasks in fork-join workflows which is good, while consuming tasks from the "FIFO" end of their own queue, so they preseve good locality for local work.


> Sec 10: The Pool design and implementation seems to need a lot of work. It does not properly handle exceptions, abruptly shutdown, and has no mechanism to support transient blocking.

This is correct, but we consider that it is reasonable to leave as future work. (Note: the verification framework for OCaml that we use in our work, Zoo, does not currently handle exceptions, so our specifications require that client tasks do not raise exceptions to the scheduler.)

Note that the reference library Domainslib that we implemented does not support advanced concerns either -- it does handle exceptions by storing them in the future and then re-raising then on `await`, which we could easily do should Zoo gain support for working with exceptions. The concurrent-library ecosystem of OCaml 5 is still fairly young relatively to more mature multicore languages.

> Sec 11-12: I am confused that sec 10 mentions that the Pool does not support continuations, but the implementation of Futures relies on them? It's also not clear whether these share mechanics with the completion-based VERTEX support.

TODO


> Sec 13 / Appendix. I was surprised not to see a sanity-check comparison with Cilk on the two benchmarks (lu and matmul) that I'm guessing are based on initial Cilk code.

There is probably an ancestral link from the Cilk benchmarks, but our own source of inspiration for our benchmarks was benchmarks from Domainslib and Taskflow, not Cilk directly

  https://github.com/ocaml-multicore/domainslib/blob/main/test/LU_decomposition_multicore.ml
  https://github.com/taskflow/taskflow/blob/master/benchmarks/matrix_multiplication/taskflow.cpp

Note in particular that the `lu` and `matmul` implementation in the benchmarks are extremely simple parallel implementations: it is the cubic algorithm, with one of the for-loop parallel. We looked at the Cilk implementations of `lu` on your suggestion, its block-based implementation is substantially more sophisticated.

We were inspired by the suggestion to perform "sanity checks" using benchmarks implemented by someone else than us, so we built the benchmark `fibonacci.cpp` from the TaskFlow examples directory (we did not build the `matrix_multiplication` benchmark because its build system insists on having TBB available).  https://github.com/taskflow/taskflow/blob/master/examples/fibonacci.cpp

This version has _no_ cutoff, so its performance is dominated by the scheduler overhead with very small tasks. On our machine, this benchmark exactly unchanged takes 5s to compute fib(42), when the implementation we provided takes 8s using Parabs. We modified the taskflow example to use a cutoff value provided as an extra parameter, with cutoff=10 the Taskflow implementation takes 206ms (±8ms) and our Parabs version takes 520ms (±15ms), so it is around 2.5x slower – both with the default settings of using as many domains/threads as possible. When configured to use a single domain/thread, the Taskflow version takes 1.15s and our Parabs version takes 2.8s. This suggests that the parallel speedup of both benchmark versions is very similar, 5.6x for the Taskflow benchmark and 5.4x for our Parabs version.

(We wondered about why C++ is noticeably faster, this appears to come in part from unspeakable optimizations performed by `g++ -O2` on the fibonacci function. One one test machine, the purely-sequential version of fibonacci (for fib(40)) takes 255ms with `g++ -O2`, 450ms with `clang++ -O2`, and 960ms with `ocamlopt` (only 880s with the OCaml 4.14 pre-multicore runtime, which does not need a resizable-stack check in function prologues).)
