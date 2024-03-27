# get_cdc_data ----
## Test 1: CDC weight-for-age chart ----
test_that("get_cdc_data Test 1: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_wtage)
})

## Test 2: CDC height-for-age chart ----
test_that("get_cdc_data Test 2: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_htage)
})

## Test 3: CDC bmi-for-age chart ----
test_that("get_cdc_data Test 3: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_bmiage)
})
