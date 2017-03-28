---
title: "Creating Functions"
teaching: 30
exercises: 0
questions:
- "How do I make a function?"
- "How can I test my functions?"
- "How should I document my code?"
objectives:
- "Define a function that takes arguments."
- "Return a value from a function."
- "Test a function."
- "Set default values for function arguments."
- "Explain why we should divide programs into small, single-purpose functions."
keypoints:
- "Define a function using `name <- function(...args...) {...body...}`."
- "Call a function using `name(...values...)`."
- "R looks for variables in the current stack frame before looking for them at the top level."
- "Use `help(thing)` to view help for something."
- "Put comments at the beginning of functions to provide help for that function."
- "Annotate your code!"
- "Specify default values for arguments when defining a function using `name = value` in the argument list."
- "Arguments can be passed by matching based on name, by position, or by omitting them (in which case the default value is used)."
---



If we only had one data set to analyze, it would probably be faster to load the file into a spreadsheet and use that to plot some simple statistics.
But we have twelve files to check, and may have more in the future.
In this lesson, we'll learn how to write a function so that we can repeat several operations with a single command.

### Defining a Function

Let's start by defining a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:


~~~
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
~~~
{: .r}

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the [body]({{ page.root }}/reference/#function-body) of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces, which makes the code easier to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a [return statement]({{ page.root }}/reference/#return-statement) to send a result back to whoever asked for it.

> ## Automatic Returns
>
> In R, it is not necessary to include the return statement.
> R automatically returns whichever variable is on the last line of the body
> of the function. Since we are just learning, we will explicitly define the
> return statement.
{: .callout}

Let's try running our function.
Calling our own function is no different from calling any other function:


~~~
# freezing point of water
fahr_to_kelvin(32)
~~~
{: .r}



~~~
[1] 273.15
~~~
{: .output}



~~~
# boiling point of water
fahr_to_kelvin(212)
~~~
{: .r}



~~~
[1] 373.15
~~~
{: .output}

We've successfully called the function that we defined, and we have access to the value that we returned.

### Composing Functions

Now that we've seen how to turn Fahrenheit into Kelvin, it's easy to turn Kelvin into Celsius:


~~~
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

#absolute zero in Celsius
kelvin_to_celsius(0)
~~~
{: .r}



~~~
[1] -273.15
~~~
{: .output}

What about converting Fahrenheit to Celsius?
We could write out the formula, but we don't need to.
Instead, we can [compose]({{ page.root }}/reference/#function-composition) the two functions we have already created:


~~~
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}

This is our first taste of how larger programs are built: we define basic
operations, then combine them in ever-larger chunks to get the effect we want.
Real-life functions will usually be larger than the ones shown here--typically half a dozen to a few dozen lines--but they shouldn't ever be much longer than that, or the next person who reads it won't be able to understand what's going on.

> ## Chaining Functions
>
> This example showed the output of `fahr_to_kelvin` assigned to `temp_k`, which
> is then passed to `kelvin_to_celsius` to get the final result. It is also possible
> to perform this calculation in one line of code, by "chaining" functions
> together, like so:
>
> 
> ~~~
> # freezing point of water in Celsius
> kelvin_to_celsius(fahr_to_kelvin(32.0))
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] 0
> ~~~
> {: .output}
{: .callout}

