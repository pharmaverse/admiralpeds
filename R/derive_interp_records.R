#' Derive interpolated rows for the CDC charts (>=2 yrs old)
#'
#' Derive interpolated rows for the CDC charts (>=2 yrs old) by age in days
#' for the following parameters: HEIGHT, WEIGHT and BMI
#'
#' @param dataset Input metadataset
#'
#'   The variables `AGE`, `AGEU`, `SEX`, `L`, `M`, `S` are expected to be in the dataset
#'
#'   For BMI the additional variables `P95` and `Sigma` are expected to be in the dataset
#'
#'   Note that `AGE` must be in days so that `AGEU` is equal to `"DAYS"`
#'
#' @param by_vars Grouping variables
#'
#'   The variable from `dataset` which identifies the group of observations
#'   to interpolate separately.
#'
#'   Must not be `NULL`.
#'
#' @param parameter CDC/WHO metadata parameter
#'
#' *Permitted Values*: `"WEIGHT"`, `"HEIGHT"` or `"BMI"` only - Must not be `NULL`
#'
#'   e.g. `parameter = "WEIGHT"`,
#'        `parameter = "HEIGHT"`,
#'   or   `parameter = "BMI"`.
#'
#' @return The input dataset plus additional interpolated records.
#'
#' @family metadata
#'
#' @keywords metadata
#'
#' @export
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdc_htage <- admiralpeds::cdc_htage %>%
#'   mutate(
#'     SEX = case_when(
#'       SEX == 1 ~ "M",
#'       SEX == 2 ~ "F",
#'       TRUE ~ NA_character_
#'     ),
#'     AGE = round(AGE * 30.4375)
#'   ) %>%
#'   # Interpolate the AGE by SEX
#'   # Ensure first that Age unit is "DAYS"
#'   derive_interp_records(., parameter = "HEIGHT")
#'
#' print(cdc_htage)
derive_interp_records <- function(dataset,
                                  by_vars = exprs(SEX),
                                  parameter = "WEIGHT") {
  stopifnot(parameter %in% c("HEIGHT", "WEIGHT", "BMI"))
  if (parameter %in% c("HEIGHT", "WEIGHT")) {
    metadata_vars <- c("AGE", "L", "M", "S")
  }
  if (parameter == "BMI") {
    metadata_vars <- c("AGE", "L", "M", "S", "P95", "Sigma")
  }

  stopifnot("AGE" %in% colnames(dataset))
  stopifnot(expr(!!by_vars) %in% colnames(dataset))
  stopifnot("L" %in% colnames(dataset))
  stopifnot("M" %in% colnames(dataset))
  stopifnot("S" %in% colnames(dataset))
  if (parameter == "BMI") {
    stopifnot("P95" %in% colnames(dataset))
    stopifnot("Sigma" %in% colnames(dataset))
  }

  arrange(dataset, !!!by_vars, AGE)

  fapp <- function(v, age) {
    approx(age, v, xout = seq(min(age), max(age)))$y
  }

  # Apply the function within each group and combine the results
  result <- dataset %>%
    group_by(!!!by_vars) %>%
    do({
      age <- .$AGE
      x <- lapply(.[, metadata_vars], fapp, age = age)
      as.data.frame(do.call(bind_cols, x))
    }) %>%
    ungroup() %>%
    # Keep patients >= 2 yrs till 20 yrs - Remove duplicates for 730 Days old which
    # must come from WHO metadata only
    filter(!is.na(AGE) & AGE >= 730.5 & AGE <= 7305)

  return(result)
}
