---
title: "Data Types and Structures"
teaching: 45
exercises: 0
questions:
- "What are the different data types in R?"
- "What are the different data structures in R?"
- "How do I access data within the various data structures?"
objectives:
- "Expose learners to the different data types in R."
- "Learn how to create vectors of different types."
- "Be able to check the type of vector."
- "Learn about missing data and other special values."
- "Getting familiar with the different data structures (lists, matrices, data frames)."
keypoints:
- "R's basic data types are character, numeric, integer, complex, and logical."
- "R's basic data structures include the vector, list, matrix, data frame, and factors."
- "Objects may have attributes, such as name, dimension, and class."
---



### Understanding Basic Data Types in R

To make the best of the R language, you'll need a strong understanding of the
basic data types and data structures and how to operate on those.

Very important to understand because these are the objects you will manipulate
on a day-to-day basis in R. Dealing with object conversions is one of the most
common sources of frustration for beginners.

**Everything** in R is an object.

R has 6 (although we will not discuss the raw class for this workshop) atomic
vector types.

* character
* numeric (real or decimal)
* integer
* logical
* complex

By *atomic*, we mean the vector only holds data of a single type.

* **character**: `"a"`, `"swc"`
* **numeric**: `2`, `15.5`
* **integer**: `2L` (the `L` tells R to store this as an integer)
* **logical**: `TRUE`, `FALSE`
* **complex**: `1+4i` (complex numbers with real and imaginary parts)

R provides many functions to examine features of vectors and other objects, for
example

* `class()` - what kind of object is it (high-level)?
* `typeof()` - what is the object's data type (low-level)?
* `length()` - how long is it? What about two dimensional objects?
* `attributes()` - does it have any metadata?


~~~
# Example
x <- "dataset"
typeof(x)
~~~
{: .r}



~~~
[1] "character"
~~~
{: .output}



~~~
attributes(x)
~~~
{: .r}



~~~
NULL
~~~
{: .output}



~~~
y <- 1:10
y
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
typeof(y)
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
length(y)
~~~
{: .r}



~~~
[1] 10
~~~
{: .output}



~~~
z <- as.numeric(y)
z
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
typeof(z)
~~~
{: .r}



~~~
[1] "double"
~~~
{: .output}

R has many __data structures__. These include

* atomic vector
* list
* matrix
* data frame
* factors

### Atomic Vectors

A vector is the most common and basic data structure in R and is pretty much the
workhorse of R. Technically, vectors can be one of two types:

* atomic vectors
* lists

although the term "vector" most commonly refers to the atomic types not to lists.

### The Different Vector Modes

A vector is a collection of elements that are most commonly of mode `character`,
`logical`, `integer` or `numeric`.

You can create an empty vector with `vector()`. (By default the mode is
`logical`. You can be more explicit as shown in the examples below.) It is more
common to use direct constructors such as `character()`, `numeric()`, etc.


~~~
vector() # an empty 'logical' (the default) vector
~~~
{: .r}



~~~
logical(0)
~~~
{: .output}



~~~
vector("character", length = 5) # a vector of mode 'character' with 5 elements
~~~
{: .r}



~~~
[1] "" "" "" "" ""
~~~
{: .output}



~~~
character(5) # the same thing, but using the constructor directly
~~~
{: .r}



~~~
[1] "" "" "" "" ""
~~~
{: .output}



~~~
numeric(5)   # a numeric vector with 5 elements
~~~
{: .r}



~~~
[1] 0 0 0 0 0
~~~
{: .output}



~~~
logical(5)   # a logical vector with 5 elements
~~~
{: .r}



~~~
[1] FALSE FALSE FALSE FALSE FALSE
~~~
{: .output}

You can also create vectors by directly specifying their content. R will then
guess the appropriate mode of storage for the vector. For instance:


~~~
x <- c(1, 2, 3)
~~~
{: .r}

will create a vector `x` of mode `numeric`. These are the most common kind, and
are treated as double precision real numbers. If you wanted to explicitly create
integers, you need to add an `L` to each element (or *coerce* to the integer
type using `as.integer()`).


~~~
x1 <- c(1L, 2L, 3L)
~~~
{: .r}

Using `TRUE` and `FALSE` will create a vector of mode `logical`:


~~~
y <- c(TRUE, TRUE, FALSE, FALSE)
~~~
{: .r}

While using quoted text will create a vector of mode `character`:


~~~
z <- c("Sarah", "Tracy", "Jon")
~~~
{: .r}

### Examining Vectors

The functions `typeof()`, `length()`, `class()` and `str()` provide useful
information about your vectors and R objects in general.


~~~
typeof(z)
~~~
{: .r}



~~~
[1] "character"
~~~
{: .output}



~~~
length(z)
~~~
{: .r}



~~~
[1] 3
~~~
{: .output}



~~~
class(z)
~~~
{: .r}



~~~
[1] "character"
~~~
{: .output}



~~~
str(z)
~~~
{: .r}



~~~
 chr [1:3] "Sarah" "Tracy" "Jon"
