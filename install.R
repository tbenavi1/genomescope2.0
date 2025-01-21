pkgs <- c(
  "argparse",
  "jsonlite",
  "minpack.lm"
)
install.packages(pkgs, dependencies = TRUE)
install.packages(".", repos = NULL, type = "source")
