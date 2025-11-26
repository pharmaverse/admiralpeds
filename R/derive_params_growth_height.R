#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length)
#' based on Standard Growth Charts
#'
#' Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length)
#' based on Standard Growth Charts for Weight by Height/Length
#'
#' @param dataset Input dataset
#'
#'   The variables specified in `sex`, `height`, `height_unit`, `parameter`, `analysis_var`
#'   are expected to be in the dataset.
#'
#' @permitted [dataset]
#'
#' @param sex Sex
#'
#' @permitted [char_scalar].
#'
#'   Expected values: `M`, `F`.
#'
#' @param height Current Height/length
#'
#' @permitted [num_scalar].
#'
#'   Note that this is the actual height/length at the current visit.
#'
#' @param height_unit Height/Length Unit
#'
#' @permitted [char_scalar].
#'
#'   Expected values: `cm`.
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset with the following expected variables:
#'   `HEIGHT_LENGTH`, `HEIGHT_LENGTHU`, `SEX`, `L`, `M`, `S`
#'
#'   The dataset can be derived from WHO or user-defined datasets.
#'   The WHO growth chart metadata datasets are available in the package and will
#'   require small modifications.
#'
#'   Datasets `who_wt_for_lgth_boys`/`who_wt_for_lgth_girls` are applicable for
#'   subject age < 730.5 days.
#'
#'   If the `height` value from `dataset` falls between two `HEIGHT_LENGTH` values in
#'   `meta_criteria`, then the `L`/`M`/`S` values that are chosen/mapped will be the
#'   `HEIGHT_LENGTH` that has the smaller absolute difference to the value in `height`.
#'   e.g. If dataset has a current age of 50.49 cm, and the metadata contains records
#'   for 50 and 51 cm, the `L`/`M`/`S` corresponding to the 50 cm record will be used.
#'
#'   * `HEIGHT_LENGTH` - Height/Length
#'   * `HEIGHT_LENGTHU` - Height/Length Unit
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
#'   There is WHO metadata available for Weight available in the `admiralpeds` package.
#'   Weight measures are expected to be in the unit "kg".
#'
#' @permitted [condition]
#'
#' @param analysis_var Variable containing anthropometric measurement
#'
#' @permitted [num_scalar] e.g. `AVAL`, `VSSTRESN`.
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
#'   `set_values_to_sds(exprs(PARAMCD = "WGTHSDS", PARAM = "Weight-for-height z-score"))`
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
#'   `set_values_to_pctl(exprs(PARAMCD = "WGTHPCTL", PARAM = "Weight-for-height percentile"))`
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
#' # derive weight for height/length only for those under 2 years old using WHO
#' # weight for length reference file
#' advs <- pharmaversesdtm::dm_peds %>%
#'   select(USUBJID, BRTHDTC, SEX) %>%
#'   right_join(., pharmaversesdtm::vs_peds, by = "USUBJID") %>%
#'   mutate(
#'     VSDT = ymd(VSDTC),
#'     BRTHDT = ymd(BRTHDTC)
#'   ) %>%
#'   derive_vars_duration(
#'     new_var = AAGECUR,
#'     new_var_unit = AAGECURU,
#'     start_date = BRTHDT,
#'     end_date = VSDT,
#'     out_unit = "days"
#'   )
#'
#' heights <- pharmaversesdtm::vs_peds %>%
#'   filter(VSTESTCD == "HEIGHT") %>%
#'   select(USUBJID, VSSTRESN, VSSTRESU, VSDTC) %>%
#'   rename(
#'     HGTTMP = VSSTRESN,
#'     HGTTMPU = VSSTRESU
#'   )
#'
#' advs <- advs %>%
#'   right_join(., heights, by = c("USUBJID", "VSDTC"))
#'
#' advs_under2 <- advs %>%
#'   filter(AAGECUR < 730.5)
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
#'     HEIGHT_LENGTH = Length,
#'     HEIGHT_LENGTHU = height_unit
#'   )
#'
#' derive_params_growth_height(
#'   advs_under2,
#'   sex = SEX,
#'   height = HGTTMP,
#'   height_unit = HGTTMPU,
#'   meta_criteria = who_under2,
#'   parameter = VSTESTCD == "WEIGHT",
#'   analysis_var = VSSTRESN,
#'   who_correction = TRUE,
#'   set_values_to_sds = exprs(
#'     PARAMCD = "WGTHSDS",
#'     PARAM = "Weight-for-height/length z-score"
#'   ),
#'   set_values_to_pctl = exprs(
#'     PARAMCD = "WGTHPCTL",
#'     PARAM = "Weight-for-height/length percentile"
#'   )
#' )
derive_params_growth_height <- function(dataset,
                                        sex,
                                        height,
                                        height_unit,
                                        meta_criteria,
                                        parameter,
                                        analysis_var,
                                        who_correction = FALSE,
                                        set_values_to_sds = NULL,
                                        set_values_to_pctl = NULL) {
  # Apply assertions to each argument to ensure each object is appropriate class
  sex <- assert_symbol(enexpr(sex))
  height <- assert_symbol(enexpr(height))
  height_unit <- assert_symbol(enexpr(height_unit))
  analysis_var <- assert_symbol(enexpr(analysis_var))
  assert_data_frame(
    dataset,
    required_vars = expr_c(sex, height, height_unit, analysis_var)
  )
  assert_data_frame(
    meta_criteria,
    required_vars = exprs(SEX, HEIGHT_LENGTH, HEIGHT_LENGTHU, L, M, S)
  )

  assert_expr(enexpr(parameter))
  assert_varval_list(set_values_to_sds, optional = TRUE)
  assert_varval_list(set_values_to_pctl, optional = TRUE)

  if (is.null(set_values_to_sds) && is.null(set_values_to_pctl)) {
    cli_abort("One of `set_values_to_sds`/`set_values_to_pctl` has to be specified.")
  }

  bins <- get_bins(meta_criteria, param = "HEIGHT_LENGTH")

  # create a unified join naming convention, hard to figure out in by argument
  relevant_records <- dataset %>%
    filter(!!enexpr(parameter)) %>%
    mutate(
      sex_join := {{ sex }},
      heightu_join := {{ height_unit }},
      ht_bins := map({{ height }}, ~ set_bins(.x, breaks = bins$breaks, labels = bins$labels))
    )

  # Process metadata
  # Metadata should contain SEX, HEIGHT_LENGTH, HEIGHT_LENGTHU, L, M, S
  # Processing the data to be compatible with the dataset object
  processed_md <- meta_criteria %>%
    arrange(SEX, HEIGHT_LENGTHU, HEIGHT_LENGTH) %>%
    group_by(SEX, HEIGHT_LENGTHU) %>%
    rename(
      sex_join = SEX,
      meta_height = HEIGHT_LENGTH,
      heightu_join = HEIGHT_LENGTHU
    ) %>%
    ungroup() %>%
    mutate(
      SD2pos = (M * (1 + 2 * L * S)^(1 / L)),
      SD3pos = (M * (1 + 3 * L * S)^(1 / L)),
      SD2neg = (M * (1 - 2 * L * S)^(1 / L)),
      SD3neg = (M * (1 - 3 * L * S)^(1 / L)),
      ht_bins = map(meta_height, ~ set_bins(.x, breaks = bins$breaks, labels = bins$labels))
    )

  # Merge the dataset that contains the vs records and filter the L/M/S that match height
  added_records <- relevant_records %>%
    left_join(.,
      processed_md,
      by = c("sex_join", "heightu_join", "ht_bins")
    ) %>%
    filter(!is.na(meta_height))

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

    dataset_final <- bind_rows(dataset, add_sds) %>%
      select(-c(L, M, S, sex_join, heightu_join, meta_height, temp_val, temp_z))
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
          ),
        )
    }

    add_pctl <- add_pctl %>%
      mutate(AVAL = pnorm(temp_z) * 100)

    dataset_final <- bind_rows(dataset_final, add_pctl) %>%
      select(-c(L, M, S, sex_join, heightu_join, meta_height, temp_val, temp_z))
  }

  dataset_final <- dataset_final %>%
    select(-c(SD2pos, SD3pos, SD2neg, SD3neg, ht_bins))

  return(dataset_final)
}
