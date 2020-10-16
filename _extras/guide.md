---
layout: page
title: "Instructor Notes"
permalink: /guide/
---

This lesson is written as an introduction to R,
but its real purpose is to introduce the single most important idea in programming:
how to solve problems by building functions,
each of which can fit in a programmer's working memory.
In order to teach that,
we must teach people a little about
the mechanics of manipulating data with lists and file I/O
so that their functions can do things they actually care about.
Our teaching order tries to show practical uses of every idea as soon as it is introduced;
instructors should resist the temptation to explain
the "other 90%" of the language
as well.

The secondary goal of this lesson is to give them a usable mental model of how programs run
(what computer science educators call a
[notional machine]({{ page.root }}/reference.html#notional-machine)
so that they can debug things when they go wrong. In particular,
they must understand how function call stacks work.

The final example asks them to build a command-line tool
that works with the Unix pipe-and-filter model.
We do this because it is a useful skill
and because it helps learners see that the software they use isn't magical.
Tools like `grep` might be more sophisticated than
the programs our learners can write at this point in their careers,
but it's crucial they realize this is a difference of scale rather than kind.

A typical, half-day, lesson would use the first three lessons:

1. [Analyzing Patient Data]({{ page.root }}/01-starting-with-data/)
2. [Creating Functions]({{ page.root }}/02-func-R/)
3. [Analyzing Multiple Data Sets]({{ page.root }}/03-loops-R/)

An additional half-day could add the next two lessons:

4.  [Making choices]({{ page.root }}/04-cond/)
5.  [Command-Line Programs]({{ page.root }}/05-cmdline/)

Time permitting,
you can fit in one of these shorter lessons that cover bigger picture ideas
like best practices for organizing code, reproducible research,
and creating packages:

6.  [Best practices for using R and designing programs]({{ page.root }}/06-best-practices-R/)
7.  [Dynamic reports with knitr]({{ page.root }}/07-knitr-R/)
8.  [Making packages in R]({{ page.root }}/08-making-packages-R/)

## Using Git in RStudio

Some instructors will demo RStudio's git integration at some point during the
workshop. This often goes over very well, but there can be a few snags with the
setup. First, RStudio may not know where to find git. You can specify where git
is located in _Tools > Global Options > Git/SVN_; on Mac/Linux git is often in
`/usr/bin/git` or `/usr/local/bin/git` and on Windows it is often in
`C:/Program Files (x86)/Git/bin/git.exe`. If you don't know where git is
installed on someone's computer, open a terminal and try `which git` on
Mac/Linux, or `where git` or `whereis git.exe` on Windows. See
[Jenny Bryan's instructions](http://stat545-ubc.github.io/git03_rstudio-meet-git.html)
for more detail.

If Windows users select the option "Run Git from the Windows command prompt"
while setting up Git Bash, RStudio will automatically find the git executable.
If you plan to demo git in RStudio during your workshop, you should edit the
workshop setup instructions to have the Windows users choose this option during
setup.

Another common gotcha is that the push/pull buttons in RStudio are grayed out,
even after you have added a remote and pushed to it from the command line. You
need to add an upstream tracking reference before you can push and pull directly
from RStudio; have your learners do `git push -u origin master` from the command
line and this should resolve the issue.

## Teaching Notes

*   Watching the instructor grow programs step by step
    is as helpful to learners as anything to do with R.
    Resist the urge to clean up your R script as you go
    (which is what you'd probably do in real life).
    Instead, keep intermediate steps in your script.
    Once you've reached the final version
    you can say,
    "Now why don't we just breaks things into small functions right from the start?"

*   The discussion of command-line scripts
    assumes that students understand standard I/O and building filters,
    which are covered in the [Shell lesson](https://swcarpentry.github.io/shell-novice/).

*   We are using a dataset with records on inflammation from patients following an
    arthritis treatment. With it we explain `R` data structure, basic data
    manipulation and plotting, writing functions and loops.

## [Analyzing Patient Data]({{ page.root }}/01-starting-with-data/)

*   Check learners are reading files from the correct location (set working
    directory); remind them of the [Shell lesson](https://swcarpentry.github.io/shell-novice/).

*   Provide shortcut for the assignment operator (`<-`) (RStudio: <kbd>Alt</kbd>+<kbd>-</kbd> on
    Windows/Linux; <kbd>Option</kbd>+<kbd>-</kbd> on Mac).

*   When performing operations on sliced rows of data frames, be aware that some 
    functions in R automatically convert the object type to a numeric vector, while 
    others do not. For example, `max(dat[1, ])` works as expected, while `mean(dat[1, ])` 
    returns an error. You can fix this by including an explicit call to `as.numeric()`, 
    for example `mean(as.numeric(dat[1, ]))`. This issue is also mentioned in a callout 
    box in the lesson materials, since it is unexpected and can create confusion when 
    simple examples fail (by contrast, operations on sliced columns of data frames always 
    work as expected, since columns of data frames are already vectors).

## [Addressing Data]({{ page.root }}/10-supp-addressing-data/)

*   Note that the data frame `dat` is not the same set of data as in other lessons.

## [Analyzing Multiple Data Sets]({{ page.root }}/03-loops-R/)

*   The transition from the previous lesson to this one might be challenging for
    a very novice audience. Do not rush through the challenges, maybe drop some.
