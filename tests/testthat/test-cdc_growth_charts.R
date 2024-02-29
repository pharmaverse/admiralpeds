# cdc_growth_charts ----
## Test 1: CDC weight-for-age chart ----
test_that("cdc_growth_charts Test 1: CDC weight-for-age chart", {
  expect_snapshot(cdc_wtage)
})

## Test 2: CDC weight-for-age chart ----
test_that("cdc_growth_charts Test 2: CDC height-for-age chart", {
  expect_snapshot(cdc_htage)
})

## Test 3: CDC weight-for-age chart ----
test_that("cdc_growth_charts Test 3: CDC bmi-for-age chart", {
  expect_snapshot(cdc_bmiage)
})
