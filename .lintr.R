# Source in temporary environment to avoid changing the global environment
temp_env <- new.env(parent = globalenv())

source(system.file("lintr/linters.R", package = "admiraldev"), local = temp_env)

linters <- temp_env$admiral_linters()

# Remove temporary environment to avoid lintr warning regarding "unused settings"
rm(temp_env)

exclusions <- list(
  "data-raw" = Inf,
  "R/data.R" = Inf,
  "R/admiralpeds-package.R" = Inf,
  "inst" = list(undesirable_function_linter = Inf),
  "vignettes" = list(undesirable_function_linter = Inf),
  "tests/testthat/test-cdc_growth_charts.R" = list(undesirable_function_linter = Inf)
)
