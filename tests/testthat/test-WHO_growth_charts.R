# WHO growth charts ----

## Test 1: WHO length/height-for-age for girls ----
test_that("WHO_growth_charts Test 1: WHO length/height-for-age for girls", {
  expect_snapshot(WHO_length_height_for_age_girls)
})
## Test 2: WHO length/height-for-age for boys ----
test_that("WHO_growth_charts Test 2: WHO length/height-for-age for boys", {
  expect_snapshot(WHO_length_height_for_age_boys)
})

## Test 3: WHO weight-for-age for girls ----
test_that("WHO_growth_charts Test 3: WHO weight-for-age for girls", {
  expect_snapshot(WHO_weight_for_age_girls)
})
## Test 4: WHO weight-for-age for boys ----
test_that("WHO_growth_charts Test 4: WHO weight-for-age for boys", {
  expect_snapshot(WHO_weight_for_age_boys)
})

## Test 5: WHO weight-for-length for girls ----
test_that("WHO_growth_charts Test 5: WHO weight-for-length for girls", {
  expect_snapshot(WHO_weight_for_length_girls)
})
## Test 6: WHO weight-for-length for boys ----
test_that("WHO_growth_charts Test 6: WHO weight-for-length for boys", {
  expect_snapshot(WHO_weight_for_length_boys)
})

## Test 7: WHO weight-for-height for girls ----
test_that("WHO_growth_charts Test 7: WHO weight-for-height for girls", {
  expect_snapshot(WHO_weight_for_height_girls)
})
## Test 8: WHO weight-for-height for boys ----
test_that("WHO_growth_charts Test 8: WHO weight-for-height for boys", {
  expect_snapshot(WHO_weight_for_height_boys)
})

## Test 9: WHO bmi-for-age for girls ----
test_that("WHO_growth_charts Test 9: WHO bmi-for-age for girls", {
  expect_snapshot(WHO_bmi_for_age_girls)
})
## Test 10: WHO bmi-for-age for boys ----
test_that("WHO_growth_charts Test 10: WHO bmi-for-age for boys", {
  expect_snapshot(WHO_bmi_for_age_boys)
})
