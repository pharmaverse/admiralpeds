# Dataset: dm_ped
# Description: Create DM test SDTM dataset for pediatric studies

# Load libraries -----
library(dplyr)
library(purrr)

# Create DM for pediatric  ----

## Read in original data ----
data("dm")

## Make dm_ped dataset
dm_peds <- tibble::tribble(
  ~USUBJID, ~BRTHDTC, ~AGE, ~AGEU, ~RFSTDTC, ~RFENDTC, ~SEX,
  "PEDS-1001", "2022-09-10", 0, "YEARS", "2022-09-30", "2023-12-30", "M",
  "PEDS-1002", "2022-06-10", 0, "YEARS", "2022-09-12", "2024-02-15", "F",
  "PEDS-1003", "2022-07-10", 0, "YEARS", "2023-01-08", "2023-10-25", "F",
  "PEDS-1005", "2019-07-10", 2, "YEARS", "2021-07-09", "2024-01-13", "F",
  "PEDS-1006", "2021-08-10", 2, "YEARS", "2023-08-11", "2024-02-15", "F",
  "PEDS-1010", "2019", 2, "YEARS", "2021-07-09", "2024-02-15", "M",
  "PEDS-1012", "2016-10-10", 6, "YEARS", "2023-06-23", "2024-02-15", "M",
  "PEDS-1013", "2012-01-10", 12, "YEARS", "2024-01-10", "2024-02-15", "F",
  "PEDS-1009", "2005-10-25", 20, "YEARS", "2024-01-12", "2024-02-15", "M",
) %>%
  mutate(
    STUDYID = "PEDS SAMPLE STUDY",
    DOMAIN = "DM",
    SUBJID = substr(USUBJID, 5, 9),
    SITEID = substr(USUBJID, 5, 7),
    RFXSTDTC = format(admiral::convert_dtc_to_dt(RFSTDTC) + 21, "%Y-%m-%d"),
    RFXENDTC = format(admiral::convert_dtc_to_dt(RFENDTC) + 62, "%Y-%m-%d"),
    RFICDTC = RFSTDTC,
    RFPENDTC = RFENDTC,
    DTHDTC = NA_character_,
    DTHFL = NA_character_,
    RACE = case_when(
      grepl("100", USUBJID) ~ "WHITE",
      grepl("101", USUBJID) ~ "BLACK OR AFRICAN AMERICAN",
      TRUE ~ NA_character_
    ),
    ETHNIC = case_when(
      grepl("100", USUBJID) ~ "NOT HISPANIC OR LATINO",
      grepl("101", USUBJID) ~ "NOT HISPANIC OR LATINO",
      TRUE ~ NA_character_
    ),
    COUNTRY = case_when(
      grepl("100", USUBJID) ~ "USA",
      grepl("101", USUBJID) ~ "ITA",
      TRUE ~ NA_character_
    ),
    ARMCD = "A",
    ARM = "Arm A",
    ACTARM = ARM,
    ACTARMCD = ARMCD,
    DMDTC = NA_character_,
    DMDY = NA_integer_
  ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, SUBJID, RFSTDTC, RFENDTC, RFXSTDTC, RFXENDTC,
    RFICDTC, RFPENDTC, DTHDTC, DTHFL, SITEID, BRTHDTC, AGE, AGEU,
    SEX, RACE, ETHNIC, ARMCD, ARM, ACTARMCD, ACTARM, COUNTRY, DMDTC, DMDY
  )

# get common column names
common_cols <- intersect(names(dm_peds), names(dm))
# Apply label
assign_label <- function(x) {
  attr(dm_peds[[x]], "label") <<- attr(dm[[x]], "label")
}
map( common_cols,assign_label)
attr(dm_peds$BRTHDTC, "label") <- "Date/Time of Birth"

# Label dataset ----
attr(dm_peds, "label") <- "Demographics"

# Save dataset ----
usethis::use_data(dm_peds, overwrite = TRUE)
