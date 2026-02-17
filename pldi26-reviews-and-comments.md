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
> 
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

We could show three simple examples of (1) how this would be done in a traditional implementation of futures (in a language without effect handlers), (2) how it can be done in OCaml with effect handlers, and (3) how it is done when using our library.

First include this in the response, then consider adding this to 11.2 if we can find extra space.

> Naturally, addressing the above comments will require some more space. I don't expect this paper to be entirely self-contained---that would be impossible even with a number of extra pages! It would be worthwhile for the authors to think about (or maybe they already have, in which case I would be interested to know) the intended audience of the paper: is it the Iris community, developers of parallel schedulers, users of OCaml 5, some combination of the above? This is just one opinion, but personally I would have preferred if some of the sections were omitted (maybe included in an appendix) in favor of more detail on the key modules.

[Gabriel] my impression is that the people who are most likely to benefit from our work and try to reuse it are researchers on verification of concurrent data structures. Developers of parallel schedulers can find more state-of-the-art material elsewhere, and OCaml 5 users should look for tutorials on how to write concurrent programs. My hope is that the PDF presentation gives a good overview of the overall structure of the implementation and its proof, key invariants and proof techniques (in particular those that could be reused in other projects), and guide people through the mechanized proof if they are interested in going to this level of details.

This does not mean that the paper should be purposefully opaque to non-experts, so of course we can try to also make it clearer for parallelism experts and/or people interested in using library-defined concurrent schedulers. Your suggestions in that direction are appreciated.

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
> 
> Fig. 13 Maybe I'm missing something about how to read these rules, but I would have expected something else in the postcondition of Vertex-release-spec
> 
> 962 With algebraic -> With algebraic effects
> 
> Questions for author response
> -----------------------------
> 1. Who do you feel is the intended audience of this paper (presumably a proper subset of the PLDI audience)?
> 
> 2. Can you go into more detail on the execution contexts, particularly their impacts on users of the library (see above)?
> 
> 3. How easily do you feel the proof is reusable for other parallel schedulers and/or extensions of Parabs?
> 
> 4. How challenging were the verifications of the implementations, once the specifications were worked out? Are there any interesting points/key invariants?
> 
> 5. Would it be possible to extend the proof to give a quantitative verification of the scheduler's performance (like Arora, Blumofe and Plaxton [SPAA '98]'s bound for a work-stealing scheduler)?
> 
> 
> 
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
> 
> There is no mention of verified clients using these APIs. Space limits preclude
> actually discussing such a client in great detail, but given how easy it is to
> come up with a useless specification, it would still be desirable to verify some
> examples and then just briefly mention them in the text.
> 
> There is no report on the amount of effort that this verification took. Lines of
> code are not a great metric, but they are better than nothing, and in particular
> the ratio of lines of code vs lines of proof can be quite informative.
> 
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
> - Line 485: It is not clear to me what is meant by "stable" and "unstable"
> states. I first thought the authors referred to stable/unstable propositions in
> separation logic, but this seems to be something else.
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
> - Line 664: How does wait_until behave and how is it used? It seems to support
> waiting until an arbitrary opaque predicate becomes true -- so does it just
> busy-wait, or is it somehow integrated with the scheduler?
> - Line 728: Here I got quite lost. Apparently futures can have "callbacks"
> attached to them via `iter`? What are those for and when do they get triggered?
> The systems for futures I have encountered in other languages have no such
> mechanism. I tried to reverse engineer this from the specification but was not
> successful.
> - Line 747: What is going on with the later modalities here?
> - Line 780: Why are persistent and non-persistent output predicates separated?
> - Line 782: Why is there this level of indirection between `inv` and `result`
> and `consumer`? Apparently the goal is to be able to split up the postcondition
> so different parties can own parts of the postcondition of the same async task;
> this could be explained more explicitly -- but more importantly, it is not
> motivated. And then there's also `obligation` which I did not understand at all,
> since it isn't even clear what `iter` actually *does* operationally.
> - Line 802: I got quite lost here. When would they be nested?
> - Line 812: This section on the "vertex" layer is not understandable just from
> this paper alone. It would be good to at least give a *basic* understanding of
> how programming with this API looks like.
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
> 
> How many lines of code have been verified for this paper, and how many lines did
> those proofs take?
> 
> Is there a proof of termination of the scheduler? If not, would the weaker spec
> of the deque have been sufficient for all results of this paper?
> 
> 
> 
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
> 
> Weaknesses
> ----------
> Incremental progress on parallel scheduling issues
> 
> Detailed comments for authors
> -----------------------------
> The write up style with embedded refs to code is very nice.
> 
> The accounts in this paper will be useful to OCaml users, but I'm not sure that there is enough incremental progress on parallel scheduling to report yet.
> 
> Verification (sec 2-4): The paper should make clear up front exactly what properties are being verified (especially given discussions in sec5+). A simple table or list in sec 1 or 2 would help identify those properties required for any of the many possible variations in implementation. The motivation for introducing Iris extensions seems to be coverage of an omitted property of push in previous work. It's not clear whether this was an oversight that could have been addressed using the methods in those accounts, or whether the introduced Prophet-based techniques are essential. Please explain. I don't have enough expertise with Iris to determine this, or to evaluate its use here.
> 
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
