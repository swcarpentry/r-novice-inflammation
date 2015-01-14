r-novice-inflammation
=====================

Introduction to R for non-programmers using inflammation data.

The goal of this lesson is to teach novice programmers to write modular code to
perform a data analysis. R is used to teach these skills because it is a
commonly used programming language in many scientific disciplines. However, the
emphasis is not on teaching every aspect of R, but instead the focus is on
language agnostic principles like automation with loops and encapsulation with
functions (see [Best Practices for Scientific Computing][best-practices] to
learn more). In fact, this lesson is a translation of the [Python version][py],
and the lesson is also available in [MATLAB][].

The example used in this lesson is analyzing a set of 12 data files with
inflammation data collected from a trial for a new treatment for arthritis (the
data was simulated). Learners are shown how it is better to create a function
and apply it to each of the 12 files using a loop instead of using copy-paste
to analyze the 12 files individually.

[best-practices]: http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745
[py]: https://github.com/swcarpentry/python-novice-inflammation
[MATLAB]: https://github.com/swcarpentry/matlab-novice-inflammation

## Contributing

Please see the current list of [issues][] for ideas for contributing to this
repository. For making your contribution, we use the GitHub flow, which is
nicely explained in the chapter [Contributing to a Project][pro-git] in Pro Git
by Scott Chacon.

[issues]: https://github.com/swcarpentry/r-novice-inflammation/issues
[pro-git]: http://git-scm.com/book/en/v2/GitHub-Contributing-to-a-Project

## Getting Help

> Please see [https://github.com/swcarpentry/lesson-template](https://github.com/swcarpentry/lesson-template)
> for instructions on formatting, building, and submitting lessons,
> or run `make` in this directory for a list of helpful commands.

If you have questions or proposals, please send them to the [r-discuss][] mailing list.

[r-discuss]: http://lists.software-carpentry.org/mailman/listinfo/r-discuss_lists.software-carpentry.org
