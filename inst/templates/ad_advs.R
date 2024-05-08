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
library(pharmaversesdtm) # Contains example datasets from the CDISC pilot project
library(dplyr)
library(lubridate)
library(stringr)

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
# data("admiral_adsl")

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
  ## Calculate Current Age AAGECUR
  derive_vars_aage(
    start_date = BRTHDT,
    end_date = ADT,
    age_unit = "DAYS",
    type = "interval"
  )
