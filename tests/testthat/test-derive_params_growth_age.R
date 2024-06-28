# derive_params_growth_age ----

## Test 1: Weight SDS and percentile works (P3, P95) ----
test_that("derive_params_growth_age Test 1: Weight SDS and percentileworks (P3, P95)", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", 30.5, "months", "WEIGHT", 11.12786972,
    "1002", "F", 70.5, "months", "WEIGHT", 26.76154129,
  )

  meta <- cdc_wtage %>%
    mutate(SEX = case_when(SEX == 1 ~ "M",
                           SEX == 2 ~ "F"),
           AGEU = "months")

  actual <- derive_params_growth_age(
    dataset = vs_data,
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "WEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "WTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "WTAPCTL"
    )
  )

  vs_data_meta <- vs_data %>%
    mutate(AGE = AGECUR) %>%
    inner_join(meta, by=c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>%mutate(AVAL = (((VSSTRESN/M)^L)-1)/(L*S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL))
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    expected,
    filter(actual, PARAMCD %in% c("WTASDS", "WTAPCTL")) %>% pull(AVAL)
  )
})

## Test 2: Height SDS and percentile works (P50, P97) ----
test_that("derive_params_growth_age Test 2: Height SDS and percentile works (P50, P97)", {
  vs_data <- tibble::tribble(
    ~USUBJID, ~SEX, ~AGECUR, ~AGEU, ~VSTESTCD, ~VSSTRESN,
    "1001", "M", 40.5, "months", "HEIGHT", 97.78897727,
    "1002", "F", 140.5, "months", "HEIGHT", 162.9362629,
  )

  meta <- cdc_htage %>%
    mutate(SEX = case_when(SEX == 1 ~ "M",
                           SEX == 2 ~ "F"),
           AGEU = "months")

  actual <- derive_params_growth_age(
    dataset = vs_data,
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "HEIGHT",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "HTASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "HTAPCTL"
    )
  )

  vs_data_meta <- vs_data %>%
    mutate(AGE = AGECUR) %>%
    inner_join(meta, by=c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>%mutate(AVAL = (((VSSTRESN/M)^L)-1)/(L*S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL))
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    expected,
    filter(actual, PARAMCD %in% c("HTASDS", "HTAPCTL")) %>% pull(AVAL)
  )
})

## Test 3: BMI SDS and percentile works (Z-score of -2, 0, 2, 5) ----
test_that("derive_params_growth_age Test 3: BMI SDS and percentile works (Z-score of -2, 0, 2, 5)", {
  vs_data <- meta %>% mutate(z_n2 = M*(1+L*S*(-2))^(1/L),
                             z_0 = M*(1+L*S*0)^(1/L),
                             z_2 = M*(1+L*S*2)^(1/L),
                             z_5 = M*(1+L*S*5)^(1/L)) %>%
    filter((SEX == "M" & AGE == 70.5)|
             (SEX == "M" & AGE == 135.5)|
             (SEX == "F" & AGE == 88.5)|
             (SEX == "F" & AGE == 193.5)) %>%
    mutate(VSSTRESN = case_when(
      SEX == "M" & AGE == 70.5 ~ z_n2,
      SEX == "M" & AGE == 135.5 ~ z_0,
      SEX == "F" & AGE == 88.5 ~ z_2,
      SEX == "F" & AGE == 193.5 ~ z_5
    )) %>%
    mutate(USUBJID = paste0("100",(row.names(vs_data))),
           VSTESTCD = "BMI",
           AGECUR = AGE) %>%
    select(USUBJID, SEX, AGECUR, AGEU, VSTESTCD, VSSTRESN)

  meta <- cdc_bmiage %>%
    mutate(SEX = case_when(SEX == 1 ~ "M",
                           SEX == 2 ~ "F"),
           AGEU = "months")

  actual <- derive_params_growth_age(
    dataset = vs_data,
    sex = SEX,
    age = AGECUR,
    age_unit = AGEU,
    meta_criteria = meta,
    parameter = VSTESTCD == "BMI",
    analysis_var = VSSTRESN,
    set_values_to_sds = exprs(
      PARAMCD = "BMIASDS"
    ),
    set_values_to_pctl = exprs(
      PARAMCD = "BMIAPCTL"
    )
  )

  vs_data_meta <- vs_data %>%
    mutate(AGE = AGECUR) %>%
    inner_join(meta, by=c("SEX", "AGE", "AGEU"))

  vs_sds <- vs_data_meta %>%mutate(AVAL = (((VSSTRESN/M)^L)-1)/(L*S))
  vs_pctl <- vs_sds %>% mutate(AVAL = pnorm(AVAL))
  expected <- bind_rows(vs_sds, vs_pctl) %>% pull(AVAL)


  expect_equal(
    expected,
    filter(actual, PARAMCD %in% c("BMIASDS", "BMIAPCTL")) %>% pull(AVAL)
  )
})



