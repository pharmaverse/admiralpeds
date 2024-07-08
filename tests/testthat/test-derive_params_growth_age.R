# derive_params_growth_age ----

## Test 1: derive_params_growth_age works ----
test_that("derive_params_growth_age Test 1: derive_params_growth_age works", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "1001", "F", 24.5, "months", "WEIGHT", 10,
    "1002", "F", 25.49, "months", "WEIGHT", 11,
    "1003", "F", 25.51, "months", "WEIGHT", 12,
    "1004", "F", 27.5, "months", "WEIGHT", 13
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "F", 24.5, "months", 1, 2, 3,
    "F", 25.5, "months", 4, 5, 6,
    "F", 27, "months", 7, 8, 9,
    "F", 28, "months", 10, 11, 12
  )


  actual <- derive_params_growth_age(
    dataset = vs_data,
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = fake_meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WT2AGEZ"
    )
  )

  expected <- c(
    ((10 / 2)^1 - 1) / (1 * 3),
    ((11 / 5)^4 - 1) / (4 * 6),
    ((12 / 5)^4 - 1) / (4 * 6),
    ((13 / 8)^7 - 1) / (7 * 9)
  )

  expect_equal(
    expected,
    filter(actual, PARAMCD == "WT2AGEZ") %>% pull(AVAL)
  )
})
