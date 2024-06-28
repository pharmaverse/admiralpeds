# derive_params_growth_height----

## Test 1: derive_params_growth_height works ----
test_that("derive_params_growth_heightlength Test 1: derive_params_growth_height works", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", 30, "cm", "WEIGHT", 10,
    "1002", "F", 25, "cm", "WEIGHT", 100
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
    ((100 / 8)^7 - 1) / (7 * 9)
  )

  expect_equal(
    expected,
    filter(actual, PARAMCD == "WT2HTZ") %>% pull(AVAL)
  )
})

## Test 2: derive_params_growth_heightlength works for subjects that are under or over 2 years old
## between visits
test_that("derive_params_growth_heightlength Test 2: derive_params_growth_height works for subjects that are under or over 2 years old between visits", { # nolint
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN, ~AAGECUR,
    "1001", "M", 30, "cm", "WEIGHT", 10, 407,
    "1002", "F", 25, "cm", "WEIGHT", 100, 1276,
    "1003", "F", 26, "cm", "WEIGHT", 90, 760,
    "1004", "M", 31, "cm", "WEIGHT", 50, 729
  )

  fake_meta_under <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "M", 30, "cm", 1, 2, 3,
    "M", 31, "cm", 4, 5, 6,
    "M", 32, "cm", 6, 8, 10
  )

  fake_meta_over <- tibble::tribble(
    ~SEX, ~HEIGHT_LENGTH, ~HEIGHT_LENGTHU, ~L, ~M, ~S,
    "F", 25, "cm", 7, 8, 9,
    "F", 26, "cm", 10, 11, 12,
    "F", 27, "cm", 13, 14, 15
  )

  actual_sds_under <- derive_params_growth_height(
    dataset = filter(vs_data, AAGECUR < 730),
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = fake_meta_under,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WT2HTZ"
    )
  )

  actual_pctl_over <- derive_params_growth_height(
    dataset = filter(vs_data, AAGECUR >= 730.5),
    sex = SEX,
    height = HEIGHT,
    height_unit = HEIGHTU,
    meta_criteria = fake_meta_over,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_pctl = exprs(
      PARAMCD = "WGHPCTL",
      PARAM = "Weight-for-height percentile"
    )
  )

  expected_sds_under <- c(
    ((10 / 2)^1 - 1) / (1 * 3),
    ((50 / 5)^4 - 1) / (4 * 6)
  )

  expected_pctl_over <- c(
    pnorm(((100 / 8)^7 - 1) / (7 * 9)) * 100,
    pnorm(((90 / 11)^10 - 1) / (10 * 12)) * 100
  )

  expect_equal(
    expected_sds_under,
    filter(actual_sds_under, PARAMCD == "WT2HTZ") %>% pull(AVAL)
  )

  expect_equal(
    expected_pctl_over,
    filter(actual_pctl_over, PARAMCD == "WGHPCTL") %>% pull(AVAL)
  )
})

## Test 3: derive_params_growth_heightlength handles missing height/lengths
test_that("derive_params_growth_heightlength Test 3: derive_params_growth_height handles missing height/lengths", { # nolint
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", NA_real_, NA_character_, "WEIGHT", 10,
    "1002", "F", 25, "cm", "WEIGHT", NA_real_
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

  expect_true(is.na(actual))
  expect_true(is.na(actual1))
})

## Test 4: derive_params_growth_height returns expected error message
test_that("derive_params_growth_heightlength Test 4: derive_params_growth_height returns expected error message", { # nolint
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", NA_real_, NA_character_, "WEIGHT", 10
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
