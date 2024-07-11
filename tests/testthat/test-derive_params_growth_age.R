# derive_params_growth_age ----

## Test 1: derive_params_growth_age works ----
test_that("derive_params_growth_age Test 1: derive_params_growth_age works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~VISIT, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "STUDY", "1001", "1","F", 24.5, "months", "WEIGHT", 10,
    "STUDY", "1002", "1", "F", 25.49, "months", "WEIGHT", 11,
    "STUDY", "1002", "2", "F", 26.7, "months", "WEIGHT", 11.5,
    "STUDY", "1003", "1", "F", 25.51, "months", "WEIGHT", 12,
    "STUDY", "1004", "1", "F", 27.5, "months", "WEIGHT", 13
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
    by_vars = exprs(STUDYID, USUBJID, VISIT),
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
    ((11.5 / 8)^7 - 1) / (7 * 9),
    ((12 / 5)^4 - 1) / (4 * 6),
    ((13 / 8)^7 - 1) / (7 * 9)
  )

  expect_equal(
    filter(actual, PARAMCD == "WT2AGEZ") %>% pull(AVAL),
    expected
  )
})
