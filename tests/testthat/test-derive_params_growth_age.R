# derive_params_growth_age ----
## Test 1: Weight SDS and percentile works (P3, P97) ----
test_that("derive_params_growth_age Test 1: Weight SDS and percentile works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 30, "days", "WEIGHT", 5.8,
    "Study", "1002", "Cycle 1 Day 1", "F", 517, "days", "WEIGHT", 8.8,
    "Study", "1002", "Cycle 2 Day 1", "F", 547, "days", "WEIGHT", 9.8,
    "Study", "1003", "Cycle 10 Day 1", "M", 870, "days", "WEIGHT", 11.3,
    "Study", "1004", "Screening", "F", 2161, "days", "WEIGHT", 27.1,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 30, "days", 0.2303, 4.4525, 0.13413,
    "F", 517, "days", -0.2561, 10.0196, 0.12305,
    "F", 547, "days", -0.2635, 10.2255, 0.12309,
    "M", 870, "days", -0.3310282164, 13.30298997, 0.1088506239,
    "F", 2161, "days", -1.327138401, 20.03756384, 0.1484897955,
  )
  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    who_correction = TRUE,
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WTAPCTL"
    )
  )

  vs_data_age <- vs_data %>%
    mutate(
      AGECUR_c = case_when(
        AGEU == "days" ~ AGECUR,
        AGEU == "months" ~ round(AGECUR * 30.4375)
      ),
      AGEU_c = "days"
    ) %>%
    mutate(AGE = AGECUR_c, AGEU = AGEU_c) %>%
    select(-ends_with("_c"), -AGECUR)

  vs_data_meta <- vs_data_age %>% dplyr::inner_join(meta, by = c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL) * 100)
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    filter(actual, PARAMCD %in% c("WTASDS", "WTAPCTL")) %>% pull(AVAL),
    expected
  )
})

## Test 2: Height SDS and percentile works (P50, P97) ----
test_that("derive_params_growth_age Test 2: Height SDS and percentile works (P50, P97)", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 61, "days", "HEIGHT", 58,
    "Study", "1002", "Cycle 1 Day 1", "F", 578, "days", "HEIGHT", 87,
    "Study", "1003", "Cycle 10 Day 1", "M", 910, "days", "HEIGHT", 92,
    "Study", "1004", "Screening", "F", 4840, "days", "HEIGHT", 170,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 61, "days", 1, 58.4384, 0.03423,
    "F", 578, "days", 1, 81.6752, 0.03619,
    "M", 910, "days", 0.2418532658, 90.91041609, 0.0409575918,
    "F", 4840, "days", 1.172254081, 158.2058471, 0.04304528616,
  )


  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "HEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "HTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "HTAPCTL"
    )
  )

  vs_data_age <- vs_data %>%
    mutate(
      AGECUR_c = case_when(
        AGEU == "days" ~ AGECUR,
        AGEU == "months" ~ round(AGECUR * 30.4375)
      ),
      AGEU_c = "days"
    ) %>%
    mutate(AGE = AGECUR_c, AGEU = AGEU_c) %>%
    select(-ends_with("_c"), -AGECUR)

  vs_data_meta <- vs_data_age %>% dplyr::inner_join(meta, by = c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL) * 100)
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    filter(actual, PARAMCD %in% c("HTASDS", "HTAPCTL")) %>% pull(AVAL),
    expected
  )
})

