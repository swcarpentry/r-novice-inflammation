main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  filename <- args[1]
  dat <- read.csv(file = filename, header = TRUE)
  mean_per_patient <- apply(dat[,5:8], 1, mean)
  cat(mean_per_patient, sep = "\n")
}

main()
