# Arguments:
#
# dataset: input dataset
# sex, age and age_unit would define the variables to use from input dataset: e.g. sex = SEX, age = AAGECUR, age_unit = AAGECURU
# meta_criteria: metadata as defined in step 4 of MS Teams doc
# parameter: the input dataset PARAMCD for which we want growth derivations: e.g. parameter = exprs(BMI = VSTESTCD == "BMI"). Options: “BMI”, “HEIGHT”, “WEIGHT”, “HEAD CIRCUMFERENCE”
# set_values_to_sds: variables to be set for zscore (SDS) parameter: e.g. set_values_to_sds(PARAMCD = “BMIASDS”, PARAM = “BMI-for-age z-score”). If left blank then parameter not derived in output dataset.
# set_values_to_pctl: variables to be set for percentile parameter: e.g. set_values_to_pctl(PARAMCD = “BMIAPCTL”, PARAM = “BMI-for-age Percentile”). If left blank then parameter not derived in output dataset.
# Checks:

derive_params_growth_age <- function(dataset,
                                     sex,
                                     age,
                                     age_unit,
                                     meta_criteria,
                                     parameter,
                                     set_values_to_sds,
                                     set_values_to_pctl) {

  # Apply assertions to each argument to ensure each object is approrpiate class
  assert_data_frame(dataset)
  assert_character_vector(sex)
  assert_numeric_vector(age)
  assert_character_scalar(age_unit)
  assert_data_frame(meta_criteria)
  assert_expr(parameter)
  assert_varval_list(set_values_to_sds, optional = TRUE)
  assert_varval_list(set_values_to_pctl, optional = TRUE)

  # Process metadata
  # Metadata should contain SEX, AGE, AGEU, L, M, S
  # Processing the data to be compatible with our advs object
  processed_md <- meta_criteria %>%
    arrange(SEX, AGEU, AGE) %>%
    group_by(SEX, AGEU) %>%
    mutate(next_age = lead(AGE), # join all the records to then filter using a AGE <= AGECUR < next_age is easier
           SEX = ifelse(SEX == 1, "M", "F"))

  added_records <- dataset %>%
    filter(!!parameter) %>%
    left_join(.,processed_md, by = c(!!sex = "SEX", !!age_unit = "AGEU"), relationship = "many-to-many") %>%
    filter(AGE <= !!age & !!age < next_age) %>%
    mutate(SDS = ((VSSTRESN/M)^L - 1)/(L*S),
           perc = pnorm(SDS)*100) %>%
    pivot_longer(., cols = SDS:perc, names_to = temp, values_to = AVAL)

  return(added_records)
}
