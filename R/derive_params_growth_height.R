#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts
#'
#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts
#' for Weight/BMI/Head Circumference by Height/Length
#'
#' @param dataset Input dataset
#'
#'   The variables specified in `sex`, `age`, `age_unit`, `parameter`, `analysis_var`
#'   are expected to be in the dataset.
#'
#' @param sex Sex
#'
#'   A character vector is expected.
#'
#'   Expected Values: `M`, `F`
#'
#' @param height Current Height/length
#'
#'   A numeric vector is expected. Note that this is the actual height at the current visit.
#'
#' @param height_unit Lenght/Height Unit
#
#'   A character vector is expected.
#'
#'   Expected values: 'cm'
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset with the following expected variables:
#'   `HEIGHT`, `HEIGHTU`, `SEX`, `L`, `M`, `S`
#'
#'   The dataset can be derived from CDC/WHO or user-defined datasets.
#'   The CDC/WHO growth chart metadata datasets are available in the package and will
#'   require small modifications.
#'   * `HEIGHT` - Height/Length
#'   * `HEIGHTU` - Height Unit
#'   * `SEX` - Sex
#'   * `L` - Power in the Box-Cox transformation to normality
#'   * `M` - Median
#'   * `S` - Coefficient of variation
#'
#' @param parameter Anthropometric measurement parameter to calculate z-score or percentile
#'
#'   A condition is expected with the input dataset `VSTESTCD`/`PARAMCD`
#'   for which we want growth derivations:
#'
#'   e.g. `parameter = VSTESTCD == "WEIGHT"`.
#'
#'   There is CDC/WHO metadata available for Height, Weight, BMI, and Head Circumference available
#'   in the `admiralpeds` package.
#'
#' @param analysis_var Variable containing anthropometric measurement
#'
#' A numeric vector is expected, e.g. `AVAL`, `VSSTRESN`
#'
#' @param set_values_to_sds Variables to be set for Z-Scores
#'
#'  The specified variables are set to the specified values for the new
#'  observations. For example,
#'   `set_values_to_sds(exprs(PARAMCD = “BMIASDS”, PARAM = “BMI-for-height z-score”))`
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
#'   `set_values_to_pctl(exprs(PARAMCD = “BMIAPCTL”, PARAM = “BMI-for-height percentile”))`
#'  defines the parameter code and parameter.
#'
#' *Permitted Values*: List of variable-value pair
#'
#'  If left as default value, `NULL`, then parameter not derived in output dataset
#'
#' @return The input dataset additional records with the new parameter added.
#'
#'
#' @family der_prm_bds_vs
#'
#' @keywords der_prm_bds_vs
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
#'     new_var = AGECUR_M,
#'     new_var_unit = CURU_M,
#'     start_date = BRTHDT,
#'     end_date = VSDT,
#'     out_unit = "months",
#'     trunc_out = FALSE
#'   )
#'
#' heights <- vs_peds %>%
#'   filter(VSTESTCD == "HEIGHT") %>%
#'   select(USUBJID, VSSTRESN, VSSTRESU, VSDTC) %>%
#'   rename(
#'     HEIGHT = VSSTRESN,
#'     HEIGHTU = VSSTRESU
#'   )
#'
#' advs <- advs %>%
#'   right_join(., heights, by = c("USUBJID", "VSDTC"))
#'
#' advs_under2 <- advs %>%
#'   filter(AGECUR_M <= 2)
#'
#' advs_over2 <- advs %>%
#'   filter(AGECUR_M > 2)
#'
#' who_under2 <- bind_rows(
#'   (admiralpeds::who_wt_for_lgth_boys %>%
#'     mutate(
#'       SEX = "M",
#'       height_unit = "cm"
#'     )
#'   ),
#'   (admiralpeds::who_wt_for_lgth_girls %>%
#'     mutate(
#'       SEX = "F",
#'       height_unit = "cm"
#'     )
#'   )
#' ) %>%
#'   rename(
#'     HEIGHT = Length,
#'     HEIGHTU = height_unit
#'   )
#'
#' who_over2 <- bind_rows(
#'   (admiralpeds::who_wt_for_ht_boys %>%
#'     mutate(
#'       SEX = "M",
#'       height_unit = "cm"
#'     )
#'   ),
#'   (admiralpeds::who_wt_for_ht_girls %>%
#'     mutate(
#'       SEX = "F",
#'       height_unit = "cm"
#'     )
#'   )
#' ) %>%
#'   rename(
#'     HEIGHT = Height,
#'     HEIGHTU = height_unit
#'   )
#'
#'
#' derive_params_growth_height(
#'   advs_under2,
#'   sex = SEX,
#'   height = HEIGHT,
#'   height_unit = HEIGHTU,
#'   meta_criteria = who_under2,
#'   parameter = VSTESTCD == "WEIGHT",
#'   analysis_var = VSSTRESN,
#'   set_values_to_sds = exprs(
#'     PARAMCD = "WTASDS",
#'     PARAM = "Weight-for-age z-score"
#'   ),
#'   set_values_to_pctl = exprs(
#'     PARAMCD = "WTAPCTL",
#'     PARAM = "Weight-for-age percentile"
#'   )
#' )
#'
#' derive_params_growth_height(
#'   advs_over2,
#'   sex = SEX,
#'   height = HEIGHT,
#'   height_unit = HEIGHTU,
#'   meta_criteria = who_over2,
#'   parameter = VSTESTCD == "WEIGHT",
#'   analysis_var = VSSTRESN,
#'   set_values_to_sds = exprs(
#'     PARAMCD = "WTASDS",
#'     PARAM = "Weight-for-age z-score"
#'   ),
#'   set_values_to_pctl = exprs(
#'     PARAMCD = "WTAPCTL",
#'     PARAM = "Weight-for-age percentile"
#'   )
#' )
derive_params_growth_height <- function(dataset,
                                        sex,
                                        height,
                                        height_unit,
                                        meta_criteria,
                                        parameter,
                                        analysis_var,
                                        set_values_to_sds = NULL,
                                        set_values_to_pctl = NULL) {
  # Apply assertions to each argument to ensure each object is appropriate class
  sex <- assert_symbol(enexpr(sex))
  height <- assert_symbol(enexpr(height))
  height_unit <- assert_symbol(enexpr(height_unit))
  analysis_var <- assert_symbol(enexpr(analysis_var))
  assert_data_frame(dataset, required_vars = expr_c(sex, height, height_unit, analysis_var))
  assert_data_frame(meta_criteria, required_vars = exprs(SEX, HEIGHT, HEIGHTU, L, M, S))

  assert_expr(enexpr(parameter))
  assert_varval_list(set_values_to_sds, optional = TRUE)
  assert_varval_list(set_values_to_pctl, optional = TRUE)

  if (is.null(set_values_to_sds) && is.null(set_values_to_pctl)) {
    abort("One of `set_values_to_sds`/`set_values_to_pctl` has to be specified.")
  }

  # create a unified join naming convention, hard to figure out in by argument
  dataset <- dataset %>%
    mutate(
      sex_join := {{ sex }},
      heightu_join := {{ height_unit }}
    )

  # Process metadata
  # Metadata should contain SEX, HEIGHT, HEIGHTU, L, M, S
  # Processing the data to be compatible with the dataset object
  processed_md <- meta_criteria %>%
    arrange(SEX, HEIGHTU, HEIGHT) %>%
    group_by(SEX, HEIGHTU) %>%
    mutate(next_height = lead(HEIGHT)) %>%
    rename(
      sex_join = SEX,
      prev_height = HEIGHT,
      heightu_join = HEIGHTU
    )

  # Merge the dataset that contains the vs records and filter the L/M/S that match height
  # To parse out the appropriate age, create [x, y) using prev_height <= height < next_height
  added_records <- dataset %>%
    filter(!!enexpr(parameter)) %>%
    left_join(.,
      processed_md,
      by = c("sex_join", "heightu_join"),
      relationship = "many-to-many"
    ) %>%
    filter(prev_height <= {{ height }} & {{ height }} < next_height)

  dataset_final <- dataset

  # create separate records objects as appropriate depending if user specific sds and/or pctl
  if (!is_empty(set_values_to_sds)) {
    add_sds <- added_records %>%
      mutate(
        AVAL := (({{ analysis_var }} / M)^L - 1) / (L * S), # nolint
        !!!set_values_to_sds
      )

    dataset_final <- bind_rows(dataset, add_sds) %>%
      select(-c(L, M, S, sex_join, heightu_join, prev_height, next_height))
  }

  if (!is_empty(set_values_to_pctl)) {
    add_pctl <- added_records %>%
      mutate(
        AVAL := (({{ analysis_var }} / M)^L - 1) / (L * S), # nolint
        AVAL = pnorm(AVAL) * 100,
        !!!set_values_to_pctl
      )

    dataset_final <- bind_rows(dataset_final, add_pctl) %>%
      select(-c(L, M, S, sex_join, heightu_join, prev_height, next_height))
  }

  return(dataset_final)
}