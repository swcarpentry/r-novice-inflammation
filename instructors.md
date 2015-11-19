---
layout: page
title: Programming with R
subtitle: Instructor's Guide
minutes: 0
---



## Legend

We are using a dataset with records on inflammation from patients following an
arthritis treatment. With it we explain `R` data structure, basic data
manipulation and plotting, writing functions and loops.

## Overall

This lesson is written as an introduction to R, but its real purpose is to
introduce the single most important idea in programming: how to solve problems
by building functions, each of which can fit in a programmer's working memory.
In order to teach that, we must teach people a little about the mechanics of
manipulating data with lists and file I/O so that their functions can do things
they actually care about.
Our teaching order tries to show practical uses of every idea as soon as it is
introduced; instructors should resist the temptation to explain the "other 90%"
of the language as well.

The secondary goal of this lesson is to give them a usable mental model of how
programs run (what computer science educators call a
[notional machine](reference.html#notional-machine) so that they can debug
things when they go wrong.
In particular, they must understand how function call stacks work.

The final example asks them to build a command-line tool that works with the
Unix pipe-and-filter model.
We do this because it is a useful skill and because it helps learners see that
the software they use isn't magical.
Tools like `grep` might be more sophisticated than the programs our learners can
write at this point in their careers, but it's crucial they realize this is a
difference of scale rather than kind.

The `R` novice inflammation contains a lot of material to cover.
Remember this lesson does not spend a lot of time on data types, data
structure, etc.
It is also on par with the similar lesson on Python.
The objective is to explain modular programming with the concepts of functions,
loops, flow control, and defensive programming (i.e. SWC best practices).
Supplementary material is available for R specifics
([Addressing Data](01-supp-addressing-data.html),
[Data Types and Structure](01-supp-data-structures.html),
[Understanding Factors](01-supp-factors.html),
[Introduction to RStudio](01-supp-intro-rstudio.html),
[Reading and Writing .csv](01-supp-read-write-csv.html),
[Loops in R](03-supp-loops-in-depth.html),
[Best Practices for Using R and Designing Programs](06-best-practices-R.html),
[Dynamic Reports with knitr](07-knitr-R.html),
[Making Packages in R](08-making-packages-R.html)).

A typical, half-day, lesson would use the first three lessons:

1. [Analyzing Patient Data](01-starting-with-data.html)
2. [Creating Functions](02-func-R.html)
3. [Analyzing Multiple Data Sets](03-loops-R.html)

An additional half-day could add the next two lessons:

4.  [Making choices](04-cond.html)
5.  [Command-Line Programs](05-cmdline.html)

Time-permitting, you can fit in one of these shorter lessons that cover bigger picture ideas like best practices for organizing code, reproducible research, and creating packages:

6.  [Best practices for using R and designing programs](06-best-practices-R.html)
7.  [Dynamic reports with knitr](07-knitr-R.html)
8.  [Making packages in R](08-making-packages-R.html)

## [Analyzing Patient Data](01-starting-with-data.html)

* Check learners are reading files from the correct location (set working
  directory); remind them of the shell lesson

* Provide shortcut for the assignment operator (`<-`) (RStudio: Alt+- on
  Windows/Linux; Option+- on Mac)


~~~{.r}
dat <- read.csv("data/inflammation-01.csv", header = FALSE)
animal <- c("m", "o", "n", "k", "e", "y")
# Challenge - Slicing (subsetting data)
animal[4:1]  # first 4 characters in reverse order
~~~



~~~{.output}
[1] "k" "n" "o" "m"

~~~



~~~{.r}
animal[-1]  # remove first character
~~~



~~~{.output}
[1] "o" "n" "k" "e" "y"

~~~



~~~{.r}
animal[-4]  # remove fourth character
~~~



~~~{.output}
[1] "m" "o" "n" "e" "y"

~~~



~~~{.r}
animal[-1:-4]  # remove first to fourth characters
~~~



~~~{.output}
[1] "e" "y"

~~~



~~~{.r}
animal[c(5, 2, 3)]  # new character vector
~~~



~~~{.output}
[1] "e" "o" "n"

~~~



~~~{.r}
# Challenge - Subsetting data
max(dat[5, 3:7])
~~~



~~~{.output}
[1] 3

~~~


~~~{.r}
sd_day_inflammation <- apply(dat, 2, sd)
plot(sd_day_inflammation)
~~~

## [Addressing Data](01-supp-addressing-data.html)

* Note that the data frame `dat` is not the same set of data as in other lessons

## [Data Types and Structure](01-supp-data-structures.html)

* Lesson on data types and structures

## [Understanding Factors](01-supp-factors.html)

## [Introduction to RStudio](01-supp-intro-rstudio.html)

## [Reading and Writing .csv](01-supp-read-write-csv.html)



## [Creating Functions](02-func-R.html)


~~~{.r}
# Challenge - Create a function
fence <- function(original, wrapper) {
  answer <- c(wrapper, original, wrapper)
  return(answer)
}
~~~


~~~{.r}
# Challenge - A more advanced function
analyze <- function(filename) {
  # Plots the average, min, and max inflammation over time.
  # Input is character string of a csv file.
  dat <- read.csv(file = filename, header = FALSE)
  avg_day_inflammation <- apply(dat, 2, mean)
  plot(avg_day_inflammation)
  max_day_inflammation <- apply(dat, 2, max)
  plot(max_day_inflammation)
  min_day_inflammation <- apply(dat, 2, min)
  plot(min_day_inflammation)
}

# Challenge - rescale
rescale <- function(v) {
  # Rescales a vector, v, to lie in the range 0 to 1.
  L <- min(v)
  H <- max(v)
  result <- (v - L) / (H - L)
  return(result)
}
~~~


~~~{.r}
# Challenge - A function with default argument values
rescale <- function(v, lower = 0, upper = 1) {
  # Rescales a vector, v, to lie in the range lower to upper.
  L <- min(v)
  H <- max(v)
  result <- (v - L) / (H - L) * (upper - lower) + lower
  return(result)
}
answer <- rescale(dat[, 4], lower = 2, upper = 5)
min(answer)
~~~



~~~{.output}
[1] 2

~~~



~~~{.r}
max(answer)
~~~



~~~{.output}
[1] 5

~~~



~~~{.r}
answer <- rescale(dat[, 4], lower = -5, upper = -2)
min(answer)
~~~



~~~{.output}
[1] -5

~~~



~~~{.r}
max(answer)
~~~



~~~{.output}
[1] -2

~~~

## [Analyzing Multiple Data Sets](03-loops-R.html)

* The transition from the previous lesson to this one might be challenging for
  a very novice audience. Do not rush through the challenges, maybe drop some.


~~~{.r}
# Challenge - Using loops
print_N <- function(N) {
  nseq <- seq(N)
  for (num in nseq) {
    print(num)
  }
}
print_N(3)
~~~



~~~{.output}
[1] 1
[1] 2
[1] 3

~~~



~~~{.r}
total <- function(vec) {
  #calculates the sum of the values in a vector
  vec_sum <- 0
  for (num in vec) {
    vec_sum <- vec_sum + num
  }
  return(vec_sum)
}
ex_vec <- c(4, 8, 15, 16, 23, 42)
total(ex_vec)
~~~



~~~{.output}
[1] 108

~~~



~~~{.r}
expo <- function(base, power) {
  result <- 1
  for (i in seq(power)) {
    result <- result * base
  }
  return(result)
}
expo(2, 4)
~~~



~~~{.output}
[1] 16

~~~



~~~{.r}
# Challenge - Using loops to analyze multiple files
analyze_all <- function(pattern) {
  # Runs the function analyze for each file in the current working directory
  # that contains the given pattern.
  filenames <- list.files(path = "data", pattern = pattern, full.names = TRUE)
  for (f in filenames) {
    analyze(f)
  }
}
~~~

## [Loops in R](03-supp-loops-in-depth.html)

## [Making Choices](04-cond-colors-R.html)

## [Making Choices](04-cond.html)


~~~{.r}
# Challenge - Using conditions to change behaviour
plot_dist <- function(x, threshold) {
  if (length(x) > threshold) {
    boxplot(x)
  } else {
    stripchart(x)
  }
}

plot_dist <- function(x, threshold, use_boxplot = TRUE) {
  if (length(x) > threshold & use_boxplot) {
    boxplot(x)
  } else if (length(x) > threshold & !use_boxplot) {
    hist(x)
  } else {
    stripchart(x)
  }
}

# Challenge - Changing behaviour of the plot command
analyze <- function(filename, output = NULL) {
  # Plots the average, min, and max inflammation over time.
  # Input:
  #    filename: character string of a csv file
  #    output: character string of pdf file for saving
  if (!is.null(output)) {
    pdf(output)
  }
  dat <- read.csv(file = filename, header = FALSE)
  avg_day_inflammation <- apply(dat, 2, mean)
  plot(avg_day_inflammation, type = "l")
  max_day_inflammation <- apply(dat, 2, max)
  plot(max_day_inflammation, type = "l")
  min_day_inflammation <- apply(dat, 2, min)
  plot(min_day_inflammation, type = "l")
  if (!is.null(output)) {
    dev.off()
  }
}
~~~

## [Best Practices for Using R and Designing Programs](06-best-practices-R.html)

## [Command-Line Programs](05-cmdline.html)


~~~{.r}
# Challenge - A simple command line program
cat arith.R
~~~




~~~{.output}
main <- function() {
  # Performs addition or subtraction from the command line.
  #
  # Takes three arguments:
  # The first and third are the numbers.
  # The second is either + for addition or - for subtraction.
  #
  # Ex. usage:
  #   Rscript arith.R 1 + 2
  #   Rscript arith.R 3 - 4
  #
  args <- commandArgs(trailingOnly = TRUE)
  num1 <- as.numeric(args[1])
  operation <- args[2]
  num2 <- as.numeric(args[3])
  if (operation == "+") {
    answer <- num1 + num2
    cat(answer)
  } else if (operation == "-") {
    answer <- num1 - num2
    cat(answer)
  } else {
    stop("Invalid input. Use + for addition or - for subtraction.")
  }
}

main()

~~~


~~~{.r}
cat find-pattern.R
~~~




~~~{.output}
main <- function() {
  # Finds all files in the current directory that contain a given pattern.
  #
  # Takes one argument: the pattern to be searched.
  #
  # Ex. usage:
  #   Rscript find-pattern.R csv
  #
  args <- commandArgs(trailingOnly = TRUE)
  pattern <- args[1]
  files <- list.files(pattern = pattern)
  cat(files, sep = "\n")
}

main()

~~~


~~~{.r}
## Challenge - A command line program with arguments
cat check.R
~~~




~~~{.output}
main <- function() {
  # Checks that all csv files have the same number of rows and columns.
  #
  # Takes multiple arguments: the names of the files to be checked.
  #
  # Ex. usage:
  #   Rscript check.R inflammation-*
  #
  args <- commandArgs(trailingOnly = TRUE)
  first_file <- read.csv(args[1], header = FALSE)
  first_dim <- dim(first_file)
#   num_rows <- dim(args[1])[1]  # nrow(args[1])
#   num_cols <- dim(args[1])[2]  # ncol(args[1])
  for (filename in args[-1]) {
    new_file <- read.csv(filename, header = FALSE)
    new_dim <- dim(new_file)
    if (new_dim[1] != first_dim[1] | new_dim[2] != first_dim[2]) {
      cat("Not all the data files have the same dimensions.")
    }
  }
}

main()

~~~


~~~{.r}
# Challenge - Shorter command line arguments
cat readings-usage.R
~~~




~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  if (!(action %in% c("--min", "--mean", "--max"))) {
    usage()
  } else if (length(filenames) == 0) {
    process(file("stdin"), action)
  } else {  
    for (f in filenames) {
      process(f, action)
    }
  }
}

process <- function(filename, action) {
  dat <- read.csv(file = filename, header = FALSE)
  
  if (action == "--min") {
    values <- apply(dat, 1, min)
  } else if (action == "--mean") {
    values <- apply(dat, 1, mean)
  } else if (action == "--max") {
    values <- apply(dat, 1, max)
  }
  cat(values, sep = "\n")
}

usage <- function() {
  cat("usage: Rscript readings-usage.R [--min, --mean, --max] filenames", sep = "\n")
}

main()

~~~


~~~{.r}
# Challenge - Implementing wc in R
cat line-count.R
~~~




~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) > 0) {
    for (filename in args) {
      input <- readLines(filename)
      num_lines <- length(input)
      cat(filename)
      cat(" ")
      cat(num_lines, sep = "\n")
    }
  } else {
    input <- readLines(file("stdin"))
    num_lines <- length(input)
    cat(num_lines, sep = "\n")
  }
}

main()

~~~

## [Dynamic Reports with knitr](07-knitr-R.html)

## [Making Packages in R](08-making-packages-R.html)

## Using Git in RStudio

Some instructors will demo RStudio's git integration at some point during the
workshop. This often goes over very well, but there can be a few snags with the
setup. First, RStudio may not know where to find git. You can specify where git
is located in _Tools > Global Options > Git/SVN_; on Mac/Linux git is often in
`usr/bin/git` or `usr/local/bin/git` and on Windows it is often in
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