~~~
{: .output}

> ## Finding Commonalities
>
> Do you see a property that's common to all these vectors above?
{: .challenge}

### Adding Elements

The function `c()` (for combine) can also be used to add elements to a vector.


~~~
z <- c(z, "Annette")
z
~~~
{: .r}



~~~
[1] "Sarah"   "Tracy"   "Jon"     "Annette"
~~~
{: .output}



~~~
z <- c("Greg", z)
z
~~~
{: .r}



~~~
[1] "Greg"    "Sarah"   "Tracy"   "Jon"     "Annette"
~~~
{: .output}

### Vectors from a Sequence of Numbers

You can create vectors as a sequence of numbers.


~~~
series <- 1:10
seq(10)
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
seq(from = 1, to = 10, by = 0.1)
~~~
{: .r}



~~~
 [1]  1.0  1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9  2.0  2.1  2.2  2.3
[15]  2.4  2.5  2.6  2.7  2.8  2.9  3.0  3.1  3.2  3.3  3.4  3.5  3.6  3.7
[29]  3.8  3.9  4.0  4.1  4.2  4.3  4.4  4.5  4.6  4.7  4.8  4.9  5.0  5.1
[43]  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9  6.0  6.1  6.2  6.3  6.4  6.5
[57]  6.6  6.7  6.8  6.9  7.0  7.1  7.2  7.3  7.4  7.5  7.6  7.7  7.8  7.9
[71]  8.0  8.1  8.2  8.3  8.4  8.5  8.6  8.7  8.8  8.9  9.0  9.1  9.2  9.3
[85]  9.4  9.5  9.6  9.7  9.8  9.9 10.0
~~~
{: .output}

### Missing Data

R supports missing data in vectors. They are represented as `NA` (Not Available)
and can be used for all the vector types covered in this lesson:


~~~
x <- c(0.5, NA, 0.7)
x <- c(TRUE, FALSE, NA)
x <- c("a", NA, "c", "d", "e")
x <- c(1+5i, 2-3i, NA)
~~~
{: .r}

The function `is.na()` indicates the elements of the vectors that represent
missing data, and the function `anyNA()` returns `TRUE` if the vector contains
any missing values:


~~~
x <- c("a", NA, "c", "d", NA)
y <- c("a", "b", "c", "d", "e")
is.na(x)
~~~
{: .r}



~~~
[1] FALSE  TRUE FALSE FALSE  TRUE
~~~
{: .output}



~~~
is.na(y)
~~~
{: .r}



~~~
[1] FALSE FALSE FALSE FALSE FALSE
~~~
{: .output}



~~~
anyNA(x)
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}



~~~
anyNA(y)
~~~
{: .r}



~~~
[1] FALSE
~~~
{: .output}

### Other Special Values

`Inf` is infinity. You can have either positive or negative infinity.


~~~
1/0
~~~
{: .r}



~~~
[1] Inf
~~~
{: .output}

`NaN` means Not a Number. It's an undefined value.


~~~
0/0
~~~
{: .r}



~~~
[1] NaN
~~~
{: .output}

### What Happens When You Mix Types Inside a Vector?

R will create a resulting vector with a mode that can most easily accommodate
all the elements it contains. This conversion between modes of storage is called
"coercion". When R converts the mode of storage based on its content, it is
referred to as "implicit coercion". For instance, can you guess what the
following do (without running them first)?


~~~
xx <- c(1.7, "a")
xx <- c(TRUE, 2)
xx <- c("a", TRUE)
~~~
{: .r}

You can also control how vectors are coerced explicitly using the
`as.<class_name>()` functions:


~~~
as.numeric("1")
~~~
{: .r}



~~~
[1] 1
~~~
{: .output}



~~~
as.character(1:2)
~~~
{: .r}



~~~
[1] "1" "2"
~~~
{: .output}

### Objects Attributes

Objects can have __attributes__. Attributes are part of the object. These include:

* names
* dimnames
* dim
* class
* attributes (contain metadata)

You can also glean other attribute-like information such as length (works on
vectors and lists) or number of characters (for character strings).


~~~
length(1:10)
~~~
{: .r}



~~~
[1] 10
~~~
{: .output}



~~~
nchar("Software Carpentry")
~~~
{: .r}



~~~
[1] 18
~~~
{: .output}

### Matrix

In R matrices are an extension of the numeric or character vectors. They are not
a separate type of object but simply an atomic vector with dimensions; the
number of rows and columns.


~~~
m <- matrix(nrow = 2, ncol = 2)
m
~~~
{: .r}



~~~
     [,1] [,2]
[1,]   NA   NA
[2,]   NA   NA
~~~
{: .output}



~~~
dim(m)
~~~
{: .r}



~~~
[1] 2 2
~~~
{: .output}

Matrices in R are filled column-wise.


~~~
m <- matrix(1:6, nrow = 2, ncol = 3)
~~~
{: .r}

Other ways to construct a matrix


~~~
m      <- 1:10
dim(m) <- c(2, 5)
~~~
{: .r}

