#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts
#'
#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts
#' for Height/Weight/BMI/Head Circumference by Age
#'
#' @param dataset Input dataset
#'
#'   The variables specified in `sex`, `age`, `age_unit`, `parameter`, `analysis_var`
#'   are expected to be in the dataset.
#'
#' @permitted [dataset]
#'
#' @param sex Sex
#'
#' @permitted [char_scalar].
#'
#'   Expected Values: `M`, `F`.
#'
#' @param age Current Age
#'
#' @permitted [num_scalar].
#'
#'   Note that this is the actual age at the current visit.
#'
#' @param age_unit Age Unit
#
#' @permitted [char_scalar].
#'
#'   Expected values: `days`, `weeks`, `months`.
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset with the following expected variables:
#'   `AGE`, `AGEU`, `SEX`, `L`, `M`, `S`.
#'
#'   The dataset can be derived from CDC/WHO or user-defined datasets.
#'   The CDC/WHO growth chart metadata datasets are available in the package and will
#'   require small modifications.
#'
#'   If the `age` value from `dataset` falls between two `AGE` values in `meta_criteria`,
#'   then the `L`/`M`/`S` values that are chosen/mapped will be the `AGE` that has the
#'   smaller absolute difference to the value in `age`.
#'   e.g. If dataset has a current age of 27.49 months, and the metadata contains records
#'   for 27 and 28 months, the `L`/`M`/`S` corresponding to the 27 months record will be used.
#'
#'   * `AGE` - Age
#'   * `AGEU` - Age Unit
#'   * `SEX` - Sex
#'   * `L` - Power in the Box-Cox transformation to normality
#'   * `M` - Median
#'   * `S` - Coefficient of variation
#'
#' @permitted [dataset]
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
#' @permitted [condition]
#'
#' @param analysis_var Variable containing anthropometric measurement
#'
#' @permitted [num_scalar] e.g. `AVAL`, `VSSTRESN`.
#'
#' @param bmi_cdc_correction Extended CDC BMI-for-age correction
#'
#'  CDC developed extended percentiles (>95%) to monitor high BMI values,
#'  if set to `TRUE` the CDC's correction is applied.
#'
#' @permitted [logic_scalar]
#'
#' @param who_correction WHO adjustment for weight-based indicators
#'
#'  WHO constructed a restricted application of the LMS method for weight-based indicators.
#'  More details on these exact rules applied can be found at the document page 302 of the
#'  [WHO Child Growth Standards Guidelines](https://www.who.int/publications/i/item/924154693X).
#'  If set to `TRUE` the WHO correction is applied.
#'
#' @permitted [logic_scalar]
#'
#' @param set_values_to_sds Variables to be set for Z-Scores
#'
#'  The specified variables are set to the specified values for the new
#'  observations. For example,
#'   `set_values_to_sds(exprs(PARAMCD = "BMIASDS", PARAM = "BMI-for-age z-score"))`
#'  defines the parameter code and parameter.
#'
#'  The formula to calculate the Z-score is as follows:
#'
#'  \deqn{\frac{((\frac{obs}{M})^L - 1)}{L * S}}
#'
#'  where "obs" is the observed value for the respective anthropometric measure being calculated.
#'
#' @permitted [var_list_value_pairs].
#'
#'  If left as default value, `NULL`, then parameter not derived in output dataset.
#'
#' @param set_values_to_pctl Variables to be set for Percentile
#'
#'  The specified variables are set to the specified values for the new
#'  observations. For example,
#'   `set_values_to_pctl(exprs(PARAMCD = "BMIAPCTL", PARAM = "BMI-for-age percentile"))`
#'  defines the parameter code and parameter.
#'
#' @permitted [var_list_value_pairs].
#'
#'  If left as default value, `NULL`, then parameter not derived in output dataset.
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
#' library(dplyr, warn.conflicts = FALSE)
#' library(lubridate, warn.conflicts = FALSE)
#' library(rlang, warn.conflicts = FALSE)
#' library(admiral, warn.conflicts = FALSE)
#' library(pharmaversesdtm, warn.conflicts = FALSE)
#'
#' advs <- pharmaversesdtm::dm_peds %>%
#'   select(USUBJID, BRTHDTC, SEX) %>%
#'   right_join(., pharmaversesdtm::vs_peds, by = "USUBJID") %>%
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
#'     AGECUR = if_else(AGECUR_D >= 365.25 * 2, AGECUR_M, AGECUR_D),
#'     AGECURU = if_else(AGECUR_D >= 365.25 * 2, CURU_M, CURU_D)
#'   )
#'
#' # metadata is in months
#' cdc_meta_criteria <- admiralpeds::cdc_htage %>%
#'   mutate(
#'     age_unit = "months",
#'     SEX = if_else(SEX == 1, "M", "F")
#'   )
#'
#' # metadata is in days
#' who_meta_criteria <- bind_rows(
#'   (admiralpeds::who_lgth_ht_for_age_boys %>%
#'     mutate(
#'       SEX = "M",
#'       age_unit = "days"
#'     )
#'   ),
#'   (admiralpeds::who_lgth_ht_for_age_girls %>%
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
#'   parameter = VSTESTCD == "HEIGHT",
#'   analysis_var = VSSTRESN,
#'   set_values_to_sds = exprs(
#'     PARAMCD = "HGTSDS",
#'     PARAM = "Height-for-age z-score"
#'   ),
#'   set_values_to_pctl = exprs(
#'     PARAMCD = "HGTPCTL",
#'     PARAM = "Height-for-age percentile"
#'   )
#' )
derive_params_growth_age <- function(dataset,
                                     sex,
                                     age,
                                     age_unit,
                                     meta_criteria,
                                     parameter,
                                     analysis_var,
                                     bmi_cdc_correction = FALSE,
                                     who_correction = FALSE,
                                     set_values_to_sds = NULL,
                                     set_values_to_pctl = NULL) {
  # Apply assertions to each argument to ensure each object is appropriate class
  sex <- assert_symbol(enexpr(sex))
  age <- assert_symbol(enexpr(age))
  age_unit <- assert_symbol(enexpr(age_unit))
  analysis_var <- assert_symbol(enexpr(analysis_var))
  assert_data_frame(
    dataset,
    required_vars = expr_c(sex, age, age_unit, analysis_var)
  )

  assert_data_frame(meta_criteria, required_vars = exprs(SEX, AGE, AGEU, L, M, S))
  if (bmi_cdc_correction == TRUE) {
    assert_data_frame(meta_criteria, required_vars = exprs(SEX, AGE, AGEU, L, M, S, P95, Sigma))
  }

  assert_expr(enexpr(parameter))
  assert_varval_list(set_values_to_sds, optional = TRUE)
  assert_varval_list(set_values_to_pctl, optional = TRUE)

  if (is.null(set_values_to_sds) && is.null(set_values_to_pctl)) {
    cli_abort("One of `set_values_to_sds`/`set_values_to_pctl` has to be specified.")
  }

  # Get the breaks and labels
  bins <- get_bins(meta_criteria, param = "AGE")

  # create a unified join naming convention, hard to figure out in by argument
  relevant_records <- dataset %>%
    filter(!!enexpr(parameter)) %>%
    mutate(
      sex_join := {{ sex }},
      ageu_join := {{ age_unit }},
      age_bins := map({{ age }}, ~ set_bins(.x, breaks = bins$breaks, labels = bins$labels))
    )

  # Process metadata
  # Metadata should contain SEX, AGE, AGEU, L, M, S
  # Processing the data to be compatible with the dataset object
  processed_md <- meta_criteria %>%
    arrange(SEX, AGEU, AGE) %>%
    group_by(SEX, AGEU) %>%
    rename(
      sex_join = SEX,
      metadata_age = AGE,
      ageu_join = AGEU
    ) %>%
    ungroup() %>%
    mutate(
      SD2pos = (M * (1 + 2 * L * S)^(1 / L)),
      SD3pos = (M * (1 + 3 * L * S)^(1 / L)),
      SD2neg = (M * (1 - 2 * L * S)^(1 / L)),
      SD3neg = (M * (1 - 3 * L * S)^(1 / L)),
      age_bins = map(metadata_age, ~ set_bins(.x, breaks = bins$breaks, labels = bins$labels))
    )

  # Merge the dataset that contains the vs records and filter the L/M/S that fit the appropriate age
  added_records <- relevant_records %>%
    left_join(.,
      processed_md,
      by = c("sex_join", "ageu_join", "age_bins")
    ) %>%
    filter(!is.na(metadata_age))

  dataset_final <- dataset

  # create separate records objects as appropriate depending if user specific sds and/or pctl
  if (!is_empty(set_values_to_sds)) {
    add_sds <- added_records %>%
      mutate(
        temp_val := {{ analysis_var }},
        AVAL = ((temp_val / M)^L - 1) / (L * S), # nolint
        temp_z = AVAL,
        !!!set_values_to_sds
      )

    if (who_correction) {
      add_sds <- add_sds %>%
        mutate(
          AVAL = case_when( # nolint
            temp_z > 3 ~ 3 + (temp_val - SD3pos) / (SD3pos - SD2pos),
            temp_z < -3 ~ -3 + (temp_val - SD3neg) / (SD2neg - SD3neg),
            TRUE ~ AVAL
          )
        )
    }

    if (bmi_cdc_correction) {
      add_sds <- add_sds %>%
        mutate(
          AVAL := if_else( # nolint
            temp_val >= P95 & !is.na(P95),
            qnorm((90 + 10 * pnorm((temp_val - P95) / Sigma)) / 100),
            AVAL
          ),
          # Cover the most extreme high BMI values for percentiles of 99.9 recurring
          # in case of Infinity being returned
          AVAL = if_else(AVAL == Inf, 8.21, AVAL)
        ) %>%
        select(-c(P95, Sigma))
    }

    dataset_final <- bind_rows(dataset, add_sds) %>%
      select(-c(L, M, S, sex_join, ageu_join, metadata_age, temp_val, temp_z))
  }

  if (!is_empty(set_values_to_pctl)) {
    add_pctl <- added_records %>%
      mutate(
        temp_val := {{ analysis_var }},
        AVAL = ((temp_val / M)^L - 1) / (L * S), # nolint
        temp_z = AVAL,
        !!!set_values_to_pctl
      )

    if (who_correction) {
      add_pctl <- add_pctl %>%
        mutate(
          AVAL = case_when( # nolint
            temp_z > 3 ~ 3 + (temp_val - SD3pos) / (SD3pos - SD2pos),
            temp_z < -3 ~ -3 + (temp_val - SD3neg) / (SD2neg - SD3neg),
            TRUE ~ AVAL
          )
        )
    }

    add_pctl <- add_pctl %>% mutate(AVAL = pnorm(temp_z) * 100)

    if (bmi_cdc_correction) {
      add_pctl <- add_pctl %>%
        mutate(
          AVAL := if_else( # nolint
            temp_val >= P95 & !is.na(P95),
            90 + 10 * pnorm((temp_val - P95) / Sigma),
            AVAL
          )
        ) %>%
        select(-c(P95, Sigma))
    }

    dataset_final <- bind_rows(dataset_final, add_pctl) %>%
      select(-c(L, M, S, sex_join, ageu_join, metadata_age, temp_val, temp_z))
  }

  dataset_final <- dataset_final %>%
    select(-c(SD2pos, SD3pos, SD2neg, SD3neg, age_bins))

  return(dataset_final)
}
