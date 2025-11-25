#' Derive interpolated rows for the CDC charts (>=2 yrs old)
#'
#' Derive a linear interpolation of rows for the CDC charts (>=2 yrs old) by age in days
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
#' @permitted [dataset]
#'
#' @param by_vars Grouping variables
#'
#'   The variable from `dataset` which identifies the group of observations
#'   to interpolate separately.
#'
#' @permitted [var_list]
#'
#' @param parameter CDC/WHO metadata parameter
#'
#' @permitted [char_scalar].
#'
#'  `"WEIGHT"`, `"HEIGHT"` or `"BMI"` only - Must not be `NULL`
#'   e.g. `parameter = "WEIGHT"`, `parameter = "HEIGHT"`, or   `parameter =
#'   "BMI"`.
#'
#' @return The input dataset plus additional interpolated records: a record for
#'   each day from the minimum age to the maximum age.
#'
#'   If any variables in addition to the expected ones are in the input dataset,
#'   LOCF (Last Observation Carried Forward) is applied to populate them for the
#'   new records.
#'
#' @family metadata
#'
#' @keywords metadata
#'
#' @export
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' library(rlang, warn.conflicts = FALSE)
#'
#' cdc_htage <- admiralpeds::cdc_htage %>%
#'   mutate(
#'     SEX = case_when(
#'       SEX == 1 ~ "M",
#'       SEX == 2 ~ "F",
#'       TRUE ~ NA_character_
#'     ),
#'     # Ensure first that Age unit is "DAYS"
#'     AGE = round(AGE * 30.4375),
#'     AGEU = "DAYS"
#'   )
#'
#' # Interpolate the AGE by SEX
#' derive_interp_records(
#'   dataset = cdc_htage,
#'   by_vars = exprs(SEX),
#'   parameter = "HEIGHT"
#' )
derive_interp_records <- function(dataset,
                                  by_vars = NULL,
                                  parameter) {
  # Apply assertions to each argument to ensure each object is appropriate class
  assert_vars(by_vars, optional = TRUE)
  assert_character_scalar(parameter, values = c("HEIGHT", "WEIGHT", "BMI"))
  assert_data_frame(dataset, required_vars = exprs(!!!by_vars, AGE, AGEU, L, M, S))
  if (parameter == "BMI") {
    assert_data_frame(dataset, required_vars = exprs(!!!by_vars, AGE, AGEU, L, M, S, P95, Sigma))
  }

  # Ensure to have AGE unit in "Days"
  if (any(toupper(dataset$AGEU) != "DAYS")) {
    cli_abort("The Age Unit (AGEU) from the input dataset must be in 'DAYS'")
  }

  # Sort the data for the interpolation
  dataset <- arrange(dataset, !!!by_vars, AGE)

  # Define the metadata variables to be interpolated
  interp_vars <- c("AGE", "L", "M", "S")
  if (parameter == "BMI") {
    interp_vars <- append(interp_vars, c("P95", "Sigma"))
  }

  # Ensure the uniqueness of records to interpolate
  signal_duplicate_records(dataset, by_vars = exprs(!!!by_vars, AGE))

  # Define the non-interpolated variables and keep the corresponding unique records
  non_interp_vars <- setdiff(names(dataset), c(interp_vars, by_vars))
  non_interp_dataset <- dataset %>%
    select(!!!by_vars, AGE, all_of(non_interp_vars))

  # Linear interpolation
  fapp <- function(v, age) {
    approx(age, v, xout = seq(min(age), max(age)))$y
  }

  # Apply LOCF to non-interpolated variables
  apply_locf <- function(x) {
    na.locf(x, na.rm = FALSE)
  }

  # Apply the function within each group and combine the results
  if (is.null(by_vars)) {
    interp_dataset <- dataset %>%
      reframe({
        age <- AGE
        x <- lapply(select(., all_of(interp_vars)), fapp, age = age)
        as.data.frame(do.call(bind_cols, x))
      }) %>%
      filter(!is.na(AGE))
  } else {
    interp_dataset <- dataset %>%
      group_by(!!!by_vars) %>%
      reframe({
        age <- AGE
        x <- lapply(across(all_of(interp_vars)), fapp, age = age)
        as.data.frame(do.call(bind_cols, x))
      }) %>%
      ungroup() %>%
      filter(!is.na(AGE))
  }

  # Merge non-interpolated variables (if any) back into the interpolated dataset
  interp_dataset %>%
    left_join(non_interp_dataset, by = c(vars2chr(by_vars), "AGE")) %>%
    group_by(!!!by_vars) %>%
    # Apply LOCF to the non-interpolated variables
    mutate(across(all_of(non_interp_vars), apply_locf)) %>%
    ungroup()
}
