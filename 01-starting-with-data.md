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
> * Understand Factors

We are studying micro-aneurisms in the eyes of people with diabetes,
100 patients have been sampled anually. 
The data sets are stored in [comma-separated values](../../gloss.html#comma-separeted-values) (CSV) format: each row holds information for a single patient, and the columns represent different observations. 
The first few rows of our first file look like this:


~~~{.output}
ID,Gender,Group,BloodPressure,Age,Aneurisms_q1,Aneurisms_q2,Aneurisms_q3,Aneurisms_q4
Sub001,m,Control,132,16,114,140,202,237
Sub002,m,Treatment2,139,17.2,148,209,248,248
Sub003,m,Treatment2,130,19.5,196,251,122,177
Sub004,f,Treatment1,105,15.7,199,140,233,220
Sub005,m,Treatment1,125,19.9,188,120,222,228

~~~

We want to:

* load that data into memory,
* calculate the average number of aneurisms per eye across all patients, and
* plot the result.

To do all that, we'll have to learn a little bit about programming.

### Loading Data

To load our inflammation data, first we need to locate our data.
We can change the current working directory to the location of the CSV files using the function `setwd`.
For example, if the CSV files are located in a directory named `swc` in our home directory, we would change the working directory using the following command:


~~~{.r}
setwd("~/swc/")
~~~

Just like in the Unix Shell, we type the command and then press `Enter` (or `return`).
Alternatively you can change the working directory using the RStudio GUI using the menu option `Session` -> `Set Working Directory` -> `Choose Directory...`

Now we could load the data into R using `read.csv`:


~~~{.r}
read.csv(file = "data/Site-01.csv", header = TRUE)
~~~

The expression `read.csv(...)` is a [function call](reference.html#function-call) that asks R to run the function `read.csv`. 

`read.csv` has two [arguments](../../gloss.html#argument): the name of the file we want to read, and whether the first line of the file contains names for the columns of data.
The filename needs to be a character string (or [string](../../gloss.html#string) for short), so we put it in quotes.
Assigning the second argument, `header`, to be `TRUE` indicates that the data file does have column headers.
We'll talk more about the value `TRUE`, and its converse `FALSE`, in lesson 04.

> ## Tip {.callout} 
> 
> `read.csv` actually has many more arguments that you may find useful when 
> importing your own data in the future. You can learn more about these 
> options in this supplementary [lesson](01-supp-read-write-csv.html).

The utility of a function is that it will perform its given action on whatever value is passed to the named argument(s).
For example, in this case if we provided the name of a different file to the argument `file`, `read.csv` would read it instead.
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
> document our code in this way so that others (and us the next time we 
> read it) have an easier time following what the code is doing.

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
# ...and in weight pounds still
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
dat <- read.csv(file = "data/Site-01.csv", header = TRUE)
~~~

This statement doesn't produce any output because assignment doesn't display anything.
If we want to check that our data has been loaded, we can print the variable's value.
However, for large data sets it is convenient to use the function `head` to display only the first few rows of data.


~~~{.r}
head(dat)
~~~



~~~{.output}
      ID Gender      Group BloodPressure  Age Aneurisms_q1 Aneurisms_q2
1 Sub001      m    Control           132 16.0          114          140
2 Sub002      m Treatment2           139 17.2          148          209
3 Sub003      m Treatment2           130 19.5          196          251
4 Sub004      f Treatment1           105 15.7          199          140
5 Sub005      m Treatment1           125 19.9          188          120
6 Sub006      M Treatment2           112 14.3          260          266
  Aneurisms_q3 Aneurisms_q4
1          202          237
2          248          248
3          122          177
4          233          220
5          222          228
6          320          294

~~~

> ## Challenge {.challenge}
>
> Draw diagrams showing what variables refer to what values after each statement in the following program:
>
~~~{.r}
mass <- 47.5
age <- 122
mass <- mass * 2.0
age <- age - 20
~~~

### Examining the data structure

Now that our data is in memory, we can start doing things with it. 
First, let's ask what type of thing `dat` *is*:


~~~{.r}
class(dat)
~~~



~~~{.output}
[1] "data.frame"

~~~

The output tells us that data currently is a data frame in R. 
This is similar to a spreadsheet in MS Excel that many of us are familiar with using.
Data frames are very useful for storing data because you can have a continuous variable, e.g. rainfall, in one column and a categorical variable, e.g. month, in another.

### Column types

A data frame is made up of columns of data. The columns do not have to have the same type.

We can use the `class()` function to examine a single column.


~~~{.r}
class(dat[,1])
~~~



~~~{.output}
[1] "factor"

~~~
The type `factor` is a very useful column type in R.

The function `str()` gives information about all the columns in a dataframe.


~~~{.r}
str(dat)
~~~



~~~{.output}
'data.frame':	100 obs. of  9 variables:
 $ ID           : Factor w/ 100 levels "Sub001","Sub002",..: 1 2 3 4 5 6 7 8 9 10 ...
 $ Gender       : Factor w/ 4 levels "F","f","M","m": 4 4 4 2 4 3 2 4 4 2 ...
 $ Group        : Factor w/ 3 levels "Control","Treatment1",..: 1 3 3 2 2 3 1 3 3 1 ...
 $ BloodPressure: int  132 139 130 105 125 112 173 108 131 129 ...
 $ Age          : num  16 17.2 19.5 15.7 19.9 14.3 17.7 19.8 19.4 18.8 ...
 $ Aneurisms_q1 : int  114 148 196 199 188 260 135 216 117 188 ...
 $ Aneurisms_q2 : int  140 209 251 140 120 266 98 238 215 144 ...
 $ Aneurisms_q3 : int  202 248 122 233 222 320 154 279 181 192 ...
 $ Aneurisms_q4 : int  237 248 177 220 228 294 245 251 272 185 ...

~~~

We see the first two columns (ID and Gender) are type factor. Factors are a very useful datatype in R and we will look at them in detail next. The Group column is a logical datatype (values are True or False). 5 columns (BloodPressure, Aneurisms_q1-4) are all type integer. One column is type num (Age).

### Addressing data
There are 3 main ways to address data in a data frame:
* By Index
* By Logical vector
* By Name (columns only)

#### By Index
We can see the dimensions, or [shape](../../gloss.html#shape), of the data frame like this:


~~~{.r}
dim(dat)
~~~



~~~{.output}
[1] 100   9

~~~

This tells us that our data frame, `dat`, has 100 rows and 9 columns.

If we want to get a single value from the data frame, we can provide an [index](reference.html#index) in square brackets, just as we do in math:


~~~{.r}
# first value in dat
dat[1, 1]
~~~



~~~{.output}
[1] Sub001
100 Levels: Sub001 Sub002 Sub003 Sub004 Sub005 Sub006 Sub007 ... Sub100

~~~



~~~{.r}
# middle value in dat
dat[30, 4]
~~~



~~~{.output}
[1] 108

~~~

An index like `[30, 4]` selects a single element of a data frame, but we can select whole sections as well. 
For example, we can select the first ten patients (rows) of values for the first four observations (columns) like this:


~~~{.r}
dat[1:10, 1:4]
~~~



~~~{.output}
       ID Gender      Group BloodPressure
1  Sub001      m    Control           132
2  Sub002      m Treatment2           139
3  Sub003      m Treatment2           130
4  Sub004      f Treatment1           105
5  Sub005      m Treatment1           125
6  Sub006      M Treatment2           112
7  Sub007      f    Control           173
8  Sub008      m Treatment2           108
9  Sub009      m Treatment2           131
10 Sub010      f    Control           129

~~~

The [slice](reference.html#slice) `1:4` means, "Start at index 1 and go to index 4."

The slice does not need to start at 1, e.g. the line below selects rows 5 through 10:


~~~{.r}
dat[5:10, 1:4]
~~~



~~~{.output}
       ID Gender      Group BloodPressure
5  Sub005      m Treatment1           125
6  Sub006      M Treatment2           112
7  Sub007      f    Control           173
8  Sub008      m Treatment2           108
9  Sub009      m Treatment2           131
10 Sub010      f    Control           129

~~~
We can use the function `c`, which stands for **c**ombine, to select non-contiguous values:


~~~{.r}
dat[c(3, 8, 37, 56), c(1, 3, 6)]
~~~



~~~{.output}
       ID      Group Aneurisms_q1
3  Sub003 Treatment2          196
8  Sub008 Treatment2          216
37 Sub037 Treatment2          161
56 Sub056 Treatment2          199

~~~

We also don't have to provide a slice for either the rows or the columns.
If we don't include a slice for the rows, R returns all the rows; if we don't include a slice for the columns, R returns all the columns.
If we don't provide a slice for either rows or columns, e.g. `dat[, ]`, R returns the full data frame.


~~~{.r}
# All columns from row 5
dat[5, ]
~~~



~~~{.output}
      ID Gender      Group BloodPressure  Age Aneurisms_q1 Aneurisms_q2
5 Sub005      m Treatment1           125 19.9          188          120
  Aneurisms_q3 Aneurisms_q4
5          222          228

~~~



~~~{.r}
# All rows from column 4
dat[, 4]
~~~



~~~{.output}
  [1] 132 139 130 105 125 112 173 108 131 129 126  96  77 158  81 137 147
 [18] 130 105  92 111 122  97 118  82 123 126  94 135 108 133 108 122 134
 [35] 145 133  90 118 113 115 142 114 139  90 126 109 125  99 122 111 109
 [52] 134 113 105 125 123 155 117 116 133  94 106 144 149 108 116 136  98
 [69] 148  74 147 116 133  97 132 153 151 121 116 104 111  62 124 124 109
 [86] 117  90 158 113 150 115  83 116 141 108 102  90 133  83 122

~~~

#### Logical adressing

We have seen how to address data structures using an index. Logical addressing is another useful approach.


~~~{.r}
x <- c(5,3,7,10,15,13,17)

x[c(TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE)]
~~~



~~~{.output}
[1] 5 3 7

~~~

Logical vectors can be created using `Relational Operators` e.g. `< , > ,  == , !=`.

~~~{.r}
x > 10
~~~



~~~{.output}
[1] FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE

~~~

#### By Name
Columns in a dataframe can be named. In our case these names came from the header row of the csv file. Column names can be listed with the `names()` command.


~~~{.r}
names(dat)
~~~



~~~{.output}
[1] "ID"            "Gender"        "Group"         "BloodPressure"
[5] "Age"           "Aneurisms_q1"  "Aneurisms_q2"  "Aneurisms_q3" 
[9] "Aneurisms_q4" 

~~~

Columns can be addressed using the `$` operator


~~~{.r}
dat$Gender
~~~



~~~{.output}
  [1] m m m f m M f m m f m f f m m m f m m F f m f f m M M f m f f m m m m
 [36] f f m M m f m m m f f M M m m m f f f m f m m m f f f f M f m f f M m
 [71] m m F m m f M M M f m M M m m f f f m m f m F f m m F m M M
Levels: F f M m

~~~


#### Challenge

A subsection of a data frame is called a [slice](../../gloss.html#slice).
We can take slices of character vectors as well:


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

1.  If the first four characters are selected using the slice `element[1:4]`, how can we obtain the first four characters in reverse order?
    
2.  What is `element[-1]`?
    What is `element[-4]`?
    Given those answers,
    explain what `element[-1:-4]` does.

Index addressing and Logical addressing can be combined. 

3. Using Index addressing for the columns and Logical addressing for the rows, select all the rows with lower case "m" for gender.


~~~{.r}
#Create an index vector for the lower case "m"
index<-dat$Gender=="m"
head(dat[index,]) #N.B, using head function to limit output
~~~



~~~{.output}
      ID Gender      Group BloodPressure  Age Aneurisms_q1 Aneurisms_q2
1 Sub001      m    Control           132 16.0          114          140
2 Sub002      m Treatment2           139 17.2          148          209
3 Sub003      m Treatment2           130 19.5          196          251
5 Sub005      m Treatment1           125 19.9          188          120
8 Sub008      m Treatment2           108 19.8          216          238
9 Sub009      m Treatment2           131 19.4          117          215
  Aneurisms_q3 Aneurisms_q4
1          202          237
2          248          248
3          122          177
5          222          228
8          279          251
9          181          272

~~~

### Combining indexing and assignment

We have seen how we slice data using indexing and how we can assign values to variables using the assignment operator.
We can combine these two operations:


~~~{.r}
x <- c(5,3,7,10,15,13,17)
x[x>10] <- 0

x
~~~



~~~{.output}
[1]  5  3  7 10  0  0  0

~~~

### Challenge

1. Combine indexing and assigment to correct the Gender column so that all values are uppercase


~~~{.r}
index_m<-dat$Gender=='m'
index_f<-dat$Gender=='f'

dat[index_m,2]<-'M'
dat[index_f,2]<-'F'
~~~


### Factors

This section is taken from the datacarpentry lessons git@github.com:datacarpentry/datacarpentry.git



Factors are used to represent categorical data. Factors can be ordered or
unordered and are an important class for statistical analysis and for plotting.

Factors are stored as integers, and have labels associated with these unique
integers. While factors look (and often behave) like character vectors, they are
actually integers under the hood, and you need to be careful when treating them
like strings.

Once created, factors can only contain a pre-defined set values, known as
*levels*. By default, R always sorts *levels* in alphabetical order. For
instance, if you have a factor with 2 levels:


~~~{.r}
sex <- factor(c("male", "female", "female", "male"))
~~~

R will assign `1` to the level `"female"` and `2` to the level `"male"` (because
`f` comes before `m`, even though the first element in this vector is
`"male"`). You can check this by using the function `levels()`, and check the
number of levels using `nlevels()`:


~~~{.r}
levels(sex)
~~~



~~~{.output}
[1] "female" "male"  

~~~



~~~{.r}
nlevels(sex)
~~~



~~~{.output}
[1] 2

~~~

Sometimes, the order of the factors does not matter, other times you might want
to specify the order because it is meaningful (e.g., "low", "medium", "high") or
it is required by particular type of analysis. Additionally, specifying the
order of the levels allows to compare levels:


~~~{.r}
food <- factor(c("low", "high", "medium", "high", "low", "medium", "high"))
levels(food)
~~~



~~~{.output}
[1] "high"   "low"    "medium"

~~~



~~~{.r}
food <- factor(food, levels=c("low", "medium", "high"))
levels(food)
~~~



~~~{.output}
[1] "low"    "medium" "high"  

~~~



~~~{.r}
min(food) ## doesn't work
~~~



~~~{.output}
Error in Summary.factor(structure(c(1L, 3L, 2L, 3L, 1L, 2L, 3L), .Label = c("low", : 'min' not meaningful for factors

~~~



~~~{.r}
food <- factor(food, levels=c("low", "medium", "high"), ordered=TRUE)
levels(food)
~~~



~~~{.output}
[1] "low"    "medium" "high"  

~~~



~~~{.r}
min(food) ## works!
~~~



~~~{.output}
[1] low
Levels: low < medium < high

~~~

In R's memory, these factors are represented by numbers (1, 2, 3). They are
better than using simple integer labels because factors are self describing:
`"low"`, `"medium"`, and `"high"`" is more descriptive than `1`, `2`, `3`. Which
is low?  You wouldn't be able to tell with just integer data. Factors have this
information built in. It is particularly helpful when there are many levels
(like the subjects in our example data set).

### Converting factors

If you need to convert a factor to a character vector, simply use
`as.character(x)`.

Converting a factor to a numeric vector is however a little trickier, and you
have to go via a character vector. Compare:


~~~{.r}
f <- factor(c(1, 5, 10, 2))
as.numeric(f)               ## wrong! and there is no warning...
~~~



~~~{.output}
[1] 1 3 4 2

~~~



~~~{.r}
as.numeric(as.character(f)) ## works...
~~~



~~~{.output}
[1]  1  5 10  2

~~~



~~~{.r}
as.numeric(levels(f))[f]    ## The recommended way.
~~~



~~~{.output}
[1]  1  5 10  2

~~~

### Challenge

The function `table()` tabulates observations and can be used to create
bar plots quickly. For instance:


~~~{.r}
## Question: How can you recreate this plot but by having "control"
## being listed last instead of first?
exprmt <- factor(c("treat1", "treat2", "treat1", "treat3", "treat1", "control",
                   "treat1", "treat2", "treat3"))
table(exprmt)
~~~



~~~{.output}
exprmt
control  treat1  treat2  treat3 
      1       4       2       2 

~~~



~~~{.r}
barplot(table(exprmt))
~~~

<img src="fig/01-starting-with-data-unnamed-chunk-35-1.png" title="plot of chunk unnamed-chunk-35" alt="plot of chunk unnamed-chunk-35" style="display: block; margin: auto;" />

<!---

~~~{.r}
exprmt <- factor(exprmt, levels=c("treat1", "treat2", "treat3", "control"))
barplot(table(exprmt))
~~~

<img src="fig/01-starting-with-data-unnamed-chunk-36-1.png" title="plot of chunk unnamed-chunk-36" alt="plot of chunk unnamed-chunk-36" style="display: block; margin: auto;" />
--->

### Removing levels from a factor

In the previous challenge we updated the data for Gender. R still thinks the levels "m" and "f" are valid for the Gender data.

~~~{.r}
levels(dat$Gender)
~~~



~~~{.output}
[1] "F" "f" "M" "m"

~~~

The `droplevels` function will remove any unused levels

~~~{.r}
dat<-droplevels(dat)
levels(dat$Gender)
~~~



~~~{.output}
[1] "F" "M"

~~~

### Manipulating Data

Now let's perform some common mathematical operations to learn about our inflammation data.
When analyzing data we often want to look at partial statistics, such as the maximum value per patient or the average value per eye. 
One way to do this is to select the data we want to create a new temporary data frame, and then perform the calculation on this subset:


~~~{.r}
# first row, columns 6 to 9
patient_1 <- dat[1, 6:9]
# max aneurism for patient 1
max(patient_1)
~~~



~~~{.output}
[1] 237

~~~

We don't actually need to store the row in a variable of its own. 
Instead, we can combine the selection and the function call:


~~~{.r}
# max inflammation for patient 2
max(dat[2, 6:9])
~~~



~~~{.output}
[1] 248

~~~

R also has functions for other commons calculations, e.g. finding the minimum, mean, median, and standard deviation of the data:


~~~{.r}
# minimum number of aneurisms in quadrant 1
min(dat[, 6])
~~~



~~~{.output}
[1] 65

~~~



~~~{.r}
# mean number of aneurisms in quadrant 1
mean(dat[,6])
~~~



~~~{.output}
[1] 158.84

~~~



~~~{.r}
# median number of aneurisms in quadrant 1
median(dat[, 6])
~~~



~~~{.output}
[1] 158

~~~



~~~{.r}
# standard number of aneurisms in quadrant 1
sd(dat[, 6])
~~~



~~~{.output}
[1] 41.52952

~~~

What if we need the maximum aneurisms for all patients, or the average for each eye?
As the diagram below shows, we want to perform the operation across a margin of the data frame:

<img src="fig/r-operations-across-axes.svg" alt="Operations Across Axes" />

To support this, we can use the `apply` function.

> **Tip:** To learn about a function in R, e.g. `apply`, we can read its help documention by running `help(apply)` or `?apply`.

`apply` allows us to repeat a function on all of the rows (`MARGIN = 1`) or columns (`MARGIN = 2`) of a data frame.

Thus, to obtain the average inflammation of each patient we will need to calculate the mean of all of the rows (`MARGIN = 1`) of the data frame.


~~~{.r}
avg_patient_aneurisms <- apply(dat[,6:9], 1, mean)
~~~

And to obtain the average inflammation of each eye we will need to calculate the mean of all of the columns (`MARGIN = 2`) of the data frame.


~~~{.r}
avg_eye_aneurisms <- apply(dat[,6:9], 2, mean)
~~~

Since the second argument to `apply` is `MARGIN`, the above command is equivalent to `apply(dat, MARGIN = 2, mean)`.
We'll learn why this is so in the next lesson.

> **Tip:** Some common operations have more efficient alternatives.
For example, you can calculate the row-wise or column-wise means with `rowMeans` and `colMeans`, respectively.


#### Key Points

* Use `variable <- value` to assign a value to a variable in order to record it in memory.
* Objects are created on demand whenever a value is assigned to them.
* The function `dim` gives the dimensions of a data frame.
* Use `object[x, y]` to select a single element from a data frame.
* Use `from:to` to specify a sequence that includes the indices from `from` to `to`.
* All the indexing and slicing that works on data frames also works on vectors.
* Use `#` to add comments to programs.
* Use `mean`, `max`, `min` and `sd` to calculate simple statistics.
* Use `apply` to calculate statistics across the rows or columns of a data frame.


#### Next Steps

Our work so far has looked at the data from the first site, we have 4 samples from other locations.
We would like to check the others the same way, but typing in the same commands repeatedly is tedious and error-prone.
Since computers don't get bored (that we know of), we should create a way to do a complete analysis with a single command, and then figure out how to repeat that step once for each file.
These operations are the subjects of the next two lessons.
