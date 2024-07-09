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
#' @param parameter CDC/WHO metadata parameter
#'
#' *Permitted Values*: `"WEIGHT"`, `"HEIGHT"` or `"BMI"` only - Must not be `NULL`
#'
#'   e.g. `parameter = "WEIGHT"`,
#'        `parameter = "HEIGHT"`,
#'   or   `parameter = "BMI"`.
#'
#' @return The input dataset plus additional interpolated records
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
#'    SEX = case_when(
#'       SEX == 1 ~ "M",
#'       SEX == 2 ~ "F",
#'       TRUE ~ NA_character_
#'       ),
#'     AGE = AGE * 30.4375) %>%
#'   # Interpolate the AGE by SEX
#'   group_by(SEX) %>%
#'   # Ensure first that Age unit is "DAYS"
#'   do(derive_interp_records(., parameter = "HEIGHT")) %>%
#'   ungroup()
#'
#'   print(cdc_htage)
derive_interp_records <- function(dataset, parameter = "WEIGHT") {
  stopifnot(parameter %in% c("HEIGHT", "WEIGHT", "BMI"))
  if (parameter %in% c("HEIGHT", "WEIGHT")) {
    metadata_vars <- c("AGE", "L", "M", "S")
  }
  if (parameter == "BMI") {
    metadata_vars <- c("AGE", "L", "M", "S", "P95", "Sigma")
  }

  stopifnot("AGE" %in% colnames(dataset))
  stopifnot("SEX" %in% colnames(dataset))
  stopifnot("L" %in% colnames(dataset))
  stopifnot("M" %in% colnames(dataset))
  stopifnot("S" %in% colnames(dataset))
  if (parameter == "BMI") {
    stopifnot("P95" %in% colnames(dataset))
    stopifnot("Sigma" %in% colnames(dataset))
  }
  arrange(dataset, SEX, AGE)
  fapp <- function(v) approx(dataset$AGE, v, xout = 730:7305)$y
  x <- lapply(dataset[, metadata_vars], fapp)
  as.data.frame(do.call(bind_cols, x)) %>% filter(!is.na(AGE))
}
