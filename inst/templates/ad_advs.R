# Name: ADVS
#
# Label: Vital Signs Analysis Dataset including Anthropometric indicators for Pediatric Trials
#
# Input: adsl, vs
#        WHO_bmi_for_age_boys, WHO_bmi_for_age_girls, cdc_bmiage,
#        who_lgth_ht_for_age_boys, who_lgth_ht_for_age_girls, cdc_htage,
#        who_wt_for_age_boys, who_wt_for_age_girls, cdc_wtage,
#        who_hc_for_age_boys, who_hc_for_age_girls,
#        who_wt_for_lgth_boys, who_wt_for_lgth_girls

library(admiral)
library(admiralpeds)
library(dplyr)
library(lubridate)
library(stringr)

# Metadata ----

# Creation of the Growth by Age metadata combining WHO and CDC
# Load WHO and CDC metadata datasets
message("Please be aware that our default reference source in our metadata by Age is :
- for BMI, HEIGHT, and WEIGHT only: WHO for <2 yrs old children, and CDC for >=2 yrs old children.
The user could replace these metadata with their own chosen metadata")

## BMI for age ----
# Default reference sources: WHO for children <2 yrs old (< 730.5 days),
# and CDC for children >=2 yrs old (>= 730.5 days)
data(WHO_bmi_for_age_boys)
data(WHO_bmi_for_age_girls)
data(cdc_bmiage)

bmi_for_age <- who_bmi_for_age_boys %>%
  filter(Day < 730.5) %>%
  mutate(SEX = "M") %>%
  bind_rows(who_bmi_for_age_girls %>%
    filter(Day < 730.5) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  # AGEU is added in metadata, required for derive_params_growth_age()
  mutate(AGEU = "DAYS") %>%
  bind_rows(cdc_bmiage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "BMI"
    ) %>%
    # Keep patients >= 2 yrs till 20 yrs - Remove duplicates for 730 Days old which
    # must come from WHO metadata only
    filter(AGE >= 730.5 & AGE <= 7305)) %>%
  arrange(AGE, SEX)

## HEIGHT for age ----
# Default reference sources: WHO for children <2 yrs old (< 730.5 days),
# and CDC for children >=2 yrs old (>= 730.5 days)
data(who_lgth_ht_for_age_boys)
data(who_lgth_ht_for_age_girls)
data(cdc_htage)

height_for_age <- who_lgth_ht_for_age_boys %>%
  filter(Day < 730.5) %>%
  mutate(SEX = "M") %>%
  bind_rows(who_lgth_ht_for_age_girls %>%
    filter(Day < 730.5) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  # AGEU is added in metadata, required for derive_params_growth_age()
  mutate(AGEU = "DAYS") %>%
  bind_rows(cdc_htage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "HEIGHT"
    ) %>%
    # Keep patients >= 2 yrs till 20 yrs - Remove duplicates for 730 Days old which
    # must come from WHO metadata only
    filter(AGE >= 730.5 & AGE <= 7305)) %>%
  arrange(AGE, SEX)

## WEIGHT for age ----
# Default reference sources: WHO for children <2 yrs old (< 730.5 days),
# and CDC for children >=2 yrs old (>= 730.5 days)
data(who_wt_for_age_boys)
data(who_wt_for_age_girls)
data(cdc_wtage)

weight_for_age <- who_wt_for_age_boys %>%
  filter(Day < 730.5) %>%
  mutate(SEX = "M") %>%
  bind_rows(who_wt_for_age_girls %>%
    filter(Day < 730.5) %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  # AGEU is added in metadata, required for derive_params_growth_age()
  mutate(AGEU = "DAYS") %>%
  bind_rows(cdc_wtage %>%
    mutate(
      SEX = case_when(
        SEX == 1 ~ "M",
        SEX == 2 ~ "F",
        TRUE ~ NA_character_
      ),
      # Ensure first that Age unit is "DAYS"
      AGE = round(AGE * 30.4375),
      AGEU = "DAYS"
    ) %>%
    # Interpolate the AGE by SEX
    derive_interp_records(
      by_vars = exprs(SEX),
      parameter = "WEIGHT"
    ) %>%
    # Keep patients >= 2 yrs till 20 yrs - Remove duplicates for 730 Days old which
    # must come from WHO metadata only
    filter(AGE >= 730.5 & AGE <= 7305)) %>%
  arrange(AGE, SEX)

## WHO - HEAD CIRCUMFERENCE for age ----
# Default reference sources: WHO for children up to 5 yrs old
data(who_hc_for_age_boys)
data(who_hc_for_age_girls)

who_hc_for_age <- who_hc_for_age_boys %>%
  mutate(SEX = "M") %>%
  bind_rows(who_hc_for_age_girls %>%
    mutate(SEX = "F")) %>%
  rename(AGE = Day) %>%
  # AGEU is added in metadata, required for derive_params_growth_age()
  mutate(AGEU = "DAYS") %>%
  arrange(AGE, SEX)

## WHO - WEIGHT for LENGTH ----
# Default reference sources: WHO for children <2 yrs old (< 730.5 days)
data(who_wt_for_lgth_boys)
data(who_wt_for_lgth_girls)

who_wt_for_lgth <- who_wt_for_lgth_boys %>%
  mutate(SEX = "M") %>%
  bind_rows(who_wt_for_lgth_girls %>%
    mutate(SEX = "F")) %>%
  mutate(HEIGHT_LENGTHU = "cm") %>%
  rename(HEIGHT_LENGTH = Length)

# Load source datasets ----

# Use e.g. `haven::read_sas()` to read in .sas7bdat, or other suitable functions
# as needed and assign to the variables below.
# For illustration purposes read in admiral test data

data("vs_peds")
data("adsl_peds")

vs <- vs_peds
adsl <- adsl_peds %>% select(-DOMAIN)

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
  "HDCIRC", "HDCIRC", "Head Circumference (cm)", 4,
  NA_character_, "WGTASDS", "Weight-for-age z-score", 5,
  NA_character_, "WGTAPCTL", "Weight-for-age percentile", 6,
  NA_character_, "HGTSDS", "Height-for-age z-score", 7,
  NA_character_, "HGTPCTL", "Height-for-age percentile", 8,
  NA_character_, "BMISDS", "BMI-for-age z-score", 9,
  NA_character_, "BMIPCTL", "BMI-for-age percentile", 10,
  NA_character_, "HDCSDS", "Head Circumference-for-age z-score", 11,
  NA_character_, "HDCPCTL", "Head Circumference-for-age percentile", 12,
  NA_character_, "WGTHSDS", "Weight-for-length/height Z-Score", 13,
  NA_character_, "WGTHPCTL", "Weight-for-length/height Percentile", 14
)
attr(param_lookup$VSTESTCD, "label") <- "Vital Signs Test Short Name"

# Derivations ----

# Get list of ADSL vars required for derivations
adsl_vars <- exprs(SEX, BRTHDTC, TRTSDT, TRTEDT, TRT01A, TRT01P)

advs <- vs %>%
  # Join ADSL with VS (need BRTHDT for AAGECUR derivation)
  derive_vars_merged(
    dataset_add = adsl,
    new_vars = adsl_vars,
    by_vars = get_admiral_option("subject_keys")
  ) %>%
  ## Calculate BRTHDT ----
  derive_vars_dt(
    new_vars_prefix = "BRTH",
    dtc = BRTHDTC
  ) %>%
  ## Calculate ADT, ADY ----
  derive_vars_dt(
    new_vars_prefix = "A",
    dtc = VSDTC
  ) %>%
  derive_vars_dy(reference_date = TRTSDT, source_vars = exprs(ADT)) %>%
  ## Calculate Current Analysis Age AAGECUR and unit AAGECURU ----
  derive_vars_duration(
    new_var = AAGECUR,
    new_var_unit = AAGECURU,
    start_date = BRTHDT,
    end_date = ADT
  )

advs <- advs %>%
  ## Add PARAMCD only - add PARAM etc later ----
  derive_vars_merged_lookup(
    dataset_add = param_lookup %>% filter(!is.na(VSTESTCD)),
    new_vars = exprs(PARAMCD),
    by_vars = exprs(VSTESTCD)
  ) %>%
  ## Calculate AVAL ----
  mutate(AVAL = VSSTRESN)

## Get visit info ----
# See also the "Visit and Period Variables" vignette
# (https://pharmaverse.github.io/admiral/articles/visits_periods.html#visits)
advs <- advs %>%
  # Derive Timing
  mutate(
    ATPTN = VSTPTNUM,
    ATPT = VSTPT,
    AVISIT = case_when(
      str_detect(VISIT, "UNSCHED|RETRIEVAL|AMBUL") ~ NA_character_,
      !is.na(VISIT) ~ str_to_title(VISIT),
      TRUE ~ NA_character_
    ),
    AVISITN = as.numeric(case_when(
      VISIT == "SCREENING 1" ~ "-1",
      VISIT == "BASELINE" ~ "0",
      str_detect(VISIT, "WEEK") ~ str_trim(str_replace(VISIT, "WEEK", "")),
      TRUE ~ NA_character_
    ))
  )

## Derive Current HEIGHT/LENGTH at each time point Temporary variable ----
advs <- advs %>%
  derive_vars_merged(
    dataset_add = advs,
    by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
    filter_add = PARAMCD == "HEIGHT" & toupper(VSSTRESU) == "CM",
    new_vars = exprs(HGTTMP = AVAL, HGTTMPU = VSSTRESU)
  )

## Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts ----
## For Height/Weight/BMI/Head Circumference by Age ----
advs_age <- advs %>%
  derive_params_growth_age(
    by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
    sex = SEX,
    age = AAGECUR,
    age_unit = AAGECURU,
    meta_criteria = weight_for_age,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = AVAL,
    set_values_to_sds = exprs(
      PARAMCD = "WGTASDS",
      PARAM = "Weight-for-age z-score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WGTAPCTL",
      PARAM = "Weight-for-age percentile"
    )
  ) %>%
  derive_params_growth_age(
    by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
    sex = SEX,
    age = AAGECUR,
    age_unit = AAGECURU,
    meta_criteria = height_for_age,
    parameter = VSTESTCD == "HEIGHT",
    analysis_var = AVAL,
    set_values_to_sds = exprs(
      PARAMCD = "HGTSDS",
      PARAM = "Height-for-age z-score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "HGTPCTL",
      PARAM = "Height-for-age percentile"
    )
  ) %>%
  derive_params_growth_age(
    by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
    sex = SEX,
    age = AAGECUR,
    age_unit = AAGECURU,
    meta_criteria = bmi_for_age,
    parameter = VSTESTCD == "BMI",
    analysis_var = AVAL,
    bmi_cdc_correction = TRUE,
    set_values_to_sds = exprs(
      PARAMCD = "BMISDS",
      PARAM = "BMI-for-age z-score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "BMIPCTL",
      PARAM = "BMI-for-age percentile"
    )
  ) %>%
  derive_params_growth_age(
    by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
    sex = SEX,
    age = AAGECUR,
    age_unit = AAGECURU,
    meta_criteria = who_hc_for_age,
    parameter = VSTESTCD == "HDCIRC",
    analysis_var = AVAL,
    set_values_to_sds = exprs(
      PARAMCD = "HDCSDS",
      PARAM = "HDC-for-age z-score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "HDCPCTL",
      PARAM = "HDC-for-age percentile"
    )
  )

## Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length) for Weight by Height/Length based on Standard Growth Charts ----
message("To derive height/length parameters, below function assumes that the
values in your height parameter input data are for body length - therefore
it uses WHO weight-for-length metadata, but this depends on your CRF guidelines.")

# Only derive for patients with current age < 2 years as we use body length
advs_ht_lgth <- advs %>%
  restrict_derivation(
    derivation = derive_params_growth_height,
    args = params(
      by_vars = c(get_admiral_option("subject_keys"), exprs(AVISIT)),
      sex = SEX,
      height = HGTTMP,
      height_unit = HGTTMPU,
      meta_criteria = who_wt_for_lgth,
      parameter = VSTESTCD == "WEIGHT",
      analysis_var = AVAL,
      set_values_to_sds = exprs(
        PARAMCD = "WGTHSDS",
        PARAM = "Weight-for-length/height Z-Score"
      ),
      set_values_to_pctl = exprs(
        PARAMCD = "WGTHPCTL",
        PARAM = "Weight-for-length/height Percentile"
      )
    ),
    filter = AAGECUR < 730.5
  )

# Combine the records for Weight by Height/Length
advs <- advs_age %>%
  bind_rows(advs_ht_lgth %>% filter(PARAMCD %in% c("WGTHSDS", "WGTHPCTL")))

## Add PARAM/PARAMN ----
advs <- advs %>%
  select(-PARAM) %>%
  # Derive PARAM and PARAMN
  derive_vars_merged(dataset_add = select(param_lookup, -VSTESTCD), by_vars = exprs(PARAMCD))

## Derive baseline flags ----
advs <- advs %>%
  # Calculate ABLFL
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      by_vars = c(get_admiral_option("subject_keys"), exprs(PARAMCD)),
      order = exprs(ADT, AVISITN, VSSEQ),
      new_var = ABLFL,
      mode = "last"
    ),
    filter = (!is.na(AVAL) & ADT <= TRTSDT)
  )

