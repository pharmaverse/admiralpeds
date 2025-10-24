library(lintr)

source(system.file("lintr/linters.R", package = "admiraldev"))

linters <- admiral_linters()

exclusions <- list(
  "data-raw" = Inf,
  "R/data.R" = Inf,
  "R/admiralpeds-package.R" = Inf,
  "inst" = list(undesirable_function_linter = Inf),
  "vignettes" = list(undesirable_function_linter = Inf),
  "tests/testthat/test-cdc_growth_charts.R" = list(undesirable_function_linter = Inf)
)
