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
#' @return The input dataset plus additional interpolated records: a record
#'         for each day from the minimum age to the maximum age.
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
  ageu <- dataset %>%
    select(AGEU) %>%
    filter(toupper(AGEU) != "DAYS") %>%
    group_by(AGEU) %>%
    slice(1) %>%
    ungroup()

  if (nrow(ageu) > 0) {
    cli_abort("The Age Unit (AGEU) from the input dataset must be in 'DAYS'")
  }

  # Sort the data for the interpolation
  arrange(dataset, !!!by_vars, AGE)

  # Ensure the uniqueness of records to interpolate
  signal_duplicate_records(dataset, by_vars = exprs(!!!by_vars, AGE))

  # Define the metadata variables to be interpolated
  metadata_vars <- c("AGE", "L", "M", "S")
  if (parameter == "BMI") {
    metadata_vars <- append(metadata_vars, c("P95", "Sigma"))
  }

  # Linear interpolation
  fapp <- function(v, age) {
    approx(age, v, xout = seq(min(age), max(age)))$y
  }

  # Apply the function within each group and combine the results
  if (is.null(by_vars)) {
    dataset <- dataset %>%
      reframe({
        age <- AGE
        x <- lapply(select(., all_of(metadata_vars)), fapp, age = age)
        as.data.frame(do.call(bind_cols, x))
      }) %>%
      filter(!is.na(AGE))
  } else {
    dataset <- dataset %>%
      group_by(across(!!!syms(map(replace_values_by_names(by_vars), as_label)))) %>%
      reframe({
        age <- AGE
        x <- lapply(across(all_of(metadata_vars)), fapp, age = age)
        as.data.frame(do.call(bind_cols, x))
      }) %>%
      ungroup() %>%
      filter(!is.na(AGE))
  }

  return(dataset)
}