## Test 3: BMI SDS and percentile works (Z-score of -2, 0, 2, 5) ----
test_that("derive_params_growth_age Test 3: BMI SDS and percentile works (Z-score of -2, 0, 2, 5)", { # nolint
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 61, "days", "BMI", 58,
    "Study", "1002", "Cycle 1 Day 1", "F", 578, "days", "BMI", 87,
    "Study", "1003", "Cycle 10 Day 1", "M", 2146, "days", "BMI", 13.5,
    "Study", "1004", "Screening", "F", 2694, "days", "BMI", 21.9,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 61, "days", 0.1113, 16.3231, 0.08676,
    "F", 578, "days", -0.5197, 15.6524, 0.08631,
    "M", 2146, "days", -3.15039004, 15.37745304, 0.081706249,
    "F", 2694, "days", -2.819657704, 15.56444426, 0.109308364,
  )

  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "BMI",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "BMIASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "BMIAPCTL"
    )
  )

  vs_data_age <- vs_data %>%
    mutate(
      AGECUR_c = case_when(
        AGEU == "days" ~ AGECUR,
        AGEU == "months" ~ round(AGECUR * 30.4375)
      ),
      AGEU_c = "days"
    ) %>%
    mutate(AGE = AGECUR_c, AGEU = AGEU_c) %>%
    select(-ends_with("_c"), -AGECUR)

  vs_data_meta <- vs_data_age %>% dplyr::inner_join(meta, by = c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL) * 100)
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    filter(actual, PARAMCD %in% c("BMIASDS", "BMIAPCTL")) %>% pull(AVAL),
    expected
  )
})



## Test 4: Head circumference derivation works ----
test_that("derive_params_growth_age Test 4: Head circumference SDS and percentile works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 61, "days", "HEADC", 39,
    "Study", "1002", "Cycle 1 Day 1", "F", 1157, "days", "HEADC", 50,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 61, "days", 1, 39.1349, 0.02997,
    "F", 1157, "days", 1, 48.6732, 0.02906,
  )

  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "HEADC",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "HDCASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "HDCAPCTL"
    )
  )

  vs_data_age <- vs_data %>%
    mutate(
      AGECUR_c = case_when(
        AGEU == "days" ~ AGECUR,
        AGEU == "months" ~ round(AGECUR * 30.4375)
      ),
      AGEU_c = "days"
    ) %>%
    mutate(AGE = AGECUR_c, AGEU = AGEU_c) %>%
    select(-ends_with("_c"), -AGECUR)

  vs_data_meta <- vs_data_age %>% dplyr::inner_join(meta, by = c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL) * 100)
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)

  expect_equal(
    filter(actual, PARAMCD %in% c("HDCASDS", "HDCAPCTL")) %>% pull(AVAL),
    expected
  )
})

## Test 5: Extreme BMI value derivation works ----
test_that("derive_params_growth_age Test 5: Extreme BMI value derivation works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 1233, "days", "BMI", 19,
    "Study", "1002", "Screening", "M", 1233, "days", "BMI", 100,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S, ~P95, ~Sigma,
    "M", 1233, "days", -1.401671596, 15.85824093, 0.071691278, 18.0399, 2.022795,
  )

  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "BMI",
    bmi_cdc_correction = TRUE,
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "BMIASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "BMIAPCTL"
    )
  )

  vs_data_age <- vs_data %>%
    mutate(
      AGECUR_c = case_when(
        AGEU == "days" ~ AGECUR,
        AGEU == "months" ~ round(AGECUR * 30.4375)
      ),
      AGEU_c = "days"
    ) %>%
    mutate(AGE = AGECUR_c, AGEU = AGEU_c) %>%
    select(-ends_with("_c"), -AGECUR)

  vs_data_meta <- vs_data_age %>% dplyr::inner_join(meta, by = c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL))
  tmppctl <- vs_pctl %>%
    mutate(tmpPCTL = AVAL * 100) %>%
    select(USUBJID, tmpPCTL)
  tmpexpected <- vs_sds %>%
    mutate(tmpSDS = AVAL) %>%
    dplyr::inner_join(tmppctl, by = "USUBJID") %>%
    mutate(
      PCTL = ifelse(tmpPCTL / 100 > 0.95, 90 + 10 * pnorm((VSSTRESN - P95) / Sigma), tmpPCTL),
      SDS = ifelse(tmpPCTL / 100 > 0.95, ifelse(tmpPCTL / 100 == 1, 8.21, qnorm(PCTL / 100)), tmpSDS) # nolint
    ) %>%
    select(STUDYID, USUBJID, VISIT, SEX, AGE, AGEU, VSTESTCD, VSSTRESN, SDS, PCTL)
  expected <- tmpexpected %>%
    mutate(AVAL = SDS) %>%
    rbind(
      tmpexpected %>%
        mutate(AVAL = PCTL)
    ) %>%
    pull(AVAL)

  expect_equal(
    filter(actual, PARAMCD %in% c("BMIASDS", "BMIAPCTL")) %>% pull(AVAL),
    expected
  )
})


