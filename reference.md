---
layout: page
title: Programming with R
subtitle: Reference
---

# Basic Operation

- `# this is a comment in R`
- Use `x <- 3` to assign a value, `3`,  to a variable, `x`
- R counts from 1, unlike many other programming languages (e.g., Python)
- `length(thing)` returns the number of elements contained in the variable
  `collection`
- `c(value1, value2, value3)` creates a vector
- `container[i]` selects the i'th element from the variable `container`

List objects in current environment
`ls()`

Remove objects in current environment
`rm(x)`

Remove all objects from current environment
`rm(list = ls())`

# Control Flow

- Create a contitional using `if`, `else if`, and `else`

		if(x > 0){
			print("value is positive")
		} else if (x < 0){
			print("value is negative")
		} else{
			print("value is neither positive nor negative")
		}

- create a `for` loop to process elements in a collection one at a time

		for (i in 1:5) {
			print(i)
		}

This will print:

		1
		2
		3
		4
		5


- Use `==` to test for equality
  - `3 == 3`, will return `TRUE`,
  - `'apple' == 'orange'` will return `FALSE`
- `X & Y` is `TRUE` is both X and Y are true
- `X | Y` is `TRUE` if either X or Y, or both are true

# Functions

- Defining a function:

		is_positive <- function(integer_value){
			if(integer_value > 0){
			   TRUE
			else{
			   FALSE
			{
		}

In R, the last executed line of a function is automatically returned

- Specifying a default value for a function argrment

		increment_me <- function(value_to_increment, value_to_increment_by = 1){
			value_to_increment + value_to_increment_by
		}

`increment_me(4)`, will return 5

`intrement_me(4, 6)`, will return 10

- Call a function by using `function_name(function_arguments)`

	- apply family of functions:

			apply()
			sapply()
			lapply()
			mapply()

`apply(dat, MARGIN = 2, mean)`
will return the average (`mean`) of each column in `dat`

# Packages
- Install package by using `install.packages("package-name")`
- Update packages by using `update.packages("package-name")`
- Load packages by using `library("package-name")`

# Glossary

**<a name="argument">argument</a>**:
A value given to a function or program when it runs.
The term is often used interchangeably (and inconsistently) with
[parameter](#parameter).

**<a name="call-stack">call stack</a>**:
A data structure inside a running program that keeps track of active function calls.
Each call's variables are stored in a [stack frame](#stack-frame);
a new stack frame is put on top of the stack for each call,
and discarded when the call is finished.

**<a name="csv">comma-separated values</a>** (CSV):
A common textual representation for tables in which the values in each row are
separated by commas. 

**<a name="comment">comment</a>**:
A remark in a program that is intended to help human readers understand what is
going on, but is ignored by the computer.
Comments in Python, R, and the Unix shell start with a `#` character and run to
the end of the line; comments in SQL start with `--`, and other languages have
other conventions.

**<a name="conditional-statement">conditional statement</a>**:
A statement in a program that might or might not be executed
depending on whether a test is true or false.

**<a name="documentation">documentation</a>**:
Human-language text written to explain what software does,
how it works,
or how to use it.

**<a name="encapsulation">encapsulation</a>**:
The practice of hiding something's implementation details
so that the rest of a program can worry about *what* it does
rather than *how* it does it.

**<a name="for-loop">for loop</a>**:
A loop that is executed once for each value in some kind of set, list, or range.
See also: [while loop](#while-loop).

**<a name="function-body">function body</a>**:
The statements that are executed inside a function.

**<a name="function-call">function call</a>**:
A use of a function in another piece of software.

**<a name="function-composition">function composition</a>**:
The immediate application of one function to the result of another,
such as `f(g(x))`.

**<a name="index">index</a>**:
A subscript that specifies the location of a single value in a collection,
such as a single pixel in an image.

**<a name="loop-variable">loop variable</a>**:
The variable that keeps track of the progress of the loop.

**<a name="notional-machine">notional machine</a>**:
An abstraction of a computer used to think about what it can and will do.

**<a name="parameter">parameter</a>**:
A variable named in the function's declaration that is used to hold a value passed into the call.
The term is often used interchangeably (and inconsistently) with
[argument](#argument).

**<a name="pipe">pipe</a>**:
A connection from the output of one program to the input of another.
When two or more programs are connected in this way, they are called a "pipeline".

**<a name="return-statement">return statement</a>**:
A statement that causes a function to stop executing and return a value to its caller immediately.

**<a name="shape">shape</a>** (of an array):
An array's dimensions, represented as a vector.
For example, a 5&times;3 array's shape is `(5,3)`.

**<a name="silent-failure">silent failure</a>**:
Failing without producing any warning messages.
Silent failures are hard to detect and debug.

**<a name="slice">slice</a>**:
A regular subsequence of a larger sequence,
such as the first five elements or every second element.

**<a name="stack-frame">stack frame</a>**:
A data structure that provides storage for a function's local variables.
Each time a function is called,
a new stack frame is created
and put on the top of the [call stack](#call-stack).
When the function returns,
the stack frame is discarded.

**<a name="standard-input">standard input</a>** (stdin):
A process's default input stream.
In interactive command-line applications,
it is typically connected to the keyboard;;
in a [pipe](#pipe),
it receives data from the [standard output](#standard-output) of the preceding process.

**<a name="standard-output">standard output</a>** (stdout):
A process's default output stream.
In interactive command-line applications,
data sent to standard output is displayed on the screen;
in a [pipe](#pipe),
it is passed to the [standard input](#standard-input) of the next process.

**<a name="string">string</a>**:
Short for "character string", a [sequence](#sequence) of zero or more characters.

**<a name="while-loop">while loop</a>**:
A loop that keeps executing as long as some condition is true.
See also: [for loop](#for-loop).