> ## Create a Function
>
> In the last lesson, we learned to **c**oncatenate elements into a vector using the `c` function,
> e.g. `x <- c("A", "B", "C")` creates a vector `x` with three elements.
> Furthermore, we can extend that vector again using `c`, e.g. `y <- c(x, "D")` creates a vector `y` with four elements.
> Write a function called `fence` that takes two vectors as arguments, called
> original` and `wrapper`, and returns a new vector that has the wrapper vector
> at the beginning and end of the original:
>
> 
> ~~~
> best_practice <- c("Write", "programs", "for", "people", "not", "computers")
> asterisk <- "***"  # R interprets a variable with a single value as a vector
>                    # with one element.
> fence(best_practice, asterisk)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] "***"       "Write"     "programs"  "for"       "people"    "not"      
> [7] "computers" "***"      
> ~~~
> {: .output}
>
> > ## Solution
> > ~~~
> > fence <- function(original, wrapper) {
> >   answer <- c(wrapper, original, wrapper)
> >   return(answer)
> > }
> > ~~~
> > {: .r}
> {: .solution}
>
> If the variable `v` refers to a vector, then `v[1]` is the vector's first element and `v[length(v)]` is its last (the function `length` returns the number of elements in a vector).
> Write a function called `outside` that returns a vector made up of just the first and last elements of its input:
>
> 
> ~~~
> dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
> outside(dry_principle)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] "Don't"  "others"
> ~~~
> {: .output}
{: .challenge}

> ## The Call Stack
>
> For a deeper understanding of how functions work,
> you'll need to learn how they create their own environments and call other functions.
> Function calls are managed via the call stack.
> For more details on the call stack,
> have a look at the [supplementary material]({{ page.root }}/14-supp-call-stack/).
{: .callout}

> ## Named Variables and the Scope of Variables
>
>  + Functions can accept arguments explicitly assigned to a variable name in
>    in the function call `functionName(variable = value)`, as well as arguments by
>    order:
> 
> ~~~
> input_1 = 20
> mySum <- function(input_1, input_2 = 10) {
>   output <- input_1 + input_2
>   return(output)
> }
> ~~~
> {: .r}
>
> 1.  Given the above code was run, which value does `mySum(input_1 = 1, 3)` produce?
>     1. 4
>     2. 11
>     3. 23
>     4. 30
> 2.  If `mySum(3)` returns 13, why does `mySum(input_2 = 3)` return an error?
{: .challenge}

### Testing and Documenting

Once we start putting things in functions so that we can re-use them, we need to start testing that those functions are working correctly.
To see how to do this, let's write a function to center a dataset around a particular value:


~~~
center <- function(data, desired) {
  new_data <- (data - mean(data)) + desired
  return(new_data)
}
~~~
{: .r}

We could test this on our actual data, but since we don't know what the values ought to be, it will be hard to tell if the result was correct.
Instead, let's create a vector of 0s and then center that around 3.
This will make it simple to see if our function is working as expected:


~~~
z <- c(0, 0, 0, 0)
z
~~~
{: .r}



~~~
[1] 0 0 0 0
~~~
{: .output}



~~~
center(z, 3)
~~~
{: .r}



~~~
[1] 3 3 3 3
~~~
{: .output}

That looks right, so let's try center on our real data. We'll center the inflammation data from day 4 around 0:


~~~
dat <- read.csv(file = "data/inflammation-01.csv", header = FALSE)
centered <- center(dat[, 4], 0)
head(centered)
~~~
{: .r}



~~~
[1]  1.25 -0.75  1.25 -1.75  1.25  0.25
~~~
{: .output}

It's hard to tell from the default output whether the result is correct, but there are a few simple tests that will reassure us:


~~~
# original min
min(dat[, 4])
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}



~~~
# original mean
mean(dat[, 4])
~~~
{: .r}



~~~
[1] 1.75
~~~
{: .output}



~~~
# original max
max(dat[, 4])
~~~
{: .r}



~~~
[1] 3
~~~
{: .output}



~~~
# centered min
min(centered)
~~~
{: .r}



~~~
[1] -1.75
~~~
{: .output}



~~~
# centered mean
mean(centered)
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}



~~~
# centered max
max(centered)
~~~
{: .r}



~~~
[1] 1.25
~~~
{: .output}

That seems almost right: the original mean was about 1.75, so the lower bound from zero is now about -1.75.
The mean of the centered data is 0.
We can even go further and check that the standard deviation hasn't changed:


~~~
# original standard deviation
sd(dat[, 4])
~~~
{: .r}



~~~
[1] 1.067628
~~~
{: .output}



~~~
# centered standard deviation
sd(centered)
~~~
{: .r}



~~~
[1] 1.067628
~~~
{: .output}

Those values look the same, but we probably wouldn't notice if they were different in the sixth decimal place.
Let's do this instead:


~~~
# difference in standard deviations before and after
sd(dat[, 4]) - sd(centered)
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}

Sometimes, a very small difference can be detected due to rounding at very low decimal places.
R has a useful function for comparing two objects allowing for rounding errors, `all.equal`:


~~~
all.equal(sd(dat[, 4]), sd(centered))
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}

It's still possible that our function is wrong, but it seems unlikely enough that we should probably get back to doing our analysis.
We have one more task first, though: we should write some [documentation]({{ page.root }}/reference#documentation) for our function to remind ourselves later what it's for and how to use it.

A common way to put documentation in software is to add [comments]({{ page.root }}/reference/#comment) like this:


~~~
center <- function(data, desired) {
  # return a new vector containing the original data centered around the
  # desired value.
  # Example: center(c(1, 2, 3), 0) => c(-1, 0, 1)
  new_data <- (data - mean(data)) + desired
  return(new_data)
}
~~~
{: .r}

> ## Writing Documentation
>
> Formal documentation for R functions is written in separate `.Rd` using a
> markup language similar to [LaTeX][]. You see the result of this documentation
> when you look at the help file for a given function, e.g. `?read.csv`.
> The [roxygen2][] package allows R coders to write documentation alongside
> the function code and then process it into the appropriate `.Rd` files.
> You will want to switch to this more formal method of writing documentation
> when you start writing more complicated R projects.
{: .callout}

[LaTeX]: http://www.latex-project.org/
[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html





> ## Functions to Create Graphs
>
> Write a function called `analyze` that takes a filename as a argument
> and displays the three graphs produced in the [previous lesson][01] (average, min and max inflammation over time).
> `analyze("data/inflammation-01.csv")` should produce the graphs already shown,
> while `analyze("data/inflammation-02.csv")` should produce corresponding graphs for the second data set.
> Be sure to document your function with comments.
>
> > ## Solution
> > ~~~
> > analyze <- function(filename) {
> >   # Plots the average, min, and max inflammation over time.
> >   # Input is character string of a csv file.
> >   dat <- read.csv(file = filename, header = FALSE)
> >   avg_day_inflammation <- apply(dat, 2, mean)
> >   plot(avg_day_inflammation)
> >   max_day_inflammation <- apply(dat, 2, max)
> >   plot(max_day_inflammation)
> >   min_day_inflammation <- apply(dat, 2, min)
> >   plot(min_day_inflammation)
> > }
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

> ## Rescaling
>
> Write a function `rescale` that takes a vector as input and returns a corresponding vector of values scaled to lie in the range 0 to 1.
> (If $L$ and $H$ are the lowest and highest values in the original vector, then the replacement for a value $v$ should be $(v-L) / (H-L)$.)
> Be sure to document your function with comments.
>
> Test that your `rescale` function is working properly using `min`, `max`, and `plot`.
>
> > ## Solution
> > ~~~
> > rescale <- function(v) {
> >   # Rescales a vector, v, to lie in the range 0 to 1.
> >   L <- min(v)
> >   H <- max(v)
> >   result <- (v - L) / (H - L)
> >   return(result)
> > }
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

[01]: {{ page.root }}/01-starting-with-data/



### Defining Defaults

We have passed arguments to functions in two ways: directly, as in `dim(dat)`, and by name, as in `read.csv(file = "data/inflammation-01.csv", header = FALSE)`.
In fact, we can pass the arguments to `read.csv` without naming them:


~~~
dat <- read.csv("data/inflammation-01.csv", FALSE)
~~~
{: .r}

However, the position of the arguments matters if they are not named.


~~~
dat <- read.csv(header = FALSE, file = "data/inflammation-01.csv")
dat <- read.csv(FALSE, "data/inflammation-01.csv")
~~~
{: .r}



~~~
Error in read.table(file = file, header = header, sep = sep, quote = quote, : 'file' must be a character string or connection
~~~
{: .error}

To understand what's going on, and make our own functions easier to use, let's re-define our `center` function like this:


~~~
center <- function(data, desired = 0) {
  # return a new vector containing the original data centered around the
  # desired value (0 by default).
  # Example: center(c(1, 2, 3), 0) => c(-1, 0, 1)
  new_data <- (data - mean(data)) + desired
  return(new_data)
}
~~~
{: .r}

The key change is that the second argument is now written `desired = 0` instead of just `desired`.
If we call the function with two arguments, it works as it did before:


~~~
test_data <- c(0, 0, 0, 0)
center(test_data, 3)
~~~
{: .r}



~~~
[1] 3 3 3 3
~~~
{: .output}

But we can also now call `center()` with just one argument, in which case `desired` is automatically assigned the default value of `0`:


~~~
more_data <- 5 + test_data
more_data
~~~
{: .r}



~~~
[1] 5 5 5 5
~~~
{: .output}



~~~
center(more_data)
~~~
{: .r}



~~~
[1] 0 0 0 0
~~~
{: .output}

This is handy: if we usually want a function to work one way, but occasionally need it to do something else, we can allow people to pass an argument when they need to but provide a default to make the normal case easier.

The example below shows how R matches values to arguments


~~~
display <- function(a = 1, b = 2, c = 3) {
  result <- c(a, b, c)
  names(result) <- c("a", "b", "c")  # This names each element of the vector
  return(result)
}

# no arguments
display()
~~~
{: .r}



~~~
a b c 
1 2 3 
~~~
{: .output}



~~~
# one argument
display(55)
~~~
{: .r}



~~~
 a  b  c 
55  2  3 
~~~
{: .output}



~~~
# two arguments
display(55, 66)
~~~
{: .r}



~~~
 a  b  c 
55 66  3 
~~~
{: .output}



~~~
# three arguments
display (55, 66, 77)
~~~
{: .r}



~~~
 a  b  c 
55 66 77 
~~~
{: .output}

As this example shows, arguments are matched from left to right, and any that haven't been given a value explicitly get their default value.
We can override this behavior by naming the value as we pass it in:


~~~
# only setting the value of c
display(c = 77)
~~~
{: .r}



~~~
 a  b  c 
 1  2 77 
~~~
{: .output}

> ## Matching Arguments
>
> To be precise, R has three ways that arguments are supplied
> by you are matched to the *formal arguments* of the function definition:
>
> 1. by complete name,
> 2. by partial name (matching on initial *n* characters of the argument name), and
> 3. by position.
>
> Arguments are matched in the manner outlined above in *that order*: by
> complete name, then by partial matching of names, and finally by position.
{: .callout}

With that in hand, let's look at the help for `read.csv()`:


~~~
?read.csv
~~~
{: .r}

There's a lot of information there, but the most important part is the first couple of lines:


~~~
read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)
~~~
{: .r}

This tells us that `read.csv()` has one argument, `file`, that doesn't have a default value, and six others that do.
Now we understand why the following gives an error:


~~~
dat <- read.csv(FALSE, "data/inflammation-01.csv")
~~~
{: .r}



~~~
Error in read.table(file = file, header = header, sep = sep, quote = quote, : 'file' must be a character string or connection
~~~
{: .error}

It fails because `FALSE` is assigned to `file` and the filename is assigned to the argument `header`.

> ## A Function with Default Argument Values
>
> Rewrite the `rescale` function so that it scales a vector to lie between 0 and 1 by default, but will allow the caller to specify lower and upper bounds if they want.
> Compare your implementation to your neighbor's: do the two functions always behave the same way?
>
> > ## Solution
> > ~~~
> > rescale <- function(v, lower = 0, upper = 1) {
> >   # Rescales a vector, v, to lie in the range lower to upper.
> >   L <- min(v)
> >   H <- max(v)
> >   result <- (v - L) / (H - L) * (upper - lower) + lower
> >   return(result)
> > }
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}


