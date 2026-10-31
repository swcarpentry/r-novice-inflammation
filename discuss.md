---
title: Discussion
---

## Error returned when attempting to calculate mean of data.frame rows

As of R version 3.0.0 one cannot use functions such as `mean()`, `max()`,
`min()`, etc., on `data.frame` rows. This can be a problem
when going through material in the [Creating functions](../episodes/02-func-R.Rmd) lesson,
**Testing and Documenting** section, if one attempts to apply any of these
functions to the example dataset rows (e.g., `center(dat[4, ], 0)`. The
examples in the lesson are all written to work only with columns, but
an error is returned if one tries using rows. This may also be a problem
if one attempts to calculate row means or medians in the
[Analyzing patient data](../episodes/01-starting-with-data.Rmd) lesson,
**Manipulating Data** section.
The **recommended solution** to this issue is to not apply these functions
to `data.frame` rows. However, one *could* get around this issue by
using the functions `rowSums` or `rowMeans` in some cases, or
explicitly converting the row to a vector of numeric values
(e.g., `center(as.numeric(dat[4, ]), 0)`)