## Test 6: Test out of bound ages ----
test_that("derive_params_growth_age Test 6: Test out of bound ages", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 250, "months", "WEIGHT", 58,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S, ~P95, ~Sigma
  )

  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    who_correction = TRUE,
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WTAPCTL"
    )
  )

  expected <- as.numeric()

  expect_equal(
    filter(actual, PARAMCD %in% c("WTASDS", "WTAPCTL")) %>% pull(AVAL),
    expected
  )
})

## Test 7: Test missing anthropocentric values ----
test_that("derive_params_growth_age Test 7: Test missing anthropocentric values", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 210, "months", "WEIGHT", NA,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 210, "days", -1.0354022, 66.10749, 0.1634387
  )

  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    who_correction = TRUE,
    set_values_to_sds = exprs(
      PARAMCD = "WTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WTAPCTL"
    )
  )

  expected <- as.numeric()

  expect_equal(
    filter(actual, PARAMCD %in% c("WTASDS", "WTAPCTL")) %>% pull(AVAL),
    expected
  )
})

## Test 8: Age unit/Metadata in months works ----
test_that("derive_params_growth_age Test 8: Age unit/Metadata in months works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Cycle 10 Day 1", "M", 28.6, "months", "WEIGHT", 11.3,
    "Study", "1002", "Screening", "F", 71, "months", "WEIGHT", 27.1,
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 28.5, "months", -0.3277294, 13.28990, 0.1088257,
    "F", 70.5, "months", -1.327138401, 20.03756384, 0.1484897955,
  )
  actual <- derive_params_growth_age(
    dataset = vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    who_correction = TRUE,
    set_values_to_sds = exprs(
      PARAMCD = "WTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WTAPCTL"
    )
  )

  vs_data_meta <- vs_data %>%
    dplyr::full_join(meta, by = c("SEX", "AGEU")) %>%
    mutate(tmpAgeDiff = abs(AGECUR - AGE)) %>%
    group_by(STUDYID, USUBJID, VISIT, SEX, AGECUR, AGEU, VSTESTCD, VSSTRESN) %>%
    arrange(STUDYID, USUBJID, tmpAgeDiff) %>%
    slice(1)

  vs_sds <- vs_data_meta %>% mutate(AVAL = (((VSSTRESN / M)^L) - 1) / (L * S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL) * 100)
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    filter(actual, PARAMCD %in% c("WTASDS", "WTAPCTL")) %>% pull(AVAL),
    expected
  )
})


## Test 8: WHO outlier adjustment works ----
test_that("derive_params_growth_age Test 8: WHO outlier adjustment works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 289, "days", "WEIGHT", 20.4,
    "Study", "1002", "Screening", "M", 289, "days", "WEIGHT", 2.4
  )

  meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 289, "days", 0.0868, 9.0342, 0.10885
  )

  actual <- derive_params_growth_age(
    vs_data,
    by_vars = exprs(STUDYID, USUBJID, VISIT),
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    who_correction = TRUE,
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WGASDS",
      PARAM = "Weight-for-age z-score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WGAPCTL",
      PARAM = "Weight-for-age percentile"
    )
  )

  sd2pos <- (9.0342 * (1 + 2 * 0.0868 * 0.10885)^(1 / 0.0868))
  sd3pos <- (9.0342 * (1 + 3 * 0.0868 * 0.10885)^(1 / 0.0868))
  sd2neg <- (9.0342 * (1 - 2 * 0.0868 * 0.10885)^(1 / 0.0868))
  sd3neg <- (9.0342 * (1 - 3 * 0.0868 * 0.10885)^(1 / 0.0868))
  expected_sds <- c(
    3 + (20.4 - sd3pos) / (sd3pos - sd2pos),
    -3 + (2.4 - sd3neg) / (sd2neg - sd3neg)
  )
  expected_pctl <- pnorm(expected_sds) * 100

  expect_equal(
    filter(actual, PARAMCD %in% c("WGASDS", "WGAPCTL")) %>% pull(AVAL),
    c(expected_sds, expected_pctl)
  )
})
