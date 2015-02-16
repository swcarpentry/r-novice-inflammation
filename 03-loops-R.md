---
layout: page
title: Programming with R
subtitle: Analyzing multiple data sets
minutes: 30
---



> ## Objectives {.objectives}
> 
> * Explain what a `for` loop does.
> * Correctly write `for` loops to repeat simple calculations.
> * Trace changes to a loop variable as the loop runs.
> * Trace changes to other variables as they are updated by a `for` loop.
> * Use a function to get a list of filenames that match a simple pattern.
> * Use a `for` loop to process multiple files.

We have created a function called `analyze` that creates graphs of the minimum, average, and maximum daily inflammation rates for a single data set:


~~~{.r}
analyze <- function(filename) {
  # Plots the average, min, and max aneurism count over time.
  # Input is character string of a csv file.
  dat <- read.csv(file = filename, header = TRUE)
  plot(x=dat$Group,y=dat$Aneurisms_q1)
  plot(x=dat$Group,y=dat$Aneurisms_q2)
  plot(x=dat$Group,y=dat$Aneurisms_q3)
  plot(x=dat$Group,y=dat$Aneurisms_q4)
}
analyze("data/Site-01.csv")
~~~

<img src="fig/03-loops-R-Site-01-1.png" title="plot of chunk Site-01" alt="plot of chunk Site-01" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-01-2.png" title="plot of chunk Site-01" alt="plot of chunk Site-01" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-01-3.png" title="plot of chunk Site-01" alt="plot of chunk Site-01" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-01-4.png" title="plot of chunk Site-01" alt="plot of chunk Site-01" style="display: block; margin: auto;" />

We can use it to analyze other data sets one by one:


~~~{.r}
analyze("data/Site-02.csv")
~~~

<img src="fig/03-loops-R-Site-02-1.png" title="plot of chunk Site-02" alt="plot of chunk Site-02" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-02-2.png" title="plot of chunk Site-02" alt="plot of chunk Site-02" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-02-3.png" title="plot of chunk Site-02" alt="plot of chunk Site-02" style="display: block; margin: auto;" /><img src="fig/03-loops-R-Site-02-4.png" title="plot of chunk Site-02" alt="plot of chunk Site-02" style="display: block; margin: auto;" />

but we have a dozen data sets right now and more on the way.
We want to create plots for all our data sets with a single statement.
To do that, we'll have to teach the computer how to repeat things.

### For Loops

Suppose we want to print each word in a sentence.
One way is to use six `print` statements:


~~~{.r}
best_practice <- c("Let", "the", "computer", "do", "the", "work")
print_words <- function(sentence) {
  print(sentence[1])
  print(sentence[2])
  print(sentence[3])
  print(sentence[4])
  print(sentence[5])
  print(sentence[6])
}

print_words(best_practice)
~~~



~~~{.output}
[1] "Let"
[1] "the"
[1] "computer"
[1] "do"
[1] "the"
[1] "work"

~~~

but that's a bad approach for two reasons:

 1. It doesn't scale: if we want to print the elements in a vector that's hundreds long, we'd be better off just typing them in.

 2. It's fragile: if we give it a longer vector, it only prints part of the data, and if we give it a shorter input, it returns `NA` values because we're asking for elements that don't exist!


~~~{.r}
best_practice[-6]
~~~



~~~{.output}
[1] "Let"      "the"      "computer" "do"       "the"     

~~~



~~~{.r}
print_words(best_practice[-6])
~~~



~~~{.output}
[1] "Let"
[1] "the"
[1] "computer"
[1] "do"
[1] "the"
[1] NA

~~~

> ## Tip {.callout} 
>
> R has has a special variable, `NA`, for designating missing values that are 
> **N**ot **A**vailable in a data set. See `?NA` and [An Introduction to R][na] 
> for more details.

[na]: http://cran.r-project.org/doc/manuals/r-release/R-intro.html#Missing-values

Here's a better approach:


~~~{.r}
print_words <- function(sentence) {
  for (word in sentence) {
    print(word)
  }
}

print_words(best_practice)
~~~



~~~{.output}
[1] "Let"
[1] "the"
[1] "computer"
[1] "do"
[1] "the"
[1] "work"

~~~

This is shorter---certainly shorter than something that prints every character in a hundred-letter string---and more robust as well:


~~~{.r}
print_words(best_practice[-6])
~~~



~~~{.output}
[1] "Let"
[1] "the"
[1] "computer"
[1] "do"
[1] "the"

~~~

