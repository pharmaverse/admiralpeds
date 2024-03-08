library(admiralpeds)

# get_cdc_data ----
## Test 1: CDC weight-for-age chart ----
test_that("get_cdc_data Test 1: CDC weight-for-age chart", {
  expect_snapshot(get_cdc_data("weight"))
})

## Test 2: CDC weight-for-age chart ----
test_that("get_cdc_data Test 2: CDC weight-for-age chart", {
  expect_snapshot(get_cdc_data("height"))
})

## Test 3: CDC weight-for-age chart ----
test_that("get_cdc_data Test 3: CDC weight-for-age chart", {
  expect_snapshot(get_cdc_data("bmi"))
})
