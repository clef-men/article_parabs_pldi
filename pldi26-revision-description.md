Dear reviewers,

We are not yet done with the revised version of your paper, but we have done most of the structural changes that we discussed already, so we are posting an intermediate version to give you an opportunity to provide earlier feedback.

I am attaching our current (intermediate) revision to this message.

Here are the main structural changes:

- We removed the discussion of Vertex / the DAG-calculus entirely, to make space for the other changes.

- We moved the section on prophecies to the end of the paper, starting at the end of page 16. (We are also planning to shrink this section but are not done refining this.)

- We provide API documentation of all the interfaces whose specification we discuss in the paper:
  + the API of work-stealing deques is in a new subsection
    on pages 4 and 5
  + the API of the Pool module is in a new subsection on page 11, with a usage example
  + the API of the Future module is in a new subsection on page 14, with a usage example

  The goal is that an OCaml programmer should get a sense of how to use these modules from this description (and the examples). We hope that this will also help when attacking the specifications -- some of the questions you had, for example on Pool.iter, we try to pre-emptively address in the API documentation.
  
- We changed the Fibonacci benchmarks to provide a C++ version using Taskflow as a control -- see the figure page 26 and discussion page 25. (We had to widen the range of cutoffs to make the discussion interesting, which required adding timeouts because Moonpool became too slow, and in the process we reported and diagnosed an implementation bug in Moonpool.)

Our hope is that the final version will have the same general shape as the current intermediate version. In particular, any feedback you would have on some of the changes listed above is warmly welcome.

We also performed some of the "local", non-structural changes that we discussed (and some others that we wanted), but not all of them yet. We have less than one page left to extra clarifications, but we believe that this would fit.


Cheers
