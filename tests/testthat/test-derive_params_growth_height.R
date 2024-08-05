# derive_params_growth_height ----

## Test 1: derive_params_growth_height works ----
test_that("derive_params_growth_height Test 1: derive_params_growth_height works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "STUDY", "1001", "Baseline", "M", 30, "cm", "WEIGHT", 10,
    "STUDY", "1002", "Baseline", "F", 25.1, "cm", "WEIGHT", 100,
    "STUDY", "1002", "Visit 1", "F", 26.4, "cm", "WEIGHT", 110,
    "STUDY", "1003", "Baseline", "F", 25.5, "cm", "WEIGHT", 100,
    "STUDY", "1004", "Baseline", "F", 25.6, "cm", "WEIGHT", 100,
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 30, "cm", 1, 2, 3,
    "M", 31, "cm", 4, 5, 6,
    "F", 25, "cm", 7, 8, 9,
    "F", 26, "cm", 10, 11, 12
  )

  actual <- derive_params_growth_height(
    dataset = vs_data,
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = fake_meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WT2HTZ"
    )
  )

  expected <- c(
    ((10 / 2)^1 - 1) / (1 * 3),
    ((100 / 8)^7 - 1) / (7 * 9),
    ((110 / 11)^10 - 1) / (10 * 12),
    ((100 / 8)^7 - 1) / (7 * 9),
    ((100 / 11)^10 - 1) / (10 * 12)
  )

  expect_equal(
    expected,
    filter(actual, PARAMCD == "WT2HTZ") %>% pull(AVAL)
  )
})

## Test 2: derive_params_growth_height derives correct z-scores in presence of outlying height/lengths # nolint
test_that("derive_params_growth_height Test 2: derives correct z-scores/percentiles in presence of outlying height/lengths", { # nolint
  vs_data <- tibble::tribble(
    ~USUBJID, ~VISIT, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "Baseline", "M", 45, "cm", "WEIGHT", 1.1,
    "1002", "Baseline", "F", 45, "cm", "WEIGHT", 7.5,
    "1003", "Baseline", "M", 65, "cm", "WEIGHT", 5.44,
    "1004", "Baseline", "F", 65, "cm", "WEIGHT", 10.73
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 45, "cm", -0.352, 2.44, 0.0918,
    "M", 45.1, "cm", -0.352, 2.46, 0.0918,
    "F", 45, "cm", -0.383, 2.46, 0.0903,
    "F", 45.1, "cm", -0.383, 2.48, 0.0903,
    "M", 65, "cm", -0.352, 7.43, 0.0822,
    "M", 65.1, "cm", -0.352, 7.46, 0.0822,
    "F", 65, "cm", -0.383, 7.24, 0.0911,
    "F", 65.1, "cm", -0.383, 7.26, 0.0911
  )

  out <- derive_params_growth_height(
    dataset = vs_data,
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = fake_meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WT2HTZ"
    )
  )

  actual <- filter(out, PARAMCD == "WT2HTZ") %>%
    mutate(AVAL = round(AVAL, 2)) %>%
    pull(AVAL)

  expect_equal(actual, c(-10.02, 10.05, -4.01, 4.01))
})

## Test 3: derive_params_growth_height handles missing height/lengths
test_that("derive_params_growth_height Test 3: handles missing height/lengths", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~VISIT, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "Baseline", "M", NA_real_, NA_character_, "WEIGHT", 10,
    "1002", "Baseline", "F", 25, "cm", "WEIGHT", NA_real_
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 30, "cm", 1, 2, 3,
    "M", 31, "cm", 4, 5, 6,
    "F", 25, "cm", 7, 8, 9,
    "F", 26, "cm", 10, 11, 12
  )

  out <- derive_params_growth_height(
    dataset = vs_data,
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = fake_meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    who_correction = TRUE,
    set_values_to_sds = exprs(
      PARAMCD = "WT2HTZ"
    )
  )

  actual <- out %>%
    filter(PARAMCD == "WT2HTZ") %>%
    pull(AVAL)

  actual1 <- out %>%
    filter(USUBJID == "1001") %>%
    pull(HEIGHT)

  expect_true(all(is.na(actual)))
  expect_true(all(is.na(actual1)))
})

## Test 4: derive_params_growth_height returns expected error message
test_that("derive_params_growth_height Test 4: returns expected error message", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~VISIT, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "Baseline", "M", NA_real_, NA_character_, "WEIGHT", 10
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 30, "cm", 1, 2, 3,
    "M", 31, "cm", 4, 5, 6
  )

  expect_error(
    derive_params_growth_height(
      dataset = vs_data,
      sex = SEX,
      height = HEIGHT,
      height_unit = HEIGHTU,
      meta_criteria = fake_meta,
      parameter = VSTESTCD == "WEIGHT",
      analysis_var = VSSTRESN
    ),
    "One of `set_values_to_sds`/`set_values_to_pctl` has to be specified."
  )
})

## Test 6: WHO outlier adjustment works ----
test_that("derive_params_growth_height Test 6: WHO outlier adjustment works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "Study", "1001", "Screening", "M", 50, "cm", "WEIGHT", 5,
    "Study", "1002", "Screening", "M", 50, "cm", "WEIGHT", 2
  )

  meta <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 50.0, "cm", -0.3521, 3.3278, 0.08890
  )

  actual <- derive_params_growth_height(
    dataset = vs_data,
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    who_correction = TRUE,
    set_values_to_sds = exprs(
      PARAMCD = "WGHSDS",
      PARAM = "Weight-for-height Z-Score"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WGHPCTL",
      PARAM = "Weight-for-height percentile"
    )
  )

  sd2pos <- (3.3278 * (1 + 2 * -0.3521 * 0.08890)^(1 / -0.3521))
  sd3pos <- (3.3278 * (1 + 3 * -0.3521 * 0.08890)^(1 / -0.3521))
  sd2neg <- (3.3278 * (1 - 2 * -0.3521 * 0.08890)^(1 / -0.3521))
  sd3neg <- (3.3278 * (1 - 3 * -0.3521 * 0.08890)^(1 / -0.3521))
  expected_sds <- c(
    3 + (5 - sd3pos) / (sd3pos - sd2pos),
    -3 - abs((2 - sd3neg) / (sd2neg - sd3neg))
  )
  expected_pctl <- pnorm(expected_sds) * 100

  expect_equal(
    filter(actual, PARAMCD %in% c("WGHSDS", "WGHPCTL")) %>% pull(AVAL),
    c(expected_sds, expected_pctl),
    tolerance = 0.001
  )
})
