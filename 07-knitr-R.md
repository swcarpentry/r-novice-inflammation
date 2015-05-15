---
layout: page
title: Programming with R
subtitle: Dynamic reports with knitr
minutes: 30
---



> ## Learning Objectives {.objectives}
>
> * To discover `knitr` and the generation of dynamic reports

`Knitr` is an R package that makes your code neat, pretty, and shows your notes, code, and output simultaneously in an `html` document. You create these documents in `.Rmd` files. You can write in `LateX` or `md`. 

knitr extracts R code in the input document (.Rmd), evaluates it and writes the results to the output document (html). There are two types of R code: chunks (code as separate paragraphs) and inline R code.


~~~{.r}
install.packages("knitr")
~~~

~~~{.r}
library(knitr)
~~~

Restart RStudio. 
Open a new `Rmd` file. 

In Rmd, anything between lines that start and end with triple quotes ``` will be run as R code.


~~~{.r}
summary(cars)
~~~



~~~{.output}
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  

~~~

> ## Challenge - Using KnitR to produce a report {.challenge}
>
> 1. Open an new .Rmd script and save it as inflammation_report.Rmd
> 2. Copy and paste the code as embedded R chunks to read in the data and plot average inflammation, or the heat map that we created.
> 3. Add a few notes describing what the code does and what the main findings are.
> 4. `KNIT` and view the html
