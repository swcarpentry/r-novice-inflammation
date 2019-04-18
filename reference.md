---
layout: reference
root: .
---

## Basic Operation

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

## Control Flow

- Create a conditional using `if`, `else if`, and `else`

~~~
if(x > 0){
	print("value is positive")
} else if (x < 0){
	print("value is negative")
} else{
	print("value is neither positive nor negative")
}
~~~
{: .language-r}

- create a `for` loop to process elements in a collection one at a time

~~~
for (i in 1:5) {
	print(i)
}
~~~
{: .language-r}

This will print:

~~~
1
2
3
4
5
~~~
{: .output}


- Use `==` to test for equality
  - `3 == 3`, will return `TRUE`,
  - `'apple' == 'orange'` will return `FALSE`
- `X & Y` is `TRUE` is both X and Y are true
- `X | Y` is `TRUE` if either X or Y, or both are true

## Functions

- Defining a function:

~~~
is_positive <- function(integer_value){
	if(integer_value > 0){
	   TRUE
	}
	else{
	   FALSE
	{
}
~~~
{: .language-r}

In R, the last executed line of a function is automatically returned

- Specifying a default value for a function argument

~~~
increment_me <- function(value_to_increment, value_to_increment_by = 1){
	value_to_increment + value_to_increment_by
}
~~~
{: .language-r}

`increment_me(4)`, will return 5

`increment_me(4, 6)`, will return 10

- Call a function by using `function_name(function_arguments)`

- apply family of functions: `apply()`, `sapply()`, `lapply()`, and `mapply()`

`apply(dat, MARGIN = 2, mean)` will return the average (`mean`) of each column in `dat`

## Packages

- Install package by using `install.packages("package-name")`
- Update packages by using `update.packages("package-name")`
- Load packages by using `library("package-name")`

## Glossary

{:auto_ids}
argument
:   A value given to a function or program when it runs. The term is often used interchangeably
(and inconsistently) with [parameter](#parameter).

call stack
:   A data structure inside a running program that keeps track of active function calls. Each call's
variables are stored in a [stack frame](#stack-frame); a new stack frame is put on top of the stack
for each call, and discarded when the call is finished.

comma-separated values (CSV)
:   A common textual representation for tables in which the values in each row are separated by commas.

comment
:   A remark in a program that is intended to help human readers understand what is going on, but is
ignored by the computer. Comments in Python, R, and the Unix shell start with a `#` character and run
to the end of the line; comments in SQL start with `--`, and other languages have other conventions.

conditional statement
:   A statement in a program that might or might not be executed depending on whether a test is true
or false.

dimensions (of an array)
:   An array's extent, represented as a vector. For example, an array with 5 rows and 3 columns has
dimensions `(5,3)`.

documentation
:   Human-language text written to explain what software does, how it works, or how to use it.

encapsulation
:   The practice of hiding something's implementation details so that the rest of a program can
worry about *what* it does rather than *how* it does it.

for loop
:   A loop that is executed once for each value in some kind of set, list, or range. See also:
[while loop](#while-loop).

function body
:   The statements that are executed inside a function.

function call
:   A use of a function in another piece of software.

function composition
:   The immediate application of one function to the result of another, such as `f(g(x))`.

index
:   A subscript that specifies the location of a single value in a collection, such as a single
pixel in an image.

loop variable
:   The variable that keeps track of the progress of the loop.

notional machine
:   An abstraction of a computer used to think about what it can and will do.

parameter
:   A variable named in the function's declaration that is used to hold a value passed into the call.
The term is often used interchangeably (and inconsistently) with [argument](#argument).

pipe
:   A connection from the output of one program to the input of another. When two or more programs
are connected in this way, they are called a "pipeline".

return statement
:   A statement that causes a function to stop executing and return a value to its caller immediately.

silent failure
:   Failing without producing any warning messages. Silent failures are hard to detect and debug.

slice
:   A regular subsequence of a larger sequence, such as the first five elements or every second element.

stack frame
:   A data structure that provides storage for a function's local variables. Each time a function is
called, a new stack frame is created and put on the top of the [call stack](#call-stack). When the
function returns, the stack frame is discarded.

standard input (stdin)
:   A process's default input stream. In interactive command-line applications, it is typically
connected to the keyboard; in a [pipe](#pipe), it receives data from the
[standard output](#standard-output-stdout) of the preceding process.

standard output (stdout)
:   A process's default output stream. In interactive command-line applications, data sent to
standard output is displayed on the screen; in a [pipe](#pipe), it is passed to the
[standard input](#standard-input-stdin) of the next process.

string
:   Short for "character string", a sequence of zero or more characters.

while loop
:   A loop that keeps executing as long as some condition is true. See also: [for loop](#for-loop).
