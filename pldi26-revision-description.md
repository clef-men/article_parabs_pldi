Dear reviewers,

Here is the final version of our paper at the end of the conditional-acceptance revision period.
A standalone PDF and a latexdiff-produced version are attached.

I already mentioned the main structural changes:

- We removed the discussion of Vertex / the DAG-calculus entirely, to make space for the other changes.

- We moved the section on prophecies to the end of the paper, starting at the end of page 16.

- We provide API documentation of all the interfaces whose specification we discuss in the paper:
  + the API of work-stealing deques is in a new subsection
    on pages 4 and 5
  + the API of the Pool module is in a new subsection on page 11, with a usage example
  + the API of the Future module is in a new subsection on page 14, with a usage example

  The goal is that an OCaml programmer should get a sense of how to use these modules from this description (and the examples). We hope that this will also help when attacking the specifications -- some of the questions you had, for example on Pool.iter, we try to pre-emptively address in the API documentation.
  
- We changed the Fibonacci benchmarks to provide a C++ version using Taskflow as a control -- see the figure page 26 and discussion page 25. (We had to widen the range of cutoffs to make the discussion interesting, which required adding timeouts because Moonpool became too slow, and in the process we reported and diagnosed an implementation bug in Moonpool.)

We also performed some of the "local", non-structural changes that we discussed (and some others that we wanted), prompted in large part by your reviews, for instance:

- We briefly mention simple verified examples as "clients" of the specification, notably fibonacci for Future (which we already had at submission time) and quicksort for Pool (which we added in reaction to the author-response discussion). (Note: there is a small gap between the examples we wrote for benchmarking and the examples we verified, for example the verified-fibonacci does not have a sequential cutoff. Adding the cutoff would not make the proof materially harder, but we were short on time to do this.)
- We clarified "completion" (rather than termination).
- We retracted the remark on "liveness" which was confusing and a small mismatch wrt. the current implementation.
- We explained the implementation of "wait", how it uses the call stack, and how algebraic effects would let us do slightly better.
- We added a non-persistent 'result' predicate to the Pool specification, to mirror the Future specification.
  As we discussed in our response this can be encoded on top of the previous specification, but this makes
  it slightly nicer for direct usage, and we used this in our verified quicksort.

Just to make things extra-clear, let me review the requested changes that you had formulated:

> Add discussion on the use of the APIs, as well as at least some discussion on your example clients.

This is done.

> Complete the discussed clarifications and typo fixes, especially with respect to "prov[ing] termination" as discussed in Review B.

This is done.

> If needed for space, we support your decision to shorten or move the Vertex section. As you say, this is a shame, but presumably the contribution will still be mentioned in the paper and discussed in full in an ArXiV version or similar.

This is done -- we removed the version completely. We did make good use of the extra space.

> Consider if more technical details of prophecies could be partially removed or moved to a later section. If one of your key target audiences is Iris users looking to reuse your formalism, by all means, keep the details that are important for this purpose. But some of the reviewers felt this could be accomplished with a slightly less detailed discussion.

This is done, in particular the discussion of prophecies is at the very end. We also hope that the API documentation and the addition of examples will make the rest of the paper easier to digest.

(Note: we took note of your remark that the .mli interfaces themselves lacked documentation, and we started the revision process by adding them for Ws_deque, Pool and Future. We have not advertised the library to OCaml audiences yet, in part due to anonymity requirements, but we will be documenting it further and better before we do this, and are considering some mild API tweaks intended for programming users.)

We welcome any further feedback that you would have on the revised versions.

Cheers