## Derive baseline information ----
advs <- advs %>%
  # Calculate BASE
  derive_var_base(
    by_vars = c(get_admiral_option("subject_keys"), exprs(PARAMCD)),
    source_var = AVAL,
    new_var = BASE
  ) %>%
  # Calculate CHG
  derive_var_chg() %>%
  # Calculate PCHG
  derive_var_pchg()

## Calculate ONTRTFL ----
advs <- advs %>%
  derive_var_ontrtfl(
    start_date = ADT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    filter_pre_timepoint = AVISIT == "Baseline"
  )

## ANL01FL: Flag last result within an AVISIT and ATPT for post-baseline records ----
advs <- advs %>%
  restrict_derivation(
    derivation = derive_var_extreme_flag,
    args = params(
      new_var = ANL01FL,
      by_vars = c(get_admiral_option("subject_keys"), exprs(PARAMCD, AVISIT, ATPT)),
      order = exprs(ADT, AVAL),
      mode = "last"
    ),
    filter = !is.na(AVISITN) & (ONTRTFL == "Y" | ABLFL == "Y")
  )

# Add all ADSL variables
advs <- advs %>%
  derive_vars_merged(
    dataset_add = select(adsl, !!!negate_vars(adsl_vars)),
    by_vars = get_admiral_option("subject_keys")
  )

## Get ASEQ ----
advs <- advs %>%
  # Calculate ASEQ
  derive_var_obs_number(
    new_var = ASEQ,
    by_vars = get_admiral_option("subject_keys"),
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
