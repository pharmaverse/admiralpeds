# WHO growth charts ----

## Test 1: WHO length/height-for-age for girls ----
test_that("WHO_growth_charts Test 1: WHO length/height-for-age for girls", {
  expect_snapshot(who_lgth_ht_for_age_girls)
})
## Test 2: WHO length/height-for-age for boys ----
test_that("WHO_growth_charts Test 2: WHO length/height-for-age for boys", {
  expect_snapshot(who_lgth_ht_for_age_boys)
})

## Test 3: WHO weight-for-age for girls ----
test_that("WHO_growth_charts Test 3: WHO weight-for-age for girls", {
  expect_snapshot(who_wt_for_age_girls)
})
## Test 4: WHO weight-for-age for boys ----
test_that("WHO_growth_charts Test 4: WHO weight-for-age for boys", {
  expect_snapshot(who_wt_for_age_boys)
})

## Test 5: WHO weight-for-length for girls ----
test_that("WHO_growth_charts Test 5: WHO weight-for-length for girls", {
  expect_snapshot(who_wt_for_lgth_girls)
})
## Test 6: WHO weight-for-length for boys ----
test_that("WHO_growth_charts Test 6: WHO weight-for-length for boys", {
  expect_snapshot(who_wt_for_lgth_boys)
})

## Test 7: WHO weight-for-height for girls ----
test_that("WHO_growth_charts Test 7: WHO weight-for-height for girls", {
  expect_snapshot(who_wt_for_ht_girls)
})
## Test 8: WHO weight-for-height for boys ----
test_that("WHO_growth_charts Test 8: WHO weight-for-height for boys", {
  expect_snapshot(who_wt_for_ht_boys)
})

## Test 9: WHO BMI-for-age for girls ----
test_that("WHO_growth_charts Test 9: WHO BMI-for-age for girls", {
  expect_snapshot(who_bmi_for_age_girls)
})
## Test 10: WHO BMI-for-age for boys ----
test_that("WHO_growth_charts Test 10: WHO BMI-for-age for boys", {
  expect_snapshot(who_bmi_for_age_boys)
})

## Test 11: WHO Head circumference-for-age for girls ----
test_that("WHO_growth_charts Test 11: WHO Head circumference-for-age for girls", {
  expect_snapshot(who_hc_for_age_girls)
})
## Test 12: WHO Head circumference-for-age for boys ----
test_that("WHO_growth_charts Test 12: WHO Head circumference-for-age for boys", {
  expect_snapshot(who_hc_for_age_boys)
})
