---
layout: page
title: Programming with R
subtitle: Analyzing patient data
minutes: 30
---



> ## Objectives {.objectives}
> * Read tabular data from a file into a program.
> * Assign values to variables.
> * Select individual values and subsections from data.
> * Perform operations on a data frame of data.
> * Display simple graphs.

We are studying inflammation in patients undergoing a new treatment for arthritis,
and need to analyze the first dozen data sets. 
The data sets are stored in [comma-separated values](reference.html#comma-separated-values-(csv)) (CSV) format: each row holds information for a single patient, and the columns represent successive days. 
The first few rows of our first file look like this:


~~~{.output}
0,0,1,3,1,2,4,7,8,3,3,3,10,5,7,4,7,7,12,18,6,13,11,11,7,7,4,6,8,8,4,4,5,7,3,4,2,3,0,0
0,1,2,1,2,1,3,2,2,6,10,11,5,9,4,4,7,16,8,6,18,4,12,5,12,7,11,5,11,3,3,5,4,4,5,5,1,1,0,1
0,1,1,3,3,2,6,2,5,9,5,7,4,5,4,15,5,11,9,10,19,14,12,17,7,12,11,7,4,2,10,5,4,2,2,3,2,2,1,1
0,0,2,0,4,2,2,1,6,7,10,7,9,13,8,8,15,10,10,7,17,4,4,7,6,15,6,4,9,11,3,5,6,3,3,4,2,3,2,1
0,1,1,3,3,1,3,5,2,4,4,7,6,5,3,10,8,10,6,17,9,14,9,7,13,9,12,6,7,7,9,6,3,2,2,4,2,0,1,1

~~~

We want to:

* load data into memory,
* calculate the average inflammation per day across all patients, and
* plot the result.

To do all that, we'll have to learn a little bit about programming.

### Loading Data

To load our inflammation data, first we need to locate our data.
We can change the current working directory to the location of the CSV files using the function `setwd`.
For example, if the CSV files are located in a directory named `swc` in our home directory, we would change the working directory using the following command:


~~~{.r}
setwd("~/swc")
~~~

Just like in the Unix Shell, we type the command and then press `Enter` (or `return`).
Alternatively you can change the working directory using the RStudio GUI using the menu option `Session` -> `Set Working Directory` -> `Choose Directory...`

Now we could load the data into R using `read.csv`:


~~~{.r}
read.csv(file = "data/inflammation-01.csv", header = FALSE)
~~~

The expression `read.csv(...)` is a [function call](reference.html#function-call) asking R to run the function `read.csv`. 

`read.csv` has two [arguments](reference.html#argument): the name of the file we want to read, and whether the first line of the file contains names for the columns of data (a header row).
The filename needs to be a character string (or [string](reference.html#string) for short), so we put it in quotes.
Assigning the second argument, `header`, to be `FALSE` indicates that the data file does not have column headers.
We'll talk more about the value `FALSE`, and its converse `TRUE`, in [lesson 04](https://swcarpentry.github.io/r-novice-inflammation/04-cond.html).

> ## Tip {.callout} 
> 
> `read.csv` actually has many additional arguments you may find useful when 
> importing your own data in the future. You can learn more about these 
> options in this supplementary [lesson](01-supp-read-write-csv.html).

The utility of a function is it will perform its given action on whatever value is passed to the named argument(s).
For example, in this case if we provided the name of a different file to the argument `file`, `read.csv` would read the new file instead.
We'll learn more of the details about functions and their arguments in the next lesson.

Since we didn't tell it to do anything else with the function's output, the console will display the full contents of the file `inflammation-01.csv`.
Try it out.

`read.csv` read the file, but didn't save the data in memory.
To do that, we need to assign the data frame to a variable.
A variable is just a name for a value, such as `x`, `current_temperature`, or `subject_id`.
We can create a new variable simply by assigning a value to it using `<-`


~~~{.r}
weight_kg <- 55
~~~

Once a variable has a value, we can print it by typing the name of the variable and hitting `Enter` (or `return`).
In general, R will print to the console any object returned by a function or operation *unless* we assign it to a variable.


~~~{.r}
weight_kg
~~~



~~~{.output}
[1] 55

~~~

We can do arithmetic with the variable:


~~~{.r}
# weight in pounds:
2.2 * weight_kg
~~~



~~~{.output}
[1] 121

~~~

> ## Tip {.callout}
>
> We can add comments to our code using the `#` character. It is useful to 
> document our code in this way so others (and us the next time we 
> read it) have an easier time following what the code does.

We can also change an object's value by assigning it a new value:


~~~{.r}
weight_kg <- 57.5
# weight in kilograms is now
weight_kg
~~~



~~~{.output}
[1] 57.5

~~~

If we imagine the variable as a sticky note with a name written on it, 
assignment is like putting the sticky note on a particular value:

<img src="fig/python-sticky-note-variables-01.svg" alt="Variables as Sticky Notes" />

This means that assigning a value to one object does not change the values of other variables. 
For example, let's store the subject's weight in pounds in a variable:


~~~{.r}
weight_lb <- 2.2 * weight_kg
# weight in kg...
weight_kg
~~~



~~~{.output}
[1] 57.5

~~~



~~~{.r}
# ...and in pounds
weight_lb
~~~



~~~{.output}
[1] 126.5

~~~

<img src="fig/python-sticky-note-variables-02.svg" alt="Creating Another Variable" />

and then change `weight_kg`:


~~~{.r}
weight_kg <- 100.0
# weight in kg now...
weight_kg
~~~



~~~{.output}
[1] 100

~~~



~~~{.r}
# ...and weight in pounds still
weight_lb
~~~



~~~{.output}
[1] 126.5

~~~

<img src="fig/python-sticky-note-variables-03.svg" alt="Updating a Variable" />

Since `weight_lb` doesn't "remember" where its value came from, it isn't automatically updated when `weight_kg` changes. 
This is different from the way spreadsheets work.

Now that we know how to assign things to variables, let's re-run `read.csv` and save its result:


~~~{.r}
dat <- read.csv(file = "data/inflammation-01.csv", header = FALSE)
~~~

This statement does not produce any output because assignment does not display anything.
If we want to check and see if our data has been loaded, we can print the variable's value.
However, for large data sets it is convenient to use the function `head` to display only the first few rows of data.


~~~{.r}
head(dat)
~~~



~~~{.output}
  V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20
1  0  0  1  3  1  2  4  7  8   3   3   3  10   5   7   4   7   7  12  18
2  0  1  2  1  2  1  3  2  2   6  10  11   5   9   4   4   7  16   8   6
3  0  1  1  3  3  2  6  2  5   9   5   7   4   5   4  15   5  11   9  10
4  0  0  2  0  4  2  2  1  6   7  10   7   9  13   8   8  15  10  10   7
5  0  1  1  3  3  1  3  5  2   4   4   7   6   5   3  10   8  10   6  17
6  0  0  1  2  2  4  2  1  6   4   7   6   6   9   9  15   4  16  18  12
  V21 V22 V23 V24 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V38
1   6  13  11  11   7   7   4   6   8   8   4   4   5   7   3   4   2   3
2  18   4  12   5  12   7  11   5  11   3   3   5   4   4   5   5   1   1
3  19  14  12  17   7  12  11   7   4   2  10   5   4   2   2   3   2   2
4  17   4   4   7   6  15   6   4   9  11   3   5   6   3   3   4   2   3
5   9  14   9   7  13   9  12   6   7   7   9   6   3   2   2   4   2   0
6  12   5  18   9   5   3  10   3  12   7   8   4   7   3   5   4   4   3
  V39 V40
1   0   0
2   0   1
3   1   1
4   2   1
5   1   1
6   2   1

~~~

> ## Challenge - Assigning values to variables {.challenge}
>
> Draw diagrams showing what variables refer to what values after each statement in the following program:
>
~~~{.r}
mass <- 47.5
age <- 122
mass <- mass * 2.0
age <- age - 20
~~~

### Manipulating Data

Now our data is in memory and we can start doing things with it. 
First, let's ask what type of thing `dat` *is*:


~~~{.r}
class(dat)
~~~



~~~{.output}
[1] "data.frame"

~~~

The output tells us our data (dat) is currently a data frame in R. 
This is similar to the spreadsheets in Microsoft Excel many of us are familiar with using.
Data frames are very useful for storing data because you can have a continuous variable, e.g. rainfall, in one column and a categorical variable, e.g. month, in another.

We can see the dimensions, or [shape](reference.html#shape-(of-an-array)), of the data frame like this:


~~~{.r}
dim(dat)
~~~



~~~{.output}
[1] 60 40

~~~

This tells us our data frame, `dat`, has 60 rows and 40 columns.

If we want to get a single value from the data frame, we can provide an [index](reference.html#index) in square brackets, just as we do in math:


~~~{.r}
# first value in dat
dat[1, 1]
~~~



~~~{.output}
[1] 0

~~~



~~~{.r}
# middle value in dat
dat[30, 20]
~~~



~~~{.output}
[1] 16

~~~

An index like `[30, 20]` selects a single element of a data frame, but we can select whole sections as well. 
For example, we can select the first ten days (columns) of values for the first four patients (rows) like this:


~~~{.r}
dat[1:4, 1:10]
~~~



~~~{.output}
  V1 V2 V3 V4 V5 V6 V7 V8 V9 V10
1  0  0  1  3  1  2  4  7  8   3
2  0  1  2  1  2  1  3  2  2   6
3  0  1  1  3  3  2  6  2  5   9
4  0  0  2  0  4  2  2  1  6   7

~~~

The [slice](reference.html#slice) `1:4` means, "Start at index 1 and go to index 4."

The slice does not need to start at 1, e.g. the line below selects rows 5 through 10:


~~~{.r}
dat[5:10, 1:10]
~~~



~~~{.output}
   V1 V2 V3 V4 V5 V6 V7 V8 V9 V10
5   0  1  1  3  3  1  3  5  2   4
6   0  0  1  2  2  4  2  1  6   4
7   0  0  2  2  4  2  2  5  5   8
8   0  0  1  2  3  1  2  3  5   3
9   0  0  0  3  1  5  6  5  5   8
10  0  1  1  2  1  3  5  3  5   8

~~~
We can use the function `c`, which stands for **c**ombine, to select non-contiguous values:


~~~{.r}
dat[c(3, 8, 37, 56), c(10, 14, 29)]
~~~



~~~{.output}
   V10 V14 V29
3    9   5   4
8    3   5   6
37   6   9  10
56   7  11   9

~~~

We also do not have to provide a slice for either the rows or the columns.
If we do not include a slice for the rows, R returns all the rows; if we do not include a slice for the columns, R returns all the columns.
If we do not provide a slice for either rows or columns, e.g. `dat[ , ]`, R returns the full data frame.


~~~{.r}
# All columns from row 5
dat[5, ]
~~~



~~~{.output}
  V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20
5  0  1  1  3  3  1  3  5  2   4   4   7   6   5   3  10   8  10   6  17
  V21 V22 V23 V24 V25 V26 V27 V28 V29 V30 V31 V32 V33 V34 V35 V36 V37 V38
5   9  14   9   7  13   9  12   6   7   7   9   6   3   2   2   4   2   0
  V39 V40
5   1   1

~~~



~~~{.r}
# All rows from column 16
dat[ , 16]
~~~



~~~{.output}
 [1]  4  4 15  8 10 15 13  9 11  6  3  8 12  3  5 10 11  4 11 13 15  5 14
[24] 13  4  9 13  6  7  6 14  3 15  4 15 11  7 10 15  6  5  6 15 11 15  6
[47] 11 15 14  4 10 15 11  6 13  8  4 13 12  9

~~~

Now let's perform some common mathematical operations to learn about our inflammation data.
When analyzing data we often want to look at partial statistics, such as the maximum value per patient or the average value per day. 
One way to do this is to select the data we want, create a new temporary data frame, and perform the calculation on the subset:


~~~{.r}
# first row, all of the columns
patient_1 <- dat[1, ]
# max inflammation for patient 1
max(patient_1)
~~~



~~~{.output}
[1] 18

~~~

We do not actually need to store the row in a variable of its own. 
Instead, we can combine the selection and the function call:


~~~{.r}
# max inflammation for patient 2
max(dat[2, ])
~~~



~~~{.output}
[1] 18

~~~

R also has functions for other commons calculations, e.g. finding the minimum, mean, median, and standard deviation of the data:


~~~{.r}
# minimum inflammation on day 7
min(dat[, 7])
~~~



~~~{.output}
[1] 1

~~~



~~~{.r}
# mean inflammation on day 7
mean(dat[, 7])
~~~



~~~{.output}
[1] 3.8

~~~



~~~{.r}
# median inflammation on day 7
median(dat[, 7])
~~~



~~~{.output}
[1] 4

~~~



~~~{.r}
# standard deviation of inflammation on day 7
sd(dat[, 7])
~~~



~~~{.output}
[1] 1.725187

~~~

What if we need the maximum inflammation for all patients, or the average for each day?
As the diagram below shows, we want to perform the operation across a margin of the data frame:

<img src="fig/r-operations-across-axes.svg" alt="Operations Across Axes" />

To support this, we can use the `apply` function.

> ## Tip {.callout} 
>
> To learn about a function in R, e.g. `apply`, we can read its help 
> documention by running `help(apply)` or `?apply`.

`apply` allows us to repeat a function on all of the rows (`MARGIN = 1`) or columns (`MARGIN = 2`) of a data frame.

Thus, to obtain the average inflammation of each patient we will need to calculate the mean of all of the rows (`MARGIN = 1`) of the data frame.


~~~{.r}
avg_patient_inflammation <- apply(dat, 1, mean)
~~~

To obtain the average inflammation of each day we need to calculate the mean of all of the columns (`MARGIN = 2`) of the data frame.


~~~{.r}
avg_day_inflammation <- apply(dat, 2, mean)
~~~

Since the second argument to `apply` is `MARGIN`, the above command is equivalent to `apply(dat, MARGIN = 2, mean)`.
We will learn why this is so in the next lesson.

> ## Tip {.callout}
>
> Some common operations have more efficient alternatives. For example, you 
> can calculate the row-wise or column-wise means with `rowMeans` and 
> `colMeans`, respectively.

> ## Challenge - Slicing (subsetting) data {.challenge}
>
> A subsection of a data frame is called a [slice](reference.html#slice).
> We can take slices of character vectors as well:
>

~~~{.r}
element <- c("o", "x", "y", "g", "e", "n")
# first three characters
element[1:3]
~~~



~~~{.output}
[1] "o" "x" "y"

~~~



~~~{.r}
# last three characters
element[4:6]
~~~



~~~{.output}
[1] "g" "e" "n"

~~~
>
> 1.  If the first four characters are selected using the slice `element[1:4]`, how can we obtain the first four characters in reverse order?
>    
> 1.  What is `element[-1]`?
>    What is `element[-4]`?
>    Given those answers,
>    explain what `element[-1:-4]` does.
>
> 1.  Use a slice of `element` to create a new character vector that spells the word "eon", e.g. `c("e", "o", "n")`.


> ## Challenge - Subsetting data 2 {.challenge}
>
> Suppose you want to determine the maximum inflamation for patient 5 across days three to seven.
> To do this you would extract the relevant slice from the data frame and calculate the maximum value.  
> Which of the following lines of R code gives the correct answer?
>
> (a) `max(dat[5, ])`
> (b) `max(dat[3:7, 5])`
> (c) `max(dat[5, 3:7])`
> (d) `max(dat[5, 3, 7])`

### Plotting

The mathematician Richard Hamming once said, "The purpose of computing is insight, not numbers," and the best way to develop insight is often to visualize data.
Visualization deserves an entire lecture (or course) of its own, but we can explore a few of R's plotting features. 

Let's take a look at the average inflammation over time.
Recall we already calculated these values above using `apply(dat, 2, mean)` and saved them in the variable `avg_day_inflammation`.
Plotting the values is done with the function `plot`.


~~~{.r}
plot(avg_day_inflammation)
~~~

<img src="fig/01-starting-with-data-plot-avg-inflammation-1.png" title="plot of chunk plot-avg-inflammation" alt="plot of chunk plot-avg-inflammation" style="display: block; margin: auto;" />

Above, we gave the function `plot` a vector of numbers corresponding to the average inflammation per day across all patients.
`plot` created a scatter plot where the y-axis is the average inflammation level and the x-axis is the order, or index, of the values in the vector, which in this case correspond to the 40 days of treatment.
The result is roughly a linear rise and fall, which is suspicious: based on other studies, we expect a sharper rise and slower fall.
Let's have a look at two other statistics: the maximum and minimum inflammation per day.


~~~{.r}
max_day_inflammation <- apply(dat, 2, max)
plot(max_day_inflammation)
~~~

<img src="fig/01-starting-with-data-plot-max-inflammation-1.png" title="plot of chunk plot-max-inflammation" alt="plot of chunk plot-max-inflammation" style="display: block; margin: auto;" />


~~~{.r}
min_day_inflammation <- apply(dat, 2, min)
plot(min_day_inflammation)
~~~

<img src="fig/01-starting-with-data-plot-min-inflammation-1.png" title="plot of chunk plot-min-inflammation" alt="plot of chunk plot-min-inflammation" style="display: block; margin: auto;" />

The maximum value rises and falls perfectly smoothly, while the minimum seems to be a step function. Neither result seems particularly likely, so either there's a mistake in our calculations or something is wrong with our data.

> ## Challenge - Plotting data {.challenge}
>
> Create a plot showing the standard deviation of the inflammation data for each day across all patients.

#### Key Points

* 
* Use `variable <- value` to assign a value to a variable in order to record it in memory.
* Objects are created on demand whenever a value is assigned to them.
* The function `dim` gives the dimensions of a data frame.
* Use `object[x, y]` to select a single element from a data frame.
* Use `from:to` to specify a sequence that includes the indices from `from` to `to`.
* All the indexing and slicing that works on data frames also works on vectors.
* Use `#` to add comments to programs.
* Use `mean`, `max`, `min` and `sd` to calculate simple statistics.
* Use `apply` to calculate statistics across the rows or columns of a data frame.
* Use `plot` to create simple visualizations.

#### Next Steps

Our work so far has convinced us that something's wrong with our first data file.
We would like to check the other 11 the same way, but typing in the same commands repeatedly is tedious and error-prone.
Since computers don't get bored (that we know of), we should create a way to do a complete analysis with a single command, and then figure out how to repeat that step once for each file.
These operations are the subjects of the next two lessons.
