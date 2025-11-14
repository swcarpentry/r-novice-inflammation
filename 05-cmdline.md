---
title: Command-Line Programs
teaching: 30
exercises: 50
source: Rmd
---



::::::::::::::::::::::::::::::::::::::: objectives

- Use the values of command-line arguments in a program.
- Handle flags and files separately in a command-line program.
- Read data from standard input in a program so that it can be used in a pipeline.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I write a command-line script?
- How do I read in arguments from the command-line?

::::::::::::::::::::::::::::::::::::::::::::::::::

The R Console and other interactive tools like RStudio are great for prototyping code and exploring data, but sooner or later we will want to use our program in a pipeline or run it in a shell script to process thousands of data files.
In order to do that, we need to make our programs work like other Unix command-line tools.
For example, we may want a program that reads a data set and prints the average inflammation per patient:

```bash
$ Rscript readings.R --mean data/inflammation-01.csv
5.45
5.425
6.1
...
6.4
7.05
5.9
```

but we might also want to look at the minimum of the first four lines

```bash
$ head -4 data/inflammation-01.csv | Rscript readings.R --min
```

or the maximum inflammations in several files one after another:

```bash
$ Rscript readings.R --max data/inflammation-*.csv
```

Our overall requirements are:

1. If no filename is given on the command line, read data from [standard input](../learners/reference.md#standard-input-stdin).
2. If one or more filenames are given, read data from them and report statistics for each file separately.
3. Use the `--min`, `--mean`, or `--max` flag to determine what statistic to print.

To make this work, we need to know how to handle command-line arguments in a program, and how to get at standard input.
We'll tackle these questions in turn below.

### Command-Line Arguments

Using the text editor of your choice, save the following line of code in a text file called `session-info.R`:


``` output
sessionInfo()
```

The function, `sessionInfo`, outputs the version of R you are running as well as the type of computer you are using (as well as the versions of the packages that have been loaded).
This is very useful information to include when asking others for help with your R code.

Now we can run the code in the file we created from the Unix Shell using `Rscript`:


``` bash
Rscript session-info.R
```

``` output
R version 4.5.1 (2025-06-13)
Platform: x86_64-pc-linux-gnu
Running under: Ubuntu 24.04.3 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

time zone: Etc/UTC
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

loaded via a namespace (and not attached):
[1] compiler_4.5.1
```

:::::::::::::::::::::::::::::::::::::::::  callout

## The Right Directory

If that did not work, you might have seen an error message indicating that the file `session-info.R` does not exist.
Remember that you must be in the correct directory, the one in which you created your script file.
You can determine which directory you are currently in using `pwd` and change to a different directory using `cd`.
For a review, see this [lesson](https://swcarpentry.github.io/shell-novice/02-filedir/).

::::::::::::::::::::::::::::::::::::::::::::::::::

Now let's create another script that does something more interesting.
Write the following lines in a file named `print-args.R`:


``` output
args <- commandArgs()
cat(args, sep = "\n")
```

The function `commandArgs` extracts all the command line arguments and returns them as a vector.
The function `cat`, similar to the `cat` of the Unix Shell, outputs the contents of the variable.
Since we did not specify a filename for writing, `cat` sends the output to [standard output](../learners/reference.md#standard-output-stdout), which we can then pipe to other Unix functions.
Because we set the argument `sep` to `"\n"`, which is the symbol to start a new line, each element of the vector is printed on its own line.
Let's see what happens when we run this program in the Unix Shell:


``` bash
Rscript print-args.R
```

``` output
/usr/local/lib/R/bin/exec/R
--no-save
--no-restore
--no-echo
--no-restore
--file=print-args.R
```

From this output, we learn that `Rscript` is just a convenience command for running R scripts.
The first argument in the vector is the path to the `R` executable.
The following are all command-line arguments that affect the behavior of R.
From the R help file:

- `--no-echo`: Make R run as quietly as possible
- `--no-restore`: Don't restore anything that was created during the R session
- `--file`: Run this file
- `--args`: Pass these arguments to the file being run

Thus running a file with Rscript is an easier way to run the following:


``` bash
R --no-echo --no-restore --file=print-args.R --args
```

``` output
/usr/local/lib/R/bin/exec/R
--no-save
--no-restore
--no-echo
--no-restore
--file=print-args.R
--args
```

If we run it with a few arguments, however:


``` bash
Rscript print-args.R first second third
```

``` output
/usr/local/lib/R/bin/exec/R
--no-save
--no-restore
--no-echo
--no-restore
--file=print-args.R
--args
first
second
third
```

then `commandArgs` adds each of those arguments to the vector it returns.
Since the first elements of the vector are always the same, we can tell `commandArgs` to only return the arguments that come after `--args`.
Let's update `print-args.R` and save it as `print-args-trailing.R`:


``` output
args <- commandArgs(trailingOnly = TRUE)
cat(args, sep = "\n")
```

And then run `print-args-trailing` from the Unix Shell:


``` bash
Rscript print-args-trailing.R first second third
```

``` output
first
second
third
```

Now `commandArgs` returns only the arguments that we listed after `print-args-trailing.R`.

With this in hand, let's build a version of `readings.R` that always prints the per-patient (per-row) mean of a single data file.
The first step is to write a function that outlines our implementation, and a placeholder for the function that does the actual work.
By convention this function is usually called `main`, though we can call it whatever we want.
Write the following code in a file called `readings-01.R`:


``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  filename <- args[1]
  dat <- read.csv(file = filename, header = FALSE)
  mean_per_patient <- apply(dat, 1, mean)
  cat(mean_per_patient, sep = "\n")
}
```

This function gets the name of the file to process from the first element returned by `commandArgs`.
Here's a simple test to run from the Unix Shell:


``` bash
Rscript readings-01.R data/inflammation-01.csv
```

There is no output because we have defined a function, but haven't actually called it.
Let's add a call to `main` and save it as `readings-02.R`:


``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  filename <- args[1]
  dat <- read.csv(file = filename, header = FALSE)
  mean_per_patient <- apply(dat, 1, mean)
  cat(mean_per_patient, sep = "\n")
}

main()
```


``` bash
Rscript readings-02.R data/inflammation-01.csv
```

``` output
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
```

:::::::::::::::::::::::::::::::::::::::  challenge

## A Simple Command-Line Program

1. Write a command-line program that does addition and subtraction of two numbers.

:::::::::::::::  hint

Everything argument read from the command-line is interpreted as a character [string](../learners/reference.md#string).
You can convert from a string to a number using the function `as.numeric`.


``` bash
Rscript arith.R 1 + 2
```

``` output
3
```


``` bash
Rscript arith.R 3 - 4
```

``` output
-1
```

:::::::::::::::

:::::::::::::::  solution


``` bash
cat arith.R
```

``` output
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
```

:::::::::::::::::::::::::

2. What goes wrong if you try to add multiplication using `*` to the program?

:::::::::::::::  solution

An error message is returned due to "invalid input." This is likely because '\*' has a special meaning in the shell, as a wildcard.

:::::::::::::::::::::::::

3. Using the function `list.files` introduced in a previous [lesson](03-loops-R.Rmd),
  write a command-line program called `find-pattern.R`
  that lists all the files in the current directory that contain a specific pattern:


``` bash
# For example, searching for the pattern "print-args" returns the two scripts we wrote earlier
Rscript find-pattern.R print-args
```

``` output
print-args-trailing.R
print-args.R
```

:::::::::::::::  solution


``` bash
cat find-pattern.R
```

``` output
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
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Handling Multiple Files

The next step is to teach our program how to handle multiple files.
Since 60 lines of output per file is a lot to page through, we'll start by using three smaller files, each of which has three days of data for two patients.
Let's investigate them from the Unix Shell:


``` bash
ls data/small-*.csv
```

``` output
data/small-01.csv
data/small-02.csv
data/small-03.csv
```


``` bash
cat data/small-01.csv
```

``` output
0,0,1
0,1,2
```


``` bash
Rscript readings-02.R data/small-01.csv
```

``` output
0.3333333
1
```

Using small data files as input also allows us to check our results more easily: here, for example, we can see that our program is calculating the mean correctly for each line, whereas we were really taking it on faith before.
This is yet another rule of programming: test the simple things first.

We want our program to process each file separately, so we need a loop that executes once for each filename.
If we specify the files on the command line, the filenames will be returned by `commandArgs(trailingOnly = TRUE)`.
We'll need to handle an unknown number of filenames, since our program could be run for any number of files.

The solution is to loop over the vector returned by `commandArgs(trailingOnly = TRUE)`.
Here's our changed program, which we'll save as `readings-03.R`:


``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  for (filename in args) {
    dat <- read.csv(file = filename, header = FALSE)
    mean_per_patient <- apply(dat, 1, mean)
    cat(mean_per_patient, sep = "\n")
  }
}

main()
```

and here it is in action:


``` bash
Rscript readings-03.R data/small-01.csv data/small-02.csv
```

``` output
0.3333333
1
13.66667
11
```

**Note**: at this point, we have created three versions of our script called `readings-01.R`, `readings-02.R`, and `readings-03.R`.
We wouldn't do this in real life: instead, we would have one file called `readings.R` that we committed to version control every time we got an enhancement working.
For teaching, though, we need all the successive versions side by side.

:::::::::::::::::::::::::::::::::::::::  challenge

## A Command Line Program with Arguments

Write a program called `check.R` that takes the names of one or more inflammation data files as arguments and checks that all the files have the same number of rows and columns.
What is the best way to test your program?

:::::::::::::::  solution


``` bash
cat check.R
```

``` output
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
#   num_rows <- dim(first_file)[1]  # nrow(first_file)
#   num_cols <- dim(first_file)[2]  # ncol(first_file)
  
  
  for (filename in args[-1]) {
    new_file <- read.csv(filename, header = FALSE)
    new_dim <- dim(new_file)
    if (new_dim[1] != first_dim[1] | new_dim[2] != first_dim[2]) {
      cat("Not all the data files have the same dimensions.")
    }
  }
}

main()
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Handling Command-Line Flags

The next step is to teach our program to pay attention to the `--min`, `--mean`, and `--max` flags.
These always appear before the names of the files, so let's save the following in `readings-04.R`:


``` output
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
```

And we can confirm this works by running it from the Unix Shell:


``` bash
Rscript readings-04.R --max data/small-01.csv
```

``` output
1
2
```

but there are several things wrong with it:

1. `main` is too large to read comfortably.

2. If `action` isn't one of the three recognized flags, the program loads each file but does nothing with it (because none of the branches in the conditional match).
  [Silent failures](../learners/reference.md#silent-failure) like this are always hard to debug.

This version pulls the processing of each file out of the loop into a function of its own.
It also uses `stopifnot` to check that `action` is one of the allowed flags before doing any processing, so that the program fails fast.
We'll save it as `readings-05.R`:


``` output
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
```

This is four lines longer than its predecessor, but broken into more digestible chunks of 8 and 12 lines.

:::::::::::::::::::::::::::::::::::::::::  callout

## Parsing Command-Line Flags

R has a package named [argparse][argparse-r] that helps handle complex command-line flags (it utilizes a [Python module][argparse-py] of the same name).
We will not cover this package in this lesson but when you start writing programs with multiple parameters you'll want to read through the package's [vignette].

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Shorter Command Line Arguments

Rewrite this program so that it uses `-n`, `-m`, and `-x` instead of `--min`, `--mean`, and `--max` respectively.
Is the code easier to read?
Is the program easier to understand?

Separately, modify the program so that if no action is specified (or an incorrect action is given), it prints a message explaining how it should be used.

:::::::::::::::  solution


``` bash
cat readings-short.R
```

``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  stopifnot(action %in% c("-n", "-m", "-x"))

  for (f in filenames) {
    process(f, action)
  }
}

process <- function(filename, action) {
  dat <- read.csv(file = filename, header = FALSE)

  if (action == "-n") {
    values <- apply(dat, 1, min)
  } else if (action == "-m") {
    values <- apply(dat, 1, mean)
  } else if (action == "-x") {
    values <- apply(dat, 1, max)
  }
  cat(values, sep = "\n")
}

main()
```

The program is neither easier to read nor easier to understand due to the ambiguity of the argument names.


``` bash
cat readings-usage.R
```

``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  if (!(action %in% c("--min", "--mean", "--max"))) {
    usage()
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
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Handling Standard Input

The next thing our program has to do is read data from standard input if no filenames are given so that we can put it in a pipeline, redirect input to it, and so on.
Let's experiment in another script, which we'll save as `count-stdin.R`:


``` output
lines <- readLines(con = file("stdin"))
count <- length(lines)
cat("lines in standard input: ")
cat(count, sep = "\n")
```

This little program reads lines from the program's standard input using `file("stdin")`.
This allows us to do almost anything with it that we could do to a regular file.
In this example, we passed it as an argument to the function `readLines`, which stores each line as an element in a vector.
Let's try running it from the Unix Shell as if it were a regular command-line program:


``` bash
Rscript count-stdin.R < data/small-01.csv
```

``` output
lines in standard input: 2
```

Note that because we did not specify `sep = "\n"` when calling `cat`, the output is written on the same line.

A common mistake is to try to run something that reads from standard input like this:


``` bash
Rscript count-stdin.R data/small-01.csv
```

i.e., to forget the `<` character that redirect the file to standard input.
In this case, there's nothing in standard input, so the program waits at the start of the loop for someone to type something on the keyboard.
We can type some input, but R keeps running because it doesn't know when the standard input has ended.
If you ran this, you can pause R by typing <kbd>Ctrl</kbd>\+<kbd>Z</kbd> (technically it is still paused in the background; if you want to fully kill the process type `kill %`; see [bash manual][bash-jobs] for more information).

We now need to rewrite the program so that it loads data from `file("stdin")` if no filenames are provided.
Luckily, `read.csv` can handle either a filename or an open file as its first parameter, so we don't actually need to change `process`.
That leaves `main`, which we'll update and save as `readings-06.R`:


``` output
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
```

Let's try it out.
Instead of calculating the mean inflammation of every patient, we'll only calculate the mean for the first 10 patients (rows):


``` bash
head data/inflammation-01.csv | Rscript readings-06.R --mean
```

``` output
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
```

And now we're done: the program now does everything we set out to do.

:::::::::::::::::::::::::::::::::::::::  challenge

## Implementing `wc` in R

Write a program called `line-count.R` that works like the Unix `wc` command:

- If no filenames are given, it reports the number of lines in standard input.
- If one or more filenames are given, it reports the number of lines in each, followed by the total number of lines.

:::::::::::::::  solution


``` bash
cat line-count.R
```

``` output
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) > 0) {
    total_lines <- 0
    for (filename in args) {
      input <- readLines(filename)
      num_lines <- length(input)
      cat(filename)
      cat(" ")
      cat(num_lines, sep = "\n")
      total_lines <- total_lines + num_lines
    }
    if (length(args) > 1) {
      cat("Total ")
      cat(total_lines, sep = "\n")
    }
  } else {
    input <- readLines(file("stdin"))
    num_lines <- length(input)
    cat(num_lines, sep = "\n")
  }
}

main()
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::



[argparse-r]: https://cran.r-project.org/package=argparse
[argparse-py]: https://docs.python.org/dev/library/argparse.html
[vignette]: https://cran.r-project.org/package=argparse/vignettes/argparse.html
[bash-jobs]: https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Basics


:::::::::::::::::::::::::::::::::::::::: keypoints

- Use `commandArgs(trailingOnly = TRUE)` to obtain a vector of the command-line arguments that a program was run with.
- Avoid silent failures.
- Use `file("stdin")` to connect to a program's standard input.
- Use `cat(vec, sep = "\n")` to write the elements of `vec` to standard output, one per line.

::::::::::::::::::::::::::::::::::::::::::::::::::


