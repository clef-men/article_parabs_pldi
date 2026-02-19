> PLDI 2026 Paper #742 Reviews and Comments
> ===========================================================================
> Paper #742 A verified parallel scheduler for OCaml 5
> 
> 
> Review #742A
> ===========================================================================
> 
> Overall merit
> -------------
> A. Good paper. I will champion it.
> 
> Reviewer expertise
> ------------------
> X. I am an expert in the subject area of this paper.
> 
> Paper summary
> -------------
> The paper presents Parabs, a verified parallel scheduler for OCaml 5. Parabs includes verified versions of the Chase-Lev work-stealing deque as well as the private deques approach of Acar et al., and a simple FIFO scheduler. On top of Domainslib-like task pools, the library includes verified implementations of Futures and Vertices (in the style of the DAG calculus). The verification is done in Zoo, a framework for verifying OCaml code in Iris.
> 
> Strengths
> ---------
> To the authors' knowledge (and mine), this is the first formal verification of a realistic parallel scheduler. While parallel schedulers for languages like OCaml aren't necessarily very large pieces of code, they are extremely tricky to get right and must maintain complex invariants.

TODO: I wonder whether the CertiKOS project contains a realistic concurrent scheduler of comparable algorithmic complexity. This is somewhat suggested by
  https://flint.cs.yale.edu/certikos/mc2.html
but I am not sure where to find more details.

I believe that we should cite this in the Related Work.

More details on page 11 (esp. figure 9) of
  https://flint.cs.yale.edu/certikos/publications/certikos.pdf

The data structures are relatively simple in comparison to ours (no work-stealing), but it is arguably a realistic implementation.

> While the verification is of one scheduler (slightly less flexible than the Domainslib scheduler of OCaml 5, mostly due to limitations in Zoo), at least parts of it seem reusable: if nothing else, the verification of Chase-Lev deques can be reused in verifications of other work stealing schedulers.
> 
> While the overwhelming contribution of the paper is theoretical, the authors also show that Parabs is comparable in performance to Domainslib, which is pretty impressive.
> 
> Weaknesses
> ----------
> I had several issues with the presentation which are not dealbreakers but, if fixed, I feel could make the paper more useful to the community. Mainly, as a developer and user of parallel schedulers but a novice in formal verification and particularly concurrent separation logic, I found the paper a difficult read. Here are a few more specific comments on this:
> 
> * The primer on Iris in Section 2 was actually quite helpful in being able to get a base level of understanding of the specifications in the rest of the paper (though I still had some confusions, detailed in the comments below, which may have resulted from an incomplete understanding of this section). Still, I would very much have appreciated a brief, intuitive explanation of most or all of the specification rules. 
> 
> * With the exception of the more detailed discussion of Chase-Lev deques in Section 4, the paper goes into detail on the specifications of most of the modules and then discusses the high-level points of the implementation (which are good background for non-experts in parallel schedulers but largely unsurprising). There aren't many details on the *verification* of the implementations. I'm not familiar with Zoo, but presumably this is non-trivial.
> 
> * Some of the interfaces differ slightly from the standard/published versions (e.g.,  
> of the DAG calculus). This generally isn't a problem: the equivalence isn't too hard to see. But it means it would be useful to give the OCaml interface in the paper (with brief comments) in addition to the formal specification. In some cases, I went looking for the interfaces in the anonymized repo and was a bit disappointed to find they weren't commented.

Thanks for giving concrete evidence that providing an anonymized repo was useful!

TODO: consider including OCaml APIs somewhere in the paper.

> * The most notable instance of the above is the use of execution contexts in the Pool specification in order to work around the lack of algebraic effects. While I have some intuition for how these are used, I would have liked more detail in the paper, particularly on how this difference in the interface would affect users of the scheduler (e.g., does it only impact designers of new higher-level parallelism libraries like Futures and Vertex or does it bleed into those interfaces as well)?

