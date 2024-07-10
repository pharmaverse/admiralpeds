# derive_params_growth_heightlength ----

## Test 1: derive_params_growth_heightlength works ----
test_that("derive_params_growth_heightlength Test 1: derive_params_growth_heightlength works", {
  vs_data <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~SEX, ~HEIGHT, ~HEIGHTU, ~VSTESTCD, ~VSSTRESN,
    "STUDY", "1001", "M", 30, "cm", "WEIGHT", 10,
    "STUDY", "1002", "F", 25.1, "cm", "WEIGHT", 100,
    "STUDY", "1003", "F", 25.5, "cm", "WEIGHT", 100,
    "STUDY", "1004", "F", 25.6, "cm", "WEIGHT", 100,
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
    by_vars = admiral::get_admiral_option("subject_keys"),
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
    ((100 / 8)^7 - 1) / (7 * 9),
    ((100 / 11)^10 - 1) / (10 * 12)
  )

  expect_equal(
    expected,
    filter(actual, PARAMCD == "WT2HTZ") %>% pull(AVAL)
  )
})
