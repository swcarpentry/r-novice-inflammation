---
layout: page
title: Programming with R
subtitle: Command-Line Programs
minutes: 30
---



> ## Learning Objectives {.objectives}
>
> *   Use the values of command-line arguments in a program.
> *   Handle flags and files separately in a command-line program.
> *   Read data from standard input in a program so that it can be used in a pipeline.

The R Console and other interactive tools like RStudio are great for prototyping code and exploring data, but sooner or later we will want to use our program in a pipeline or run it in a shell script to process thousands of data files.
In order to do that, we need to make our programs work like other Unix command-line tools.
For example, we may want a program that reads a data set and prints the average inflammation per patient:

~~~
$ Rscript readings.R --mean data/inflammation-01.csv
5.45
5.425
6.1
...
6.4
7.05
5.9
~~~

but we might also want to look at the minimum of the first four lines

~~~
$ head -4 data/inflammation-01.csv | Rscript readings.R --min
~~~

or the maximum inflammations in several files one after another:

~~~
$ Rscript readings.R --max data/inflammation-*.csv
~~~

Our overall requirements are:

1. If no filename is given on the command line, read data from [standard input](reference.html#standard-input-(stdin)).
2. If one or more filenames are given, read data from them and report statistics for each file separately.
3. Use the `--min`, `--mean`, or `--max` flag to determine what statistic to print.

To make this work, we need to know how to handle command-line arguments in a program, and how to get at standard input.
We'll tackle these questions in turn below.

### Command-Line Arguments

Using the text editor of your choice, save the following line of code in a text file called `session-info.R`:


~~~{.output}
sessionInfo()

~~~

The function, `sessionInfo`, outputs the version of R you are running as well as the type of computer you are using (as well as the versions of the packages that have been loaded).
This is very useful information to include when asking others for help with your R code.

Now we can run the code in the file we created from the Unix Shell using `Rscript`:


~~~{.r}
Rscript session-info.R
~~~




~~~{.output}
R version 3.2.4 (2016-03-10)
Platform: x86_64-apple-darwin13.4.0 (64-bit)
Running under: OS X 10.11.5 (El Capitan)

locale:
[1] en_AU.UTF-8/en_AU.UTF-8/en_AU.UTF-8/C/en_AU.UTF-8/en_AU.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  base     

~~~

> ## Tip {.callout}
>
> If that did not work, you might have seen an error message indicating that the file `session-info.R` does not exist.
> Remember that you must be in the correct directory, the one in which you created your script file.
> You can determine which directory you are currently in using `pwd` and change to a different directory using `cd`.
> For a review, see this [lesson](https://swcarpentry.github.io/shell-novice/01-filedir.html).

Now let's create another script that does something more interesting. Write the following lines in a file named `print-args.R`:


~~~{.output}
args <- commandArgs()
cat(args, sep = "\n")

~~~

The function `commandArgs` extracts all the command line arguments and returns them as a vector.
The function `cat`, similar to the `cat` of the Unix Shell, outputs the contents of the variable.
Since we did not specify a filename for writing, `cat` sends the output to [standard output](reference.html#standard-output-(stdout)), which we can then pipe to other Unix functions.
Because we set the argument `sep` to `"\n"`, which is the symbol to start a new line, each element of the vector is printed on its own line.
Let's see what happens when we run this program in the Unix Shell:


~~~{.r}
Rscript print-args.R
~~~




~~~{.output}
/Library/Frameworks/R.framework/Resources/bin/exec/R
--slave
--no-restore
--file=print-args.R

~~~

From this output, we learn that `Rscript` is just a convenience command for running R scripts.
The first argument in the vector is the path to the `R` executable.
The following are all command-line arguments that affect the behavior of R.
From the R help file:

*  `--slave`: Make R run as quietly as possible
*  `--no-restore`:  Don't restore anything that was created during the R session
*  `--file`: Run this file
*  `--args`: Pass these arguments to the file being run

Thus running a file with Rscript is an easier way to run the following:


~~~{.r}
R --slave --no-restore --file=print-args.R --args
~~~




~~~{.output}
/Library/Frameworks/R.framework/Resources/bin/exec/R
--slave
--no-restore
--file=print-args.R
--args

~~~

If we run it with a few arguments, however:


~~~{.r}
Rscript print-args.R first second third
~~~




~~~{.output}
/Library/Frameworks/R.framework/Resources/bin/exec/R
--slave
--no-restore
--file=print-args.R
--args
first
second
third

~~~

then `commandArgs` adds each of those arguments to the vector it returns.
Since the first elements of the vector are always the same, we can tell `commandArgs` to only return the arguments that come after `--args`.
Let's update `print-args.R` and save it as `print-args-trailing.R`:


~~~{.output}
args <- commandArgs(trailingOnly = TRUE)
cat(args, sep = "\n")

~~~

And then run `print-args-trailing` from the Unix Shell:


~~~{.r}
Rscript print-args-trailing.R first second third
~~~




~~~{.output}
first
second
third

~~~

Now `commandArgs` returns only the arguments that we listed after `print-args-trailing.R`.

With this in hand, let's build a version of `readings.R` that always prints the per-patient (per-row) mean of a single data file.
The first step is to write a function that outlines our implementation, and a placeholder for the function that does the actual work.
By convention this function is usually called `main`, though we can call it whatever we want.
Write the following code in a file called `readings-01.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  filename <- args[1]
  dat <- read.csv(file = filename, header = FALSE)
  mean_per_patient <- apply(dat, 1, mean)
  cat(mean_per_patient, sep = "\n")
}

~~~


This function gets the name of the file to process from the first element returned by `commandArgs`.
Here's a simple test to run from the Unix Shell:


~~~{.r}
Rscript readings-01.R data/inflammation-01.csv
~~~

There is no output because we have defined a function, but haven't actually called it.
Let's add a call to `main` and save it as `readings-02.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  filename <- args[1]
  dat <- read.csv(file = filename, header = FALSE)
  mean_per_patient <- apply(dat, 1, mean)
  cat(mean_per_patient, sep = "\n")
}

main()

~~~


~~~{.r}
Rscript readings-02.R data/inflammation-01.csv
~~~




~~~{.output}
5.45
5.425
6.1
5.9
5.55
6.225
5.975
6.65
6.625
6.525
6.775
5.8
6.225
5.75
5.225
6.3
6.55
5.7
5.85
6.55
5.775
5.825
6.175
6.1
5.8
6.425
6.05
6.025
6.175
6.55
6.175
6.35
6.725
6.125
7.075
5.725
5.925
6.15
6.075
5.75
5.975
5.725
6.3
5.9
6.75
5.925
7.225
6.15
5.95
6.275
5.7
6.1
6.825
5.975
6.725
5.7
6.25
6.4
7.05
5.9

~~~

> ## Challenge - A simple command line program {.challenge}
>
>  + Write a command-line program that does addition and subtraction.
>  **Hint:** Everything argument read from the command-line is interpreted as a character [string](reference.html#string).
>  You can convert from a string to a number using the function `as.numeric`.
> 
> ~~~{.r}
> Rscript arith.R 1 + 2
> ~~~
> 
> 
> 
> 
> ~~~{.output}
> 3
> 
> ~~~
>
> 
> ~~~{.r}
> Rscript arith.R 3 - 4
> ~~~
> 
> 
> 
> 
> ~~~{.output}
> -1
> 
> ~~~
>
>  + What goes wrong if you try to add multiplication using `*` to the program?
>
> <!-- second-answer -->
> <!-- The * is a wildcard character in the Unix Shell. -->
> <!-- Thus all the files in the current working directory are included as arguments to  arith.R. -->
>
>  + Using the function `list.files` introduced in a previous [lesson](03-loops-R.html), write a command-line program, `find-pattern.R`, that lists all the files in the current directory that contain a specific pattern:
>
> 
> ~~~{.r}
> # For example, searching for the pattern "print-args" returns the two scripts we
> # wrote earlier
> Rscript find-pattern.R print-args
> ~~~
> 
> 
> 
> 
> ~~~{.output}
> print-args-trailing.R
> print-args.R
> 
> ~~~
>


### Handling Multiple Files

The next step is to teach our program how to handle multiple files.
Since 60 lines of output per file is a lot to page through, we'll start by using three smaller files, each of which has three days of data for two patients.
Let's investigate them from the Unix Shell:


~~~{.r}
ls data/small-*.csv
~~~




~~~{.output}
data/small-01.csv
data/small-02.csv
data/small-03.csv

~~~


~~~{.r}
cat data/small-01.csv
~~~




~~~{.output}
0,0,1
0,1,2

~~~


~~~{.r}
Rscript readings-02.R data/small-01.csv
~~~




~~~{.output}
0.3333333
1

~~~

Using small data files as input also allows us to check our results more easily: here, for example, we can see that our program is calculating the mean correctly for each line, whereas we were really taking it on faith before.
This is yet another rule of programming: test the simple things first.

We want our program to process each file separately, so we need a loop that executes once for each filename.
If we specify the files on the command line, the filenames will be returned by `commandArgs(trailingOnly = TRUE)`.
We'll need to handle an unknown number of filenames, since our program could be run for any number of files.

The solution is to loop over the vector returned by `commandArgs(trailingOnly = TRUE)`.
Here's our changed program, which we'll save as `readings-03.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  for (filename in args) {
    dat <- read.csv(file = filename, header = FALSE)
    mean_per_patient <- apply(dat, 1, mean)
    cat(mean_per_patient, sep = "\n")
  }
}

main()

~~~

and here it is in action:


~~~{.r}
Rscript readings-03.R data/small-01.csv data/small-02.csv
~~~




~~~{.output}
0.3333333
1
13.66667
11

~~~

**Note**: at this point, we have created three versions of our script called `readings-01.R`, `readings-02.R`, and `readings-03.R`.
We wouldn't do this in real life: instead, we would have one file called `readings.R` that we committed to version control every time we got an enhancement working.
For teaching, though, we need all the successive versions side by side.

> ## Challenge - A command line program with arguments  {.challenge}
>
>  + Write a program called `check.R` that takes the names of one or more inflammation data files as arguments and checks that all the files have the same number of rows and columns.
>  What is the best way to test your program?





### Handling Command-Line Flags

The next step is to teach our program to pay attention to the `--min`, `--mean`, and `--max` flags.
These always appear before the names of the files, so let's save the following in `readings-04.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  
  for (f in filenames) {
    dat <- read.csv(file = f, header = FALSE)
    
    if (action == "--min") {
      values <- apply(dat, 1, min)
    } else if (action == "--mean") {
      values <- apply(dat, 1, mean)
    } else if (action == "--max") {
      values <- apply(dat, 1, max)
    }
    cat(values, sep = "\n")
  }
}

main()

~~~

And we can confirm this works by running it from the Unix Shell:


~~~{.r}
Rscript readings-04.R --max data/small-01.csv
~~~




~~~{.output}
1
2

~~~

but there are several things wrong with it:

1.  `main` is too large to read comfortably.

2.  If `action` isn't one of the three recognized flags, the program loads each file but does nothing with it (because none of the branches in the conditional match).
    [Silent failures](reference.html#silent-failure) like this are always hard to debug.

This version pulls the processing of each file out of the loop into a function of its own.
It also checks that `action` is one of the allowed flags before doing any processing, so that the program fails fast. We'll save it as `readings-05.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  stopifnot(action %in% c("--min", "--mean", "--max"))
  
  for (f in filenames) {
    process(f, action)
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

main()

~~~

This is four lines longer than its predecessor, but broken into more digestible chunks of 8 and 12 lines.

> ## Tip {.callout}
>
> R has a package named [argparse][argparse-r] that helps handle complex command-line flags (it utilizes a [Python module][argparse-py] of the same name).
> We will not cover this package in this lesson but when you start writing programs with multiple parameters you'll want to read through the package's [vignette][].

[argparse-r]: http://cran.r-project.org/web/packages/argparse/index.html
[argparse-py]: http://docs.python.org/dev/library/argparse.html
[vignette]: http://cran.r-project.org/web/packages/argparse/vignettes/argparse.pdf

> ## Challenge - Shorter command line arguments {.challenge}
>
>  + Rewrite this program so that it uses `-n`, `-m`, and `-x` instead of `--min`, `--mean`, and `--max` respectively.
>    Is the code easier to read?
>    Is the program easier to understand?
>
>  + Separately, modify the program so that if no action is specified (or an incorrect action is given), it prints a message explaining how it should be used.



### Handling Standard Input

The next thing our program has to do is read data from standard input if no filenames are given so that we can put it in a pipeline, redirect input to it, and so on.
Let's experiment in another script, which we'll save as `count-stdin.R`:


~~~{.output}
lines <- readLines(con = file("stdin"))
count <- length(lines)
cat("lines in standard input: ")
cat(count, sep = "\n")

~~~

This little program reads lines from the program's standard input using `file("stdin")`.
This allows us to do almost anything with it that we could do to a regular file.
In this example, we passed it as an argument to the function `readLines`, which stores each line as an element in a vector.
Let's try running it from the Unix Shell as if it were a regular command-line program:


~~~{.r}
Rscript count-stdin.R < data/small-01.csv
~~~




~~~{.output}
lines in standard input: 2

~~~

Note that because we did not specify `sep = "\n"` when calling `cat`, the output is written on the same line.

A common mistake is to try to run something that reads from standard input like this:


~~~{.r}
Rscript count-stdin.R data/small-01.csv
~~~

i.e., to forget the `<` character that redirect the file to standard input.
In this case, there's nothing in standard input, so the program waits at the start of the loop for someone to type something on the keyboard.
We can type some input, but R keeps running because it doesn't know when the standard input has ended.
If you ran this, you can pause R by typing `ctrl`+`z` (technically it is still paused in the background; if you want to fully kill the process follow these [instructions][ps-kill]).

[ps-kill]: http://linux.about.com/library/cmd/blcmdl_kill.htm

We now need to rewrite the program so that it loads data from `file("stdin")` if no filenames are provided.
Luckily, `read.csv` can handle either a filename or an open file as its first parameter, so we don't actually need to change `process`.
That leaves `main`, which we'll update and save as `readings-06.R`:


~~~{.output}
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  stopifnot(action %in% c("--min", "--mean", "--max"))
  
  if (length(filenames) == 0) {
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

main()

~~~

Let's try it out.
Instead of calculating the mean inflammation of every patient, we'll only calculate the mean for the first 10 patients (rows):


~~~{.r}
head data/inflammation-01.csv | Rscript readings-06.R --mean
~~~




~~~{.output}
5.45
5.425
6.1
5.9
5.55
6.225
5.975
6.65
6.625
6.525

~~~

And now we're done: the program now does everything we set out to do.

> ## Challenge - Implementing wc in R {.challenge}
>
>  + Write a program called `line-count.R` that works like the Unix `wc` command:
>    *   If no filenames are given, it reports the number of lines in standard input.
>    *   If one or more filenames are given, it reports the number of lines in each, followed by the total number of lines.



> ## Key Points {.callout}
>
> *   Use `commandArgs(trailingOnly = TRUE)` to obtain a vector of the command-line arguments that a program was run with.
> *   Avoid silent failures.
> *   Use `file("stdin")` to connect to a program's standard input.
> *   Use `cat(vec, sep = "\n")` to write the elements of `vec` to standard output, one per line.