The improved version of `print_words` uses a [for loop](reference.html#for-loop) to repeat an operation---in this case, printing---once for each thing in a collection.
The general form of a loop is:


~~~{.r}
for (variable in collection) {
  do things with variable
}
~~~

We can name the [loop variable](reference.html#loop-variable) anything we like (with a few [restrictions][], e.g. the name of the variable cannot start with a digit).
`in` is part of the `for` syntax.
Note that the body of the loop is enclosed in curly braces `{ }`.
For a single-line loop body, as here, the braces aren't needed, but it is good practice to include them as we did.

[restrictions]: http://cran.r-project.org/doc/manuals/R-intro.html#R-commands_003b-case-sensitivity-etc

Here's another loop that repeatedly updates a variable:


~~~{.r}
len <- 0
vowels <- c("a", "e", "i", "o", "u")
for (v in vowels) {
  len <- len + 1
}
# Number of vowels
len
~~~



~~~{.output}
[1] 5

~~~

It's worth tracing the execution of this little program step by step.
Since there are five elements in the vector `vowels`, the statement inside the loop will be executed five times.
The first time around, `len` is zero (the value assigned to it on line 1) and `v` is `"a"`.
The statement adds 1 to the old value of `len`, producing 1, and updates `len` to refer to that new value.
The next time around, `v` is `"e"` and `len` is 1, so `len` is updated to be 2.
After three more updates, `len` is 5; since there is nothing left in the vector `vowels` for R to process, the loop finishes.

Note that a loop variable is just a variable that's being used to record progress in a loop.
It still exists after the loop is over, and we can re-use variables previously defined as loop variables as well:


~~~{.r}
letter <- "z"
for (letter in c("a", "b", "c")) {
  print(letter)
}
~~~



~~~{.output}
[1] "a"
[1] "b"
[1] "c"

~~~



~~~{.r}
# after the loop, letter is
letter
~~~



~~~{.output}
[1] "c"

~~~

Note also that finding the length of a vector is such a common operation that R actually has a built-in function to do it called `length`:


~~~{.r}
length(vowels)
~~~



~~~{.output}
[1] 5

~~~

`length` is much faster than any R function we could write ourselves, and much easier to read than a two-line loop; it will also give us the length of many other things that we haven't met yet, so we should always use it when we can (see this [lesson](00-first-timers.html) to learn more about the different ways to store data in R).

> ## Challenges {.challenge}
>
> 1. R has a built-in function called `seq` that creates a list of numbers:


~~~{.r}
seq(3)
~~~



~~~{.output}
[1] 1 2 3

~~~

> Using `seq`, write a function that prints the first **N** natural numbers, one per line:




~~~{.r}
print_N(3)
~~~



~~~{.output}
[1] 1
[1] 2
[1] 3

~~~

> 2. Exponentiation is built into R:


~~~{.r}
2^4
~~~



~~~{.output}
[1] 16

~~~

> Write a function called `expo` that uses a loop to calculate the same result.




~~~{.r}
expo(2, 4)
~~~



~~~{.output}
[1] 16

~~~

> 3. Write a function called `total` that calculates the sum of the values in a vector.
> (R has a built-in function called `sum` that does this for you.
> Please don't use it for this exercise.)




~~~{.r}
ex_vec <- c(4, 8, 15, 16, 23, 42)
total(ex_vec)
~~~



~~~{.output}
[1] 108

~~~

### Processing Multiple Files

We now have almost everything we need to process all our data files. 
The only thing that's missing is a function that finds files whose names match a pattern.
We do not need to write it ourselves because R already has a function to do this called `list.files`.

If we run the function without any arguments, `list.files()`, it returns every file in the current working directory.
We can understand this result by reading the help file (`?list.files`).
The first argument, `path`, is the path to the directory to be searched, and it has the default value of `"."` (recall from the [lesson](../shell/01-filedir.html) on the Unix Shell that `"."` is shorthand for the current working directory).
The second argument, `pattern`, is the pattern being searched, and it has the default value of `NULL`.
Since no pattern is specified to filter the files, all files are returned.

So to list all the csv files, we could run either of the following:


~~~{.r}
list.files(path = "data", pattern = "csv")
~~~



~~~{.output}
 [1] "car-speeds-cleaned.csv" "car-speeds.csv"        
 [3] "inflammation-01.csv"    "inflammation-02.csv"   
 [5] "inflammation-03.csv"    "inflammation-04.csv"   
 [7] "inflammation-05.csv"    "inflammation-06.csv"   
 [9] "inflammation-07.csv"    "inflammation-08.csv"   
[11] "inflammation-09.csv"    "inflammation-10.csv"   
[13] "inflammation-11.csv"    "inflammation-12.csv"   
[15] "sample-01.csv"          "sample-02.csv"         
[17] "sample-03.csv"          "sample-04.csv"         
[19] "sample-05.csv"          "Site-01.csv"           
[21] "Site-02.csv"            "Site-03.csv"           
[23] "Site-04.csv"            "Site-05.csv"           
[25] "small-01.csv"           "small-02.csv"          
[27] "small-03.csv"          

~~~



~~~{.r}
list.files(path = "data", pattern = "Site")
~~~



~~~{.output}
[1] "Site-01.csv" "Site-02.csv" "Site-03.csv" "Site-04.csv" "Site-05.csv"

~~~


> ## Tip {.callout} 
>
> For larger projects, it is recommended to organize separate parts of the 
> analysis into multiple subdirectories, e.g. one subdirectory for the raw data, 
> one for the code, and one for the results like figures. We have done that here 
> to some extent, putting all of our data files into the subdirectory "data".
> For more advice on this topic, you can read [A quick guide to organizing 
> computational biology projects][Noble2009] by William Stafford Noble.

[Noble2009]: http://www.ploscompbiol.org/article/info%3Adoi%2F10.1371%2Fjournal.pcbi.1000424


As these examples show, `list.files` result is a vector of strings, which means we can loop over it to do something with each filename in turn.
In our case, the "something" we want is our `analyze` function.

Because we have put our data in separate subdirectory, if we want to access these files
using the output of `list.files` we also need to include the "path" portion of the file name.
We can do that by using the argument `full.names = TRUE`.


~~~{.r}
list.files(path = "data", pattern = "csv", full.names = TRUE)
~~~



~~~{.output}
 [1] "data/car-speeds-cleaned.csv" "data/car-speeds.csv"        
 [3] "data/inflammation-01.csv"    "data/inflammation-02.csv"   
 [5] "data/inflammation-03.csv"    "data/inflammation-04.csv"   
 [7] "data/inflammation-05.csv"    "data/inflammation-06.csv"   
 [9] "data/inflammation-07.csv"    "data/inflammation-08.csv"   
[11] "data/inflammation-09.csv"    "data/inflammation-10.csv"   
[13] "data/inflammation-11.csv"    "data/inflammation-12.csv"   
[15] "data/sample-01.csv"          "data/sample-02.csv"         
[17] "data/sample-03.csv"          "data/sample-04.csv"         
[19] "data/sample-05.csv"          "data/Site-01.csv"           
[21] "data/Site-02.csv"            "data/Site-03.csv"           
[23] "data/Site-04.csv"            "data/Site-05.csv"           
[25] "data/small-01.csv"           "data/small-02.csv"          
[27] "data/small-03.csv"          

~~~



~~~{.r}
list.files(path = "data", pattern = "Site", full.names = TRUE)
~~~



~~~{.output}
[1] "data/Site-01.csv" "data/Site-02.csv" "data/Site-03.csv"
[4] "data/Site-04.csv" "data/Site-05.csv"

~~~


Let's test out running our `analyze` function by using it on the first three files in the vector returned by `list.files`:



~~~{.r}
filenames <- list.files(path = "data", pattern = "Site", full.names = TRUE)
filenames <- filenames[1:3]
for (f in filenames) {
  print(f)
  analyze(f)
}
~~~



~~~{.output}
[1] "data/Site-01.csv"

~~~

<img src="fig/03-loops-R-loop-analyze-1.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-2.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-3.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-4.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" />

~~~{.output}
[1] "data/Site-02.csv"

~~~

<img src="fig/03-loops-R-loop-analyze-5.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-6.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-7.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-8.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" />

~~~{.output}
[1] "data/Site-03.csv"

~~~

<img src="fig/03-loops-R-loop-analyze-9.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-10.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-11.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" /><img src="fig/03-loops-R-loop-analyze-12.png" title="plot of chunk loop-analyze" alt="plot of chunk loop-analyze" style="display: block; margin: auto;" />

Sure enough, the maxima of these data sets show exactly the same ramp as the first, and their minima show the same staircase structure.

> ## Tip {.callout} 
>
> In this lesson we saw how to use a simple `for` loop to repeat an operation.
> As you progress with R, you will learn that there are multiple ways to 
> accomplish this. Sometimes the choice of one method over another is more a 
> matter of personal style, but other times it can have consequences for the 
> speed of your code. For instruction on best practices, see this supplementary 
> [lesson](03-supp-loops-in-depth.html) that demonstrates how to properly repeat 
> operations in R.

> ## Challenges {.challenge}
>
> 1. Write a function called `analyze_all` that takes a filename pattern as its sole argument and runs `analyze` for each file whose name matches the pattern.



<div class="keypoints" markdown="1">
#### Key Points

* Use `for (variable in collection)` to process the elements of a collection one at a time.
* The body of a `for` loop is surrounded by curly braces (`{ }`).
* Use `length(thing)` to determine the length of something that contains other values.
* Use `list.files(pattern = "pattern")` to create a list of files whose names match a pattern.
</div>

#### Next Steps

We have now solved our original problem: we can analyze any number of data files with a single command.
More importantly, we have met two of the most important ideas in programming:

* Use functions to make code easier to re-use and easier to understand.
* Use vectors and data frames to store related values, and loops to repeat operations on them.

We have one more big idea to introduce...
