#' Derive Growth Chart Z-Scores/Percentiles by Age
#'
#' Derive Growth Chart Z-Scores/Percentiles
#' for Height/Weight/BMI by Age
#'
#' @param dataset Input dataset
#'
#'   The variables specified in `sex`, `age`, `age_unit` are expected to be in the dataset.
#'
#' @param sex Sex
#'
#'   A character vector is expected.
#'
#'   Expected Values: `M`, `F`
#'
#' @param age Current Age
#'
#'   A numeric vector is expected.
#'
#' @param age_unit Age Unit
#
#'   A character vector is expected.
#'
#'   Expected values: 'days' 'months'
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset with the following expected variables:
#'   `AGE`, `AGEU`, `SEX`, `L`, `M`, `S`
#'
#'   The dataset can be derived from CDC/WHO or user-defined datasets.
#'   The CDC/WHO growth chart metadata datasets are available in the package and will
#'   require small modifications.
#'   * `AGE` - Age
#'   * `AGEU` - Age Unit
#'   * `SEX` - Sex
#'   * `L` - Power in the Box-Cox transformation to normality
#'   * `M` - Median
#'   * `S` - Coefficient of variation
#'
#' @param parameter Desired parameter
#'
#'   A condition is expected with the input dataset `VSTESTCD`/`PARAMCD`
#'   for which we want growth derivations:
#'
#'   e.g. `parameter = VSTESTCD == "WEIGHT"`.
#'
#'   There is CDC/WHO metadata available for Height, Weight, BMI, and Head Circumference
#'
#' @param set_values_to_sds Variables to be set for Z-Scores
#'
#'  The specified variables are set to the specified values for the new
#'  observations. For example,
#'   `set_values_to_sds(exprs(PARAMCD = “BMIASDS”, PARAM = “BMI-for-age z-score”))`
#'  defines the parameter code and parameter.
#'
#' *Permitted Values*: List of variable-value pairs
#'
#'  If left as default value, `NULL`, then parameter not derived in output dataset
#'
#' @param set_values_to_pctl Variables to be set for Percentile
#'
#'  The specified variables are set to the specified values for the new
#'  observations. For example,
#'   `set_values_to_pctl(exprs(PARAMCD = “BMIAPCTL”, PARAM = “BMI-for-age percentile”))`
#'  defines the parameter code and parameter.
#'
#' *Permitted Values*: List of variable-value pair
#'
#'  If left as default value, `NULL`, then parameter not derived in output dataset
#'
#' @return The input dataset additional records with the new parameter added.
#'
#'
#' @family der_growth
#'
#' @keywords der_growth
#'
#' @export
#'
#' @examples
#' library(dplyr)
#' library(lubridate)
#' library(rlang)
#' library(admiral)
#'
#' advs <- dm_peds %>%
#'   select(USUBJID, BRTHDTC, SEX) %>%
#'   right_join(., vs_peds, by = "USUBJID") %>%
#'   filter(USUBJID != "PEDS-1010") %>%
#'   mutate(
#'     VSDT = ymd(VSDTC),
#'     BRTHDT = ymd(BRTHDTC)
#'   ) %>%
#'   derive_vars_duration(
#'     new_var = AGECUR_D,
#'     new_var_unit = CURU_D,
#'     start_date = BRTHDT,
#'     end_date = VSDT,
#'     out_unit = "days",
#'     trunc_out = FALSE
#'   ) %>%
#'   derive_vars_duration(
#'     new_var = AGECUR_M,
#'     new_var_unit = CURU_M,
#'     start_date = BRTHDT,
#'     end_date = VSDT,
#'     out_unit = "months",
#'     trunc_out = FALSE
#'   ) %>%
#'   mutate(
#'     AGECUR = ifelse(AGECUR_D >= 365.25 * 2, AGECUR_M, AGECUR_D),
#'     AGECURU = ifelse(AGECUR_D >= 365.25 * 2, CURU_M, CURU_D)
#'   )
#'
#' #' metadata is in months
#' cdc_meta_criteria <- admiralpeds::cdc_wtage %>%
#'   mutate(
#'     age_unit = "months",
#'     SEX = ifelse(SEX == 1, "M", "F")
#'   )
#'
#' #' metadata is in days
#' who_meta_criteria <- bind_rows(
#'   (admiralpeds::who_wt_for_age_boys %>%
#'     mutate(
#'       SEX = "M",
#'       age_unit = "days"
#'     )
#'   ),
#'   (admiralpeds::who_wt_for_age_girls %>%
#'     mutate(
#'       SEX = "F",
#'       age_unit = "days"
#'     )
#'   )
#' ) %>%
#'   rename(AGE = Day)
#'
#' criteria <- bind_rows(
#'   cdc_meta_criteria,
#'   who_meta_criteria
#' ) %>%
#'   rename(AGEU = age_unit)
#'
#' derive_params_growth_age(
#'   advs,
#'   sex = SEX,
#'   age = AGECUR,
#'   age_unit = AGECURU,
#'   meta_criteria = criteria,
#'   parameter = VSTESTCD == "WEIGHT",
#'   set_values_to_sds = exprs(
#'     PARAMCD = "WTASDS",
#'     PARAM = "Weight-for-age z-score"
#'   ),
#'   set_values_to_pctl = exprs(
#'     PARAMCD = "WTAPCTL",
#'     PARAM = "Weight-for-age percentile"
#'   )
#' )
derive_params_growth_age <- function(dataset,
                                     sex,
                                     age,
                                     age_unit,
                                     meta_criteria,
                                     parameter,
                                     set_values_to_sds = NULL,
                                     set_values_to_pctl = NULL) {
  # Apply assertions to each argument to ensure each object is appropriate class
  # need to add assertion for dataset that checks columns in sex, age, age_unit are present
  assert_data_frame(meta_criteria, required_vars = exprs(SEX, AGE, AGEU, L, M, S))
  assert_expr(enexpr(parameter))
  assert_varval_list(set_values_to_sds, optional = TRUE)
  assert_varval_list(set_values_to_pctl, optional = TRUE)

  dataset <- dataset %>%
    mutate(
      sex_join := {{ sex }},
      ageu_join := {{ age_unit }}
    )

  # Process metadata
  # Metadata should contain SEX, AGE, AGEU, L, M, S
  # Processing the data to be compatible with the dataset object
  processed_md <- meta_criteria %>%
    arrange(SEX, AGEU, AGE) %>%
    group_by(SEX, AGEU) %>%
    mutate(next_age = lead(AGE)) %>% # needed for the join and filter later
    rename(
      sex_join = SEX,
      prev_age = AGE,
      ageu_join = AGEU
    )

  # Merge the dataset that contains the vs records and filter the L/M/S that fit the appropriate age
  # To parse out the appropriate age, create [x, y) brackets using a AGE <= AGECUR < next_age
  added_records <- dataset %>%
    filter(!!enexpr(parameter)) %>%
    left_join(.,
      processed_md,
      by = c("sex_join", "ageu_join"),
      relationship = "many-to-many"
    ) %>%
    filter(prev_age <= {{ age }} & {{ age }} < next_age)

  dataset_final <- dataset

  # create separate records objects as appropriate depending if user specific sds and/or pctl
  if (!is_empty(set_values_to_sds)) {
    add_sds <- added_records %>%
      mutate(
        AVAL = ((VSSTRESN / M)^L - 1) / (L * S),
        !!!set_values_to_sds
      )
    dataset_final <- bind_rows(dataset, add_sds) %>%
      select(-c(L, M, S, sex_join, ageu_join, prev_age, next_age))
  }

  if (!is_empty(set_values_to_pctl)) {
    add_pctl <- added_records %>%
      mutate(
        AVAL = ((VSSTRESN / M)^L - 1) / (L * S),
        AVAL = pnorm(AVAL) * 100,
        # may need to add special modification for > 95th percentile
        !!!set_values_to_pctl
      )

    dataset_final <- bind_rows(dataset_final, add_pctl) %>%
      select(-c(L, M, S, sex_join, ageu_join, prev_age, next_age))
  }

  return(dataset_final)
}