This takes a vector and transforms it into a matrix with 2 rows and 5 columns.

Another way is to bind columns or rows using `cbind()` and `rbind()`.


~~~
x <- 1:3
y <- 10:12
cbind(x, y)
~~~
{: .r}



~~~
     x  y
[1,] 1 10
[2,] 2 11
[3,] 3 12
~~~
{: .output}



~~~
rbind(x, y)
~~~
{: .r}



~~~
  [,1] [,2] [,3]
x    1    2    3
y   10   11   12
~~~
{: .output}

You can also use the `byrow` argument to specify how the matrix is filled. From R's own documentation:


~~~
mdat <- matrix(c(1,2,3, 11,12,13), nrow = 2, ncol = 3, byrow = TRUE)
mdat
~~~
{: .r}



~~~
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]   11   12   13
~~~
{: .output}

### List

In R lists act as containers. Unlike atomic vectors, the contents of a list are
not restricted to a single mode and can encompass any mixture of data
types. Lists are sometimes called generic vectors, because the elements of a
list can by of any type of R object, even lists containing further lists. This
property makes them fundamentally different from atomic vectors.

A list is a special type of vector. Each element can be a different type.

Create lists using `list()` or coerce other objects using `as.list()`. An empty
list of the required length can be created using `vector()`


~~~
x <- list(1, "a", TRUE, 1+4i)
x
~~~
{: .r}



~~~
[[1]]
[1] 1

[[2]]
[1] "a"

[[3]]
[1] TRUE

[[4]]
[1] 1+4i
~~~
{: .output}



~~~
x <- vector("list", length = 5) ## empty list
length(x)
~~~
{: .r}



~~~
[1] 5
~~~
{: .output}



~~~
x[[1]]
~~~
{: .r}



~~~
NULL
~~~
{: .output}



~~~
x <- 1:10
x <- as.list(x)
length(x)
~~~
{: .r}



~~~
[1] 10
~~~
{: .output}

1. What is the class of `x[1]`?
2. What about `x[[1]]`?


~~~
xlist <- list(a = "Karthik Ram", b = 1:10, data = head(iris))
xlist
~~~
{: .r}



~~~
$a
[1] "Karthik Ram"

$b
 [1]  1  2  3  4  5  6  7  8  9 10

$data
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
~~~
{: .output}

1. What is the length of this object? What about its structure?

Lists can be extremely useful inside functions. You can “staple” together lots
of different kinds of results into a single object that a function can return.

A list does not print to the console like a vector. Instead, each element of the
list starts on a new line.

Elements are indexed by double brackets. Single brackets will still return
a(nother) list.


### Data Frame

A data frame is a very important data type in R. It's pretty much the *de facto*
data structure for most tabular data and what we use for statistics.

A data frame is a special type of list where every element of the list has same length.

Data frames can have additional attributes such as `rownames()`, which can be
useful for annotating data, like `subject_id` or `sample_id`. But most of the
time they are not used.

Some additional information on data frames:

* Usually created by `read.csv()` and `read.table()`.
* Can convert to matrix with `data.matrix()` (preferred) or `as.matrix()`
* Coercion will be forced and not always what you expect.
* Can also create with `data.frame()` function.
* Find the number of rows and columns with `nrow(dat)` and `ncol(dat)`, respectively.
* Rownames are usually 1, 2, ..., n.

### Creating Data Frames by Hand

To create data frames by hand:


~~~
dat <- data.frame(id = letters[1:10], x = 1:10, y = 11:20)
dat
~~~
{: .r}



~~~
   id  x  y
1   a  1 11
2   b  2 12
3   c  3 13
4   d  4 14
5   e  5 15
6   f  6 16
7   g  7 17
8   h  8 18
9   i  9 19
10  j 10 20
~~~
{: .output}

> ## Useful Data Frame Functions
>
> * `head()` - shown first 6 rows
> * `tail()` - show last 6 rows
> * `dim()` - returns the dimensions
> * `nrow()` - number of rows
> * `ncol()` - number of columns
> * `str()` - structure of each column
> * `names()` - shows the `names` attribute for a data frame, which gives the column names.
{: .callout}

See that it is actually a special list:


~~~
is.list(iris)
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}



~~~
class(iris)
~~~
{: .r}



~~~
[1] "data.frame"
~~~
{: .output}

| Dimensions | Homogenous | Heterogeneous |
| ------- | ---- | ---- |
| 1-D | atomic vector | list |
| 2-D | matrix | data frame |


> ## Column Types in Data Frames
>
> Knowing that data frames are lists of lists, can columns be of different type?
>
> What type of structure do you expect on the iris data frame? Hint: Use `str()`.
>
> ~~~
> # The Sepal.Length, Sepal.Width, Petal.Length and Petal.Width columns are all
> # numeric types, while Species is a Factor.
> # Lists can have elements of different types.
> # Since a Data Frame is just a special type of list, it can have columns of
> # differing type (although, remember that type must be consistent within each column!).
> str(iris)
> ~~~
> {: .r}
{: .challenge}
