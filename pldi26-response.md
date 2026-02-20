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

TODO

### Review B

TODO

### Review C

TODO
