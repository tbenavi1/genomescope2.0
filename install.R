pkgs <- c(
  "argparse",
  "cowplot",
  "ggplot2",
  "minpack.lm",
  "scales",
  "viridis"
)
install.packages(pkgs, dependencies = TRUE)
install.packages(".", repos = NULL, type = "source")
