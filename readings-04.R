main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  action <- args[1]
  filenames <- args[-1]
  
  for (f in filenames) {
    dat <- read.csv(file = f, header = TRUE)
    
    if (action == "--min") {
      values <- apply(dat[,5:8], 1, min)
    } else if (action == "--mean") {
      values <- apply(dat[,5:8], 1, mean)
    } else if (action == "--max") {
      values <- apply(dat[,5:8], 1, max)
    }
    cat(values, sep = "\n")
  }
}

main()