[Clément]: yes, the context creeps into the interface, this is a rather common programming pattern. (Scala's implicit arguments would help hide this from users in many cases.)

meta: [Gabriel]'s reply below is concerned with continuations, not the context-passing discipline.

We could show three simple examples of (1) how this would be done in a traditional implementation of futures (in a language without effect handlers), (2) how it can be done in OCaml with effect handlers, and (3) how it is done when using our library.

First include this in the response, then consider adding this to 11.2 if we can find extra space.

> Naturally, addressing the above comments will require some more space. I don't expect this paper to be entirely self-contained---that would be impossible even with a number of extra pages! It would be worthwhile for the authors to think about (or maybe they already have, in which case I would be interested to know) the intended audience of the paper: is it the Iris community, developers of parallel schedulers, users of OCaml 5, some combination of the above? This is just one opinion, but personally I would have preferred if some of the sections were omitted (maybe included in an appendix) in favor of more detail on the key modules.

[Gabriel] my impression is that the people who are most likely to benefit from our work and try to reuse it are researchers on verification of concurrent data structures. Developers of parallel schedulers can find more state-of-the-art material elsewhere, and OCaml 5 users should look for tutorials on how to write concurrent programs. Our hope is that the presentation in the article gives a good overview of the overall structure of the implementation and its proof, key invariants and proof techniques (in particular those that could be reused in other projects), and guide people through the mechanized proof if they are interested in going to this level of details.

This does not mean that the paper should be purposefully opaque to non-experts, so of course we can try to also make it clearer for parallelism experts and/or people interested in using library-defined concurrent schedulers. Your suggestions in that direction are appreciated.

(Implementors of parallel schedulers as a secondary audience: "what would it take to verify my own implementations? are there good tools to do this? what design choices make implementation easier?".)

> Nonetheless, I feel that these presentation issues can be fixed within a revision period and thus, on balance, feel the paper should be accepted.
> 
> Detailed comments for authors
> -----------------------------
> 254 persistent aassertion (extra a)
> 
> Fig. 8 What is hist+?
> 
> 526 experiment [with] parallel infrastructures
> 
> Fig. 10: text is very small
> 
> 562 Remarkably -> It is worth remarking that
> 
> Fig. 10: It might be worth dividing the figure into the 4 levels on which the structure of the next few sections is based---I missed this structure on a first read and was a bit confused.
> 
> 614 both realization -> both realizations
> 
> 679 inv t vsz -> inv t sz?
> 
> I needed more detail on spec of Pool
> 
> Fig. 12 What do $$\triangleright$$ and $$\triangleright^n$$ mean?
> 
> Fig. 12 What is £2 in the postcondition of Future-wait-spec? Presumably futures don't produce British currency when they terminate, though this would definitely be additional inducement to use your scheduler!
> 
> Sec. 12 This doesn't need to be its own section (and could probably just be mentioned in the overview)
> 
> 830-832 Why use different notations for persistent/non-persistent outputs for Future and Vertex?

[Gabriel] I would understand this as "different arguments" here, I think that "notations" is a distraction.

> Fig. 13 Maybe I'm missing something about how to read these rules, but I would have expected something else in the postcondition of Vertex-release-spec

[Gabriel] The specification of Vertex-Release-Spec does not tell you that the node you release will eventually run, for good reasons: we cannot know at this point whether it will ever run, as it depends on its own dependencies.

One may then wonder how to acquire a `finished` proposition for a given node. It is a bit tricky to see, but if you want to know when a given node N is finished, you can attach a successor S to that node, set to S the `task` that you want to perform when N is finished, and release S. In the `wp` conditions for that "release" call, you know that when `task` runs S will be ready, and you know that (predecessor N S) holds, so you can use the rule Vertex-Predecessor-Finished to learn that N is finished.

> 962 With algebraic -> With algebraic effects
> 
> Questions for author response
> -----------------------------
> 1. Who do you feel is the intended audience of this paper (presumably a proper subset of the PLDI audience)?

[Gabriel] I would say: people interested in formal verification of real-world concurrent programs.

> 2. Can you go into more detail on the execution contexts, particularly their impacts on users of the library (see above)?

TODO

> 3. How easily do you feel the proof is reusable for other parallel schedulers and/or extensions of Parabs?

We strived to have a clean architecture in the code and in the mechanization as well, with separate building blocks with a clear specification -- changing one of the blocks does not require touching the others as long as specifications are preserved. We already show that experimenting with different scheduling policies is possible, and we believe that for other changes as well it would be reasonably easy to reuse, adapt or extend our work. (Relatively to the fact that, in mechanized verification, everything is hard.)

The easiest form of reuse would be to build verified algorithms on top of Parabs and its high-level specification. In particular, the DAG-calculus was proposed as a lingua franca for some task abstractions, we believe that verifying concurrency models that can be expressed on top of our Vertex module should be relatively easy.

> 4. How challenging were the verifications of the implementations, once the specifications were worked out? Are there any interesting points/key invariants?

Very challenging! Finding the right invariant is usually the key difficult, and we proceed iteratively (pick a reasonable invariant, try to do a pen-and-paper proof, see where that breaks, refine the invariant and loop until fixpoint). For reasons of space we chose to expose specifications in the paper, and mostly keep the invariants in the mechanized artifact only, with the exception of the Chase-Lev invariant which we believe is a significant, reusable contribution.

The "wise prophets" and "multiplexed prophets" that we present in Section 3 may look like technical details to Iris non-users, but they capture non-trivial proof patterns that we had to invent to verify complex linearization patterns, going beyond what had already been done in the Iris literature. We believe that they could be useful to other people doing mechanized verification (using prophecy variables, which now exist in other logics than Iris) of concurrent programs.

> 5. Would it be possible to extend the proof to give a quantitative verification of the scheduler's performance (like Arora, Blumofe and Plaxton [SPAA '98]'s bound for a work-stealing scheduler)?

