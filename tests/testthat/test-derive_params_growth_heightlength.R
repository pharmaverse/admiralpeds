# derive_params_growth_heightlength ----

## Test 1: derive_params_growth_heightlength works ----
test_that("derive_params_growth_heightlength Test 1: derive_params_growth_heightlength works", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", 30, "cm", "WEIGHT", 10,
    "1002", "F", 25, "cm", "WEIGHT", 100,
  )

  fake_meta <- tibble::tribble(
    ~SEX, ~HEIGHT, ~HEIGHTU, ~L, ~M, ~S,
    "M", 30, "cm", 1, 2, 3,
    "M", 31, "cm", 4, 5, 6,
    "F", 25, "cm", 7, 8, 9,
    "F", 26, "cm", 10, 11, 12
  )

  actual <- derive_params_growth_heightlength(
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
