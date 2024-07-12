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
#'     # Ensure first that Age unit is "DAYS"
#'     AGE = round(AGE * 30.4375)
#'   ) %>%
#'   # Interpolate the AGE by SEX
#'   derive_interp_records(by_vars = exprs(SEX), parameter = "HEIGHT")
#'
#' print(cdc_htage)
derive_interp_records <- function(dataset,
                                  by_vars = NULL,
                                  parameter) {
  # Apply assertions to each argument to ensure each object is appropriate class
  by_vars <- assert_vars(by_vars, optional = TRUE)
  assert_character_scalar(parameter, values = c("HEIGHT", "WEIGHT", "BMI"))
  assert_data_frame(dataset, required_vars = exprs(!!!by_vars, AGE, L, M, S))
  if (parameter == "BMI") {
    assert_data_frame(dataset, required_vars = exprs(!!!by_vars, AGE, L, M, S, P95, Sigma))
  }

  arrange(dataset, !!!by_vars, AGE)

  # Ensure to have unique combination when by_vars is not defined
  metadata_vars <- c("AGE", "L", "M", "S")
  if (parameter == "BMI") {
    metadata_vars <- append(metadata_vars, c("P95", "Sigma"))
  }

  if (is.null(by_vars)) {
    other_data_vars <- names(dataset %>% select(-all_of(metadata_vars)))

    nb_occ <- nrow(dataset %>%
      group_by_at(other_data_vars) %>%
      slice(1) %>%
      ungroup())

    if (nb_occ > 1) {
      stop(paste0("The combination of ", paste(other_data_vars, collapse = ", "), " must be unique. Please define `by_vars` otherwise."))
    }
  }

  # Linear interpolation
  fapp <- function(v, age) {
    approx(age, v, xout = seq(min(age), max(age)))$y
  }

  # Apply the function within each group and combine the results
  dataset <- dataset %>%
    group_by(!!!by_vars) %>%
    do({
      age <- .$AGE
      x <- lapply(.[, metadata_vars], fapp, age = age)
      as.data.frame(do.call(bind_cols, x))
    }) %>%
    ungroup() %>%
    filter(!is.na(AGE))
}