Our best guess would be that this is possible but likely to be quite difficult, due to difficulties about reasoning about fairness in state-of-the-art concurrent program logics.

We already know that Iris is a reasonable setting to reason about algorithmic complexity in time or space ( see for example https://iris-project.org/pdfs/2019-esop-time.pdf ), and there have been mechanized proofs of complexity-efficient scheduling policies ( for example https://www.chargueraud.org/research/2018/heartbeat/heartbeat.pdf )

However, lock-free data structures such as the one we use in our implementation are known to create difficulties to reason about termination (and more precise quantiative properties), because their termination relies on a fairness assumption. (The original proof of Arora, Blumofe and Plaxton also needs fairness-like assumptions.) This is discussed in depth in https://www.cs.cmu.edu/~janh/papers/lockfree2013.pdf , and/but currently standard Iris does not provide pleasant tools to reason about fairness and thus state quantitative properties of lock-free implementations. (Our implementation of work-stealing also uses random-number generation to select dequeues to steal from, which would also require fairness assumptions / working with probabilities.)

> Review #742B
> ===========================================================================
> 
> Overall merit
> -------------
> A. Good paper. I will champion it.
> 
> Reviewer expertise
> ------------------
> X. I am an expert in the subject area of this paper.
> 
> Paper summary
> -------------
> This paper presents a scheduler (or really more of a small scheduling framework)
> for OCaml 5 that has been verified for functional correctness. The scheduler is
> based on the Chase-Lev work-stealing deque and achieves performance on par with
> existing, production-grade OCaml schedulers. Verification is done using the Zoo
> framework based on Iris. The paper gives an overview over the architecture of
> the scheduler and the key specifications.
> 
> Strengths
> ---------
> Foundational verification of software in a real programming language with
> production-grade performance is an impressive feat.
> 
> Weaknesses
> ----------
> The second half of the paper is hard to follow even for someone with solid Iris
> experience: the authors seem to assume that the reader already knows how the
> APIs described there are meant to be used, but that is far from clear. Without
> this knowledge, it is difficult to make sense of the specifications.

TODO: document the API, even minimally.

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

We agree that it would be nice to provide more examples, in particular an example of using the Vertex interface.

> There is no report on the amount of effort that this verification took. Lines of
> code are not a great metric, but they are better than nothing, and in particular
> the ratio of lines of code vs lines of proof can be quite informative.

A simplistic count (ls -1 *.v | grep -v '__' | xargs wc -l) puts `theories/zoo_parabs` at 8900 lines of proofs, with the corresponding implementations (ls *.ml | xargs wc -l) at 741 lines, suggesting a 12x code-to-proofs ratio. The work-stealing-related data structures in `zoo_saturn` exhibit a higher ratio, with 340 lines of code and 7495 lines of proofs, so 22x more proofs.

We are unsure what conclusions to draw from the code-to-proofs ratio. Having massively more proofs than code can be the sign of a lack of attention to proof engineering, for example missed opportunities in proof automation. It can also be the sign of a fundamentally hard problem domain. Of course we believe the second explanation more: lock-free data structures are exceptionally good at packing quite the verification difficulties in a relatively small number of lines of code. It explains why the core data-structure code in `zoo_saturn` has a worse ratio than the scheduler code in `zoo_parabs`.

> Detailed comments for authors
> -----------------------------
> I think the paper should be accepted for the sheer feat of verifying a real
> piece of concurrent software with competitive performance. However, the paper
> could do a better job at presenting this result. A lot of space is used
> discussing and showing the proof rules for prophecy variables (that's almost 2
> pages of proof rules!). The new forms of prophecy variables ("wise" and
> "multiplexed") seem more like a nice convenience than a fundamental shift, so
> the amount of space they take up in the paper is in no proportion to the size of
> this contribution. Instead, that space could be used to better explain the
> specifications in §10-13. I will get back to this in my line-by-line comments.
> 
> Line-by-line comments:
> - Line 62: Multiple times throughout the paper, the authors mention that the
> stronger spec is needed to "prove termination". However, given that this paper
> uses Iris and that there is no discussion of termination results, I assume no
> proof of termination happened. This is quite misleading and should be clarified.

We agree that our wording was misleading and we will rephrase this.

The proofs were done in a partial-correctness logic, so indeed we do not prove termination of the scheduler and we should reformulate. What we were trying to say (in a few words) is the following: the API exposes a way to kill all tasks owned by a scheduler, and to know that they have been terminated. In this case we want to recover all the resources that were previously owned by those tasks. Reasoning about this requires the stronger specification for Chase-Lev. So here "termination" should not be understood as "we prove formally that running the tasks eventually terminate", but "we let you reason correctly about what you know after termination".

> - Line 112: This is a very unconventional way to write Hoare triples, and it is
> very confusing since it looks a lot like an inference rule, and many figures mix
> inference rules and Hoare triples. I would encourage the others to make their
> paper more accessible by using more conventional notation, or at least notation
> that is less prone to confusion with other constructs in the same paper.
> - Line 149: Having a dozen different propositions called "model" quickly gets
> confusing.
> - Line 212: What is the meaning of the different colors? I first thought maybe
> they encode whether the proposition is persistent or not, but that does not seem
> to be the case. Without an explicit pattern, the colors are more distracting
> than helpful.
> - Line 263: Multiplexed prophets seem to just slice a regular prophecy variable
> into multiple views. Why is that so useful that it justifies the amount of space
> that it takes in the paper? I first thought it would be useful to split
> ownership, but it seems there is still just a single global `model` assertion.
> - Line 423: I assume those liveness properties have not been verified? This
> should be clarified.

Our formulation is confusing and we will clarify. What we had in mind when writing this is a different notion of 'liveness' from GC-ed languages: it is bad to retain user-provided values in "unused" slots of a data structure, as it could keep memory alive longer than necessary. The usual trick, which is used by the OCaml data structures of the Saturn library, is to write a `null` (poetically called `Obj.magic ()`) in their place to recover good "liveness" (in that sense) properties.

Note: The implementation we provided in our artifact does not in fact implement this extra erasing write in `ws_deque_2.ml` -- we did verify this in an earlier version, and when we rewrote to use the current Zoo approach this subtlety of the implementation was lost. This is a small mistake on our part that is easy to fix, and which we will address shortly.

From the perspective of the paper this is a technical detail, but it leaks through the choice of public postconditions of the `Ws_deque` specification, which we thought was worth justifying.

> - Line 485: It is not clear to me what is meant by "stable" and "unstable"
> states. I first thought the authors referred to stable/unstable propositions in
> separation logic, but this seems to be something else.

The 'unstable' states correspond to states of the data-structure that can only be observed transiently while concurrent operations on the structure are ongoing. When a program has reached a quiescent state where no operations are ongoing, only stable states may be observed.

> - Line 462: Which three upper levels? I am looking at the figure, and it's not
> clear which 3 nodes the text is referring to here. Only later did I realize that
> it probably refers back to line 530, but with that being on the previous page
> and the picture just above the text, that is not clear. Furthermore, which
> "branch" of which "tree" is meant here? The picture is a non-trivial DAG.
> - Line 597: I did not understand this chapter on "waiters". It should be either
> omitted, or expanded to actually explain whatever it tries to convey in a bit
> more detail.
> - Line 612: "The standard randomized strategy" sounds like the reader is
> expected to know what that standard strategy is, but at least to me it is not
> clear which strategy is meant. The text sounds like there are multiple
> randomized strategies and one of them is picked.
> - Line 616: With this fifo strategy, it looks like the Ws_dequeues layer is
> entirely unused? That seems odd. Though now looking at the figure this is indeed
> made clear there; in the text, this is not clear.
> - Line 642: Why is the postcondition P of the task in `async` (and in
> `obligation`) apparently always persistent? Why can a task not return exclusive
> ownership?

We designed the Pool interface with the intent to build Future on top of it. With Future you can indeed have non-persistent outputs, so programming examples which require non-persistent outputs are convenient to implement and verify. Doing so directly at the level of Pool is less pleasant (it requires an extra encoding), we could indeed extend the specification a bit to add non-persistent outputs for `async` and make it more direct -- we would be happy to make this change.

An example of program that benefits from non-persistent outputs (and is thus easy to implement on top of our Future, and less easy to implement on top of Pool directly) is 'quicksort', as implemented for example in the PulseCore paper ( https://dl.acm.org/doi/pdf/10.1145/3729311 ) page 21: to know that the `async` task is finished sorting one half of the array, they call `teardown_pool`, and at this point they want to obtain a non-persistent property.

> - Line 664: How does wait_until behave and how is it used? It seems to support
> waiting until an arbitrary opaque predicate becomes true -- so does it just
> busy-wait, or is it somehow integrated with the scheduler?

This is integrated in the scheduler -- one can think of a user-level
equivalent of pthreads condition variables. The scheduler calls the
predicate periodically when it considers re-running this task.

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

We improved on this slightly in the current version of our
development, without the `2.depth+1` nesting.

> - Line 780: Why are persistent and non-persistent output predicates separated?

The idea was to make the interface more convenient to use. This follows the design
patterns of `ivar` in the Zoo standard library.

> - Line 782: Why is there this level of indirection between `inv` and `result`
> and `consumer`? Apparently the goal is to be able to split up the postcondition
> so different parties can own parts of the postcondition of the same async task;
> this could be explained more explicitly -- but more importantly, it is not
> motivated. And then there's also `obligation` which I did not understand at all,
> since it isn't even clear what `iter` actually *does* operationally.

TODO explain obligation.

> - Line 802: I got quite lost here. When would they be nested?

TODO show a simple example that uses 'wait' to explain the nesting problem.

> - Line 812: This section on the "vertex" layer is not understandable just from
> this paper alone. It would be good to at least give a *basic* understanding of
> how programming with this API looks like.

TODO should we consider moving Vertex to an appendix, or dropping it from the paper?

> - Line 855: What is going on with this `option.get` here?
> 
> Typos:
> - Line 46: "end-used" → "end-user"
> - Line 472: "reserved to" → "reserved for"
> - Line 461: "Remarkably" does not seem to be the right word here; this should
> probably be "It is worth noting that" or something like that.
> - Line 679: `inv t vsz` should be `inv t sz`
> - Line 801: "participate" → "participates"
> - Line 962: "With algebraic" there is probably an "effects" missing here?
> 
> Questions for author response
> -----------------------------
> Are there any verified clients of the given APIs, showing that they are truly
> "two-sided"? I supposed for all the intermediate layers, the next layer up can
> be considered a client, but that still leaves at least the top layer without any
> users.

see above

> How many lines of code have been verified for this paper, and how many lines did
> those proofs take?

see above

> 
> Is there a proof of termination of the scheduler? If not, would the weaker spec
> of the deque have been sufficient for all results of this paper?

TODO let Clément explain this :-)

> Review #742C
> ===========================================================================
> 
> Overall merit
> -------------
> C. Weak paper, though I will not fight strongly against it.
> 
> Reviewer expertise
> ------------------
> Y. I am knowledgeable in the area, though not an expert.
> 
> Paper summary
> -------------
> This paper describes recent work on the OCaml5 parallel scheduler.
> 
> Strengths
> ---------
> Useful accounts for OCaml audience

We believe that verified concurrent schedulers are scarce for any programming language, so our results are interesting beyond an OCaml audience. For example Go or GHC runtime authors considering formal verifications, of people considering correctness-critical usage of TaskFlow or Cilk, etc.

> Weaknesses
> ----------
> Incremental progress on parallel scheduling issues

We would like to emphasize that the claimed contribution of this work is the mechanized _verification_ of a realistic implementation. The implementation itself is not novel (it closely follows an existing OCaml library, Domainslib), and should look relatively standard and unsophisticated to parallel-scheduling experts. On the other hand, the formal verification of such an implementation is a significant achievement.

Note: the original inspiration for our implementation, Domainslib, is not our own work, it has been benchmarked for scalability in the past (in particular the benchmarks in https://dl.acm.org/doi/10.1145/3408995 used an earlier version of Domainslib) and received attention and profiling/optimization work from parallelism experts.

> Detailed comments for authors
> -----------------------------
> The write up style with embedded refs to code is very nice.
> 
> The accounts in this paper will be useful to OCaml users, but I'm not sure that there is enough incremental progress on parallel scheduling to report yet.
> 
> Verification (sec 2-4): The paper should make clear up front exactly what properties are being verified (especially given discussions in sec5+). A simple table or list in sec 1 or 2 would help identify those properties required for any of the many possible variations in implementation. The motivation for introducing Iris extensions seems to be coverage of an omitted property of push in previous work. It's not clear whether this was an oversight that could have been addressed using the methods in those accounts, or whether the introduced Prophet-based techniques are essential. Please explain. I don't have enough expertise with Iris to determine this, or to evaluate its use here.

We verify functional correctness (in a partial-correctness logic).

> The Parabs API and design walk-through in sec (sec 5-13) seems OK, but could use some retrospective rationalization: Explain the design space up front, and then why/how particular choices (for example private queues) are made in different components. As it stands, Parabs seems to provide a reasonable set of abstractions, but doesn't (yet?) include many new ideas compared to other frameworks in other languages.
> 
> Sec 8: Dealing with excess contention and wastage during ramp-down and phase changes is subject to constant attention in production frameworks. See for example the (too recent to have been cited) PPoPP 2026 "Waste-Efficient Work Stealing". The sleep-based approach here is fine for some workloads, but not others.
> 
> Sec 9: If the FIFO realization used a dequeue in which owners must "steal" their own tasks, then it would fall under the same characterization as others, with breadth-first execution. Is there a reason not to do this?
> 
> Sec 10: The Pool design and implementation seems to need a lot of work. It does not properly handle exceptions, abruptly shutdown, and has no mechanism to support transient blocking. It might be productive to come up with an extended set of properties in Fig 11 to more carefully specify and verify such issues.
> 
> Sec 11-12: I am confused that sec 10 mentions that the Pool does not support continuations, but the implementation of Futures relies on them? It's also not clear whether these share mechanics with the completion-based VERTEX support.
> 
> Sec 13 / Appendix. I was surprised not to see a sanity-check comparison with Cilk on the two benchmarks (lu and matmul) that I'm guessing are based on initial Cilk code.

There is probably an ancestral link from the Cilk benchmarks, but our own source of inspiration for our benchmarks was benchmarks from Domainslib and Taskflow, not Cilk directly

  https://github.com/ocaml-multicore/domainslib/blob/main/test/LU_decomposition_multicore.ml
  https://github.com/taskflow/taskflow/blob/master/benchmarks/matrix_multiplication/omp.cpp

Note in particular that the `lu` and `matmul` implementation in the benchmarks are extremely simple parallel implementations: we wrote the cubic algorithm and then made one of the for-loop parallel. (). We looked at the Cilk implementations of `lu` on your suggestion, its block-based implementation is substantially more sophisticated.

We would also predict that benchmark results between Cilk and OCaml would be wildly different, to the point of being very difficult to compare:

- C compilers optimize this kind of numeric code agressively
  (unrolling etc.), while the OCaml compiler does not, so the baseline
  sequential performance is going to be fairly different.

- Cilk offers a compiler-supported implementation, while we verify
  a "user-level" scheduler entirely implemented in OCaml, with no
  compiler support. (For example each creation of a subtask allocates
  a closure.) We would naively expect a Cilk benchmark to perform much
  better on small cutoffs, in a different league from user-level
  schedulers.

- In general, the OCaml runtime itself contains some scalability
  bottleneck (especially the stop-the-world minor collector) which
  would make scalability comparisons with no-runtime languages
  difficult -- but in the case of these examples there should not be
  much allocator pressure so this point should not apply.

We did write a baseline sequential version in C++ and OCaml to compare
to our guesswork estimate that a C/C++ baseline may be up to 5x
faster. We found that the C++ version is 1.45x faster with `g++ -O1`,
and 3.4x faster with `-O3` (similar results with g++ or clang++) -- so
our 5x guess was a bit pessimistic.

We were inspired by the reviewer's suggestion to perform "sanity
checks" using benchmarks implemented by someone else than us, and we did
the following:

1. We built the benchmark `fibonacci.cpp` from the TaskFlow examples
   directory (we did not build the `matrix_multiplication` benchmark
   because its build system insists on having TBB available).
   https://github.com/taskflow/taskflow/blob/master/examples/fibonacci.cpp

   This version has _no_ cutoff, so its performance is dominated by
   the scheduler overhead with very small tasks. On our machine, this
   benchmark exactly unchanged takes 5s to compute fib(42), when the
   implementation we provided takes 8s using Parabs. We modified the
   taskflow example to use a cutoff value provided as an extra
   parameter, with cutoff=10 the Taskflow implementation takes 206ms
   (±8ms) and our Parabs version takes 520ms (±15ms), so it is around
   2.5x slower – both with the default settings of using as many
   domains/threads as possible. When configured to use a single
   domain/thread, the Taskflow version takes 1.15s and our Parabs
   version takes 2.8s. This suggests that the parallel speedup of both
   benchmark versions is very similar, 5.6x for the Taskflow benchmark
   and 5.4x for our Parabs version.

2. TODO Domainslib lu version?
