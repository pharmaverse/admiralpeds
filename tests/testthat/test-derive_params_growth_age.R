# derive_params_growth_age ----

## Test 1: derive_params_growth_age works ----
test_that("derive_params_growth_age Test 1: derive_params_growth_age works", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", 30, "days", "WEIGHT", 10,
    "1002", "F", 25, "months", "WEIGHT", 100,
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~AGE, ~AGEU, ~L, ~M, ~S,
    "M", 30, "days", 1, 2, 3,
    "M", 31, "days", 4, 5, 6,
    "F", 25, "months", 7, 8, 9,
    "F", 26, "months", 10, 11, 12
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
    ((100 / 8)^7 - 1) / (7 * 9)
  )

  expect_equal(
    expected,
    filter(actual, PARAMCD == "WT2AGEZ") %>% pull(AVAL)
  )
})
