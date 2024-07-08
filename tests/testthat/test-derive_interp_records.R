# derive_interp_records ----

## Test 1: derive_interp_records not NULL parameter ----
test_that("derive_interp_records Test 1 : parameter must be not NULL", {
  expect_error(derive_interp_records(parameter = NA_character_))
  expect_error(derive_interp_records(parameter = ""))
  expect_error(derive_interp_records(parameter = NULL))
})

## Test 2: derive_interp_records not NULL AGE ----
test_that("derive_interp_records Test 2 : AGE must be not NULL", {
  expect_error(derive_interp_records(AGE = NA))
})

## Test 3: derive_interp_records not NULL SEX ----
test_that("derive_interp_records Test 3 : SEX must be not NULL", {
  expect_error(derive_interp_records(SEX = NA_character_))
  expect_error(derive_interp_records(SEX = ""))
})
