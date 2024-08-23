# Dataset: adsl_peds
# Description: Create ADSL test ADaM dataset for pediatric studies

# Load libraries -----
library(pharmaversesdtm)
library(admiral)
library(dplyr)
library(lubridate)
library(stringr)

# Create a basic ADSL for pediatrics ----

# Read in input data ----
dm_peds <- pharmaversesdtm::dm_peds
ex <- ex

# Derivations ----

# impute start and end time of exposure to first and last respectively, do not impute date
ex_ext <- ex %>%
  derive_vars_dtm(
    dtc = EXSTDTC,
    new_vars_prefix = "EXST"
  ) %>%
  derive_vars_dtm(
    dtc = EXENDTC,
    new_vars_prefix = "EXEN",
    time_imputation = "last"
  )

adsl_peds <- dm_peds %>%
  ## derive treatment variables (TRT01P, TRT01A) ----
  mutate(TRT01P = ARM, TRT01A = ACTARM) %>%
  ## derive treatment start date (TRTSDTM) ----
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
      (EXDOSE == 0 &
        str_detect(EXTRT, "PLACEBO"))) &
      !is.na(EXSTDTM),
    new_vars = exprs(TRTSDTM = EXSTDTM, TRTSTMF = EXSTTMF),
    order = exprs(EXSTDTM, EXSEQ),
    mode = "first",
    by_vars = exprs(STUDYID, USUBJID)
  ) %>%
  ## derive treatment end date (TRTEDTM) ----
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
      (EXDOSE == 0 &
        str_detect(EXTRT, "PLACEBO"))) & !is.na(EXENDTM),
    new_vars = exprs(TRTEDTM = EXENDTM, TRTETMF = EXENTMF),
    order = exprs(EXENDTM, EXSEQ),
    mode = "last",
    by_vars = exprs(STUDYID, USUBJID)
  ) %>%
  ## Derive treatment end/start date TRTSDT/TRTEDT ----
  derive_vars_dtm_to_dt(source_vars = exprs(TRTSDTM, TRTEDTM)) %>%
  ## derive treatment duration (TRTDURD) ----
  derive_var_trtdurd()

# Variable labels ----
attr(adsl_peds$TRTSDTM, "label") <- "Datetime of First Exposure to Treatment"
attr(adsl_peds$TRTSTMF, "label") <- "Exposure Start Time Imputation Flag"
attr(adsl_peds$TRTEDTM, "label") <- "Datetime of Last Exposure to Treatment"
attr(adsl_peds$TRTETMF, "label") <- "Exposure End Time Imputation Flag"
attr(adsl_peds$TRTSDT, "label") <- "Date of First Exposure to Treatment"
attr(adsl_peds$TRTEDT, "label") <- "Date of Last Exposure to Treatment"
attr(adsl_peds$TRTDURD, "label") <- "Total Treatment Duration (Days)"

# Label dataset ----
attr(adsl_peds, "label") <- "Subject Level Analysis Dataset"

# Save dataset ----
usethis::use_data(adsl_peds, overwrite = TRUE)
