# Name: ADVS
#
# Label: Vital Signs Analysis Dataset
#
# Input: adsl, vs
#        WHO_bmi_for_age_boys, WHO_bmi_for_age_girls, cdc_bmiage,
#        who_lgth_ht_for_age_boys, who_lgth_ht_for_age_girls, cdc_htage,
#        who_wt_for_age_boys, who_wt_for_age_girls, cdc_wtage,
#        who_hc_for_age_boys, who_hc_for_age_girls,
#        who_wt_for_ht_boys, who_wt_for_ht_girls, who_wt_for_lgth_boys, who_wt_for_lgth_girls

library(admiral)
library(admiraldev)
library(pharmaversesdtm) # Contains example datasets from the CDISC pilot project
library(dplyr)
library(lubridate)
library(stringr)
# library(rlang)

# Creation of the Growth metadata combining WHO and CDC
# Default reference sources: WHO for children <2 yrs old (<=730 days),
# and CDC for children >=2 yrs old (>= 730.5 days)
# Load WHO and CDC metadata datasets ----
message("Please be aware that our default reference source in our metadata is :
        WHO for <2 yrs old children, and CDC for >=2 yrs old children.
The user could replace these metadata with their own chosen metadata")

## BMI for age ----
data(WHO_bmi_for_age_boys)
data(WHO_bmi_for_age_girls)
data(cdc_bmiage)

bmi_for_age <- who_bmi_for_age_boys %>%
  filter(Day <= 730) %>%
  mutate(SEX = "M") %>%
  rbind(who_bmi_for_age_girls %>%
    filter(Day <= 730) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  rbind(cdc_bmiage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      AGE = AGE * 30.4375
    )) %>%
  # AGEU is added in metadata, required for derive_params_growth_age
  mutate(AGEU = "DAYS") %>%
  arrange(AGE, SEX)

## HEIGHT for age ----
data(who_lgth_ht_for_age_boys)
data(who_lgth_ht_for_age_girls)
data(cdc_htage)

height_for_age <- who_lgth_ht_for_age_boys %>%
  filter(Day <= 730) %>%
  mutate(SEX = "M") %>%
  rbind(who_lgth_ht_for_age_girls %>%
    filter(Day <= 730) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  rbind(cdc_htage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      AGE = AGE * 30.4375
    )) %>%
  # AGEU is added in metadata, required for derive_params_growth_age
  mutate(AGEU = "DAYS") %>%
  arrange(AGE, SEX)

## WEIGHT for age ----
data(who_wt_for_age_boys)
data(who_wt_for_age_girls)
data(cdc_wtage)
weight_for_age <- who_wt_for_age_boys %>%
  filter(Day <= 730) %>%
  mutate(SEX = "M") %>%
  rbind(who_wt_for_age_girls %>%
    filter(Day <= 730) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  rbind(cdc_wtage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      AGE = AGE * 30.4375
    )) %>%
  # AGEU is added in metadata, required for derive_params_growth_age
  mutate(AGEU = "DAYS") %>%
  arrange(AGE, SEX)

## WHO - HEAD CIRCUMFERENCE for age ----
data(who_hc_for_age_boys)
data(who_hc_for_age_girls)
who_hc_for_age <- who_hc_for_age_boys %>%
  filter(Day <= 730) %>%
  mutate(SEX = "M") %>%
  rbind(who_hc_for_age_girls %>%
    filter(Day <= 730) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  # AGEU is added in metadata, required for derive_params_growth_age
  mutate(AGEU = "DAYS") %>%
  arrange(AGE, SEX)

## WHO - WEIGHT/HEIGHT ----
data(who_wt_for_ht_boys)
data(who_wt_for_ht_girls)
data(who_wt_for_lgth_boys)
data(who_wt_for_lgth_girls)

who_wt_for_ht_lgth <- who_wt_for_ht_boys %>%
  mutate(SEX = "M") %>%
  rbind(who_wt_for_ht_girls %>%
    mutate(SEX = "F")) %>%
  mutate(MEASURE = "HEIGHT") %>%
  rename(HEIGHT_LENGTH = Height) %>%
  rbind(who_wt_for_lgth_boys %>%
    mutate(SEX = "M") %>%
    rbind(who_wt_for_lgth_girls %>%
      mutate(SEX = "F")) %>%
    mutate(MEASURE = "LENGTH") %>%
    rename(HEIGHT_LENGTH = Length))

# ADVS template: Load source datasets ----

# Use e.g. `haven::read_sas()` to read in .sas7bdat, or other suitable functions
# as needed and assign to the variables below.
# For illustration purposes read in admiral test data

data("vs_peds")
data("dm_peds")

vs <- vs_peds
dm <- dm_peds

# When SAS datasets are imported into R using haven::read_sas(), missing
# character values from SAS appear as "" characters in R, instead of appearing
# as NA values. Further details can be obtained via the following link:
# https://pharmaverse.github.io/admiral/articles/admiral.html#handling-of-missing-values # nolint

vs <- convert_blanks_to_na(vs)

# Lookup tables ----
# Assign PARAMCD, PARAM, and PARAMN
param_lookup <- tibble::tribble(
  ~VSTESTCD, ~PARAMCD, ~PARAM, ~PARAMN,
  "WEIGHT", "WEIGHT", "Weight (kg)", 1,
  "HEIGHT", "HEIGHT", "Height (cm)", 2,
  "BMI", "BMI", "Body Mass Index(kg/m^2)", 3,
  "HDCIRC", "HDCIRC", "Head Circumference (cm)", 4
)
attr(param_lookup$VSTESTCD, "label") <- "Vital Signs Test Short Name"

# Get list of DM vars required for derivations
dm_vars <- exprs(SEX, BRTHDTC)
advs <- vs %>%
  # Join DM with VS (need BRTHDT for AAGECUR derivation)
  derive_vars_merged(
    dataset_add = dm,
    new_vars = dm_vars,
    by_vars = exprs(STUDYID, USUBJID)
  ) %>%
  mutate(BRTHDT = convert_dtc_to_dt(
    BRTHDTC,
    highest_imputation = "n",
    date_imputation = "first",
    min_dates = NULL,
    max_dates = NULL,
    preserve = FALSE
  )) %>%
  ## Calculate ADT ----
  derive_vars_dt(
    new_vars_prefix = "A",
    dtc = VSDTC
  ) %>%
  ## Calculate Current Analysis Age AAGECUR ----
  derive_vars_aage(
    start_date = BRTHDT,
    end_date = ADT,
    age_unit = "DAYS",
    type = "interval"
  ) %>%
  rename(
    AAGECUR = AAGE,
    AAGECURU = AAGEU
  )

advs <- advs %>%
  ## Add PARAMCD only - add PARAM etc later ----
  derive_vars_merged_lookup(
    dataset_add = param_lookup,
    new_vars = exprs(PARAMCD),
    by_vars = exprs(VSTESTCD)
  ) %>%
  ## Calculate AVAL and AVALC ----
  mutate(
    AVAL = VSSTRESN,
    AVALC = VSSTRESC
  )

## Get visit info ----
# See also the "Visit and Period Variables" vignette
# (https://pharmaverse.github.io/admiral/articles/visits_periods.html#visits)
windows <- tribble(
  ~AVISIT,     ~AVISITN,
  "Screening",        0,
  "Day 1",            1,
  "6 Months",         2,
  "12 Months",        3
)

advs <- advs %>%
  # Derive Timing
  mutate(
    AVISIT = case_when(
      str_detect(VISIT, "UNSCHED|RETRIEVAL|AMBUL") ~ NA_character_,
      !is.na(VISIT) ~ str_to_title(VISIT),
      TRUE ~ NA_character_
    )
  ) %>%
  derive_vars_merged(
    dataset_add = windows,
    by_vars = exprs(AVISIT)
  )

## Add PARAM/PARAMN ----
advs <- advs %>%
  # Derive PARAM and PARAMN
  derive_vars_merged(dataset_add = select(param_lookup, -VSTESTCD), by_vars = exprs(PARAMCD))

## Merge ADVS to the chosen Growth metadata as an input to meta_criteria ----
## Calculate z-scores/percentiles
## Calculate Weight for AGE z-score and Percentile ----
## Note: PARAMN needs to be updated.
advs_wgt_age <- derive_params_growth_age(
  advs,
  sex = SEX,
  age = AAGECUR,
  age_unit = AAGECURU,
  meta_criteria = weight_for_age,
  parameter = VSTESTCD == "WEIGHT",
  set_values_to_sds = exprs(
    PARAMCD = "WTASDS",
    PARAM = "Weight-for-age z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "WTAPCTL",
    PARAM = "Weight-for-age percentile"
  )
) %>%
  mutate(
    PARAMN = case_when(
      PARAMCD == "WTASDS" ~ 5,
      PARAMCD == "WTAPCTL" ~ 6,
      TRUE ~ PARAMN
    )
  ) %>%
  filter(PARAMCD %in% c("WTASDS", "WTAPCTL"))

## Calculate BMI for AGE z-score and Percentile ----
## Note: PARAMN needs to be updated for z-score and percentile in final dataset.
advs_bmi_age <- derive_params_growth_age(
  advs,
  sex = SEX,
  age = AAGECUR,
  age_unit = AAGECURU,
  meta_criteria = bmi_for_age,
  parameter = VSTESTCD == "BMI",
  set_values_to_sds = exprs(
    PARAMCD = "BMISDS",
    PARAM = "BMI-for-age z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "BMIPCTL",
    PARAM = "BMI-for-age percentile"
  )
) %>%
  mutate(
    PARAMN = case_when(
      PARAMCD == "BMISDS" ~ 7,
      PARAMCD == "BMIPCTL" ~ 8,
      TRUE ~ PARAMN
    )
  ) %>%
  filter(PARAMCD %in% c("BMISDS", "BMIPCTL"))

## Calculate Head Circumference for AGE z-score and Percentile ----
## Note: PARAMN needs to be updated for z-score and percentile in final dataset.
advs_hdc_age <- derive_params_growth_age(
  advs,
  sex = SEX,
  age = AAGECUR,
  age_unit = AAGECURU,
  meta_criteria = who_hc_for_age,
  parameter = VSTESTCD == "HDCIRC",
  set_values_to_sds = exprs(
    PARAMCD = "HDCSDS",
    PARAM = "HDC-for-age z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "HDCPCTL",
    PARAM = "HDC-for-age percentile"
  )
) %>%
  mutate(
    PARAMN = case_when(
      PARAMCD == "HDCSDS" ~ 9,
      PARAMCD == "HDCPCTL" ~ 10,
      TRUE ~ PARAMN
    )
  ) %>%
  filter(PARAMCD %in% c("HDCSDS", "HDCPCTL"))

## Calculate for Height/Length ----
## derive_params_growth_height function not yet ready?
## It needs to be updated once the function is ready to use.
## from issue #34
# advs_wgt_height <- derive_params_growth_height(
#   advs,
#   sex = SEX,
#   age = AAGECUR,
#   age_unit = AAGECURU,
#   meta_criteria = weight_for_age,
#   parameter = VSTESTCD == "HEIGHT",
#   measure = HEIGHT,
#   height_age = 730,
#   set_values_to_sds = exprs(
#     PARAMCD = "WGTHSDS",
#     PARAM = "Weight-for-length/height Z-Score"
#   ),
#   set_values_to_pctl = exprs(
#     PARAMCD = "WGTHPCTL",
#     PARAM = "Weight-for-length/height Percentile"
#   )
# )  %>%
# filter(PARAMCD %in% c("WGTHSDS", "WGTHPCTL"))

## Combine all derived parameters together
advs <- advs %>%
  rbind(advs_wgt_age, advs_bmi_age, advs_hdc_age)
# z-score and percentile for HEIGHT and LENGTH to be added once the
# `derive_params_growth_height` function is ready

## Get ASEQ ----
advs <- advs %>%
  # Calculate ASEQ
  derive_var_obs_number(
    new_var = ASEQ,
    by_vars = exprs(STUDYID, USUBJID),
    order = exprs(PARAMCD, ADT, AVISITN),
    check_type = "error"
  )

# Final Steps, Select final variables and Add labels
# This process will be based on your metadata, no example given for this reason
# ...

# Save output ----

# Change to whichever directory you want to save the dataset in
dir <- tools::R_user_dir("admiralpeds_templates_data", which = "cache")
if (!file.exists(dir)) {
  # Create the folder
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
}
save(advs, file = file.path(dir, "advs.rda"), compress = "bzip2")
