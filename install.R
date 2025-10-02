pkgs <- c(
  "argparse",
  "jsonlite",
  "minpack.lm"
)
install.packages(pkgs, dependencies = TRUE, repos = "https://cloud.r-project.org")
install.packages(".", repos = NULL, type = "source")
