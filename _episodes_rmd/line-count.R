main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) > 0) {
    total_lines <- 0
    for (filename in args) {
      input <- readLines(filename)
      num_lines <- length(input)
      cat(filename)
      cat(" ")
      cat(num_lines, sep = "\n")
      if (length(args) > 1) {
        total_lines = total_lines + num_lines
      }
    }
    cat("Total ")
    cat(total_lines, sep = "\n")
  } else {
    input <- readLines(file("stdin"))
    num_lines <- length(input)
    cat(num_lines, sep = "\n")
  }
}

main()
