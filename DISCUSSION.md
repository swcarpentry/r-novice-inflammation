---
layout: page
title: Programming with R
subtitle: Discussion
---

## Error returned when attempting to calculate mean of data.frame rows

As of R version 3.0.0 one cannot use functions such as `mean()`, `max()`,
`min()`, etc., on `data.frame` rows. For instructors, this can be a problem
when going through material in the [Creating functions](02-func-R.html) lesson,
**Testing and Documenting** section, if one attempts to apply any of these 
functions to the example dataset rows (e.g., `center( dat[ 4, ], 0 )`. The
examples in the lesson are all written to work only with columns, but 
instructors who live-code an example using rows will have to address
this issue.