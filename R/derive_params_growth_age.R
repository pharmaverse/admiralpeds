#' Title
#'
#' @param dataset
#' @param sex
#' @param age
#' @param age_unit
#' @param meta_criteria
#' @param parameter
#' @param set_values_to_sds
#' @param set_values_to_pctl
#'
#' @return
#' @export
#'
#' @examples
derive_params_growth_age <- function(dataset,
                                     sex,
                                     age,
                                     age_unit,
                                     meta_criteria,
                                     parameter,
                                     set_values_to_sds = NULL,
                                     set_values_to_pctl = NULL) {


  # Apply assertions to each argument to ensure each object is approrpiate class
  # assert_data_frame(dataset, required_vars = exprs(!!sex, !!age, !!age_unit))
  # assert_character_vector(pull(dataset, !!!sex))
  # assert_numeric_vector(pull(dataset, !!!age))
  # assert_character_scalar(pull(dataset, !!!age_unit))
  # assert_data_frame(meta_criteria, required_vars = exprs(SEX, AGE, AGEU, L, M, S))
  # assert_expr(parameter)
  # assert_varval_list(set_values_to_sds, optional = TRUE)
  # assert_varval_list(set_values_to_pctl, optional = TRUE)

  dataset <- dataset %>%
    mutate(SEX.join := {{sex}},
           AGEU.join := {{age_unit}})

  # Process metadata
  # Metadata should contain SEX, AGE, AGEU, L, M, S
  # Processing the data to be compatible with the dataset object
  processed_md <- meta_criteria %>%
    arrange(SEX, AGEU, AGE) %>%
    group_by(SEX, AGEU) %>%
    mutate(
      next_age = lead(AGE), # needed for the join and filter later
      SEX = ifelse(SEX == 1, "M", "F")
    ) %>%
    rename(
      SEX.join = SEX,
      prev_age = AGE,
      AGEU.join = AGEU
    )

  # Merge the dataset that contains the vs records and filter the L/M/S that fit the appropriate age
  # To parse out the appropriate age, create [x, y) brackets using a AGE <= AGECUR < next_age
  added_records <- dataset %>%
    filter(!!enexpr(parameter)) %>%
    left_join(.,
              processed_md,
              by = c("SEX.join", "AGEU.join"),
              relationship = "many-to-many") %>%
    filter(prev_age <= {{age}} & {{age}} < next_age) %>%
    select(-c(SEX.join, AGEU.join, prev_age, next_age))

  dataset_final <- dataset

  # create separate records objects as appropriate depending if user specific sds and/or pctl
  if (!is_empty(set_values_to_sds)){
    add_sds <- added_records %>%
      mutate(
        AVAL = ((VSSTRESN/M)^L - 1)/(L*S),
        !!!set_values_to_sds
      ) %>%
      select(-c(L, M, S))

    dataset_final <- bind_rows(dataset, add_sds)
  }

  if (!is_empty(set_values_to_pctl)){
    add_pctl <- added_records %>%
      mutate(
        AVAL = ((VSSTRESN/M)^L - 1)/(L*S),
        AVAL = pnorm(AVAL)*100,
        # may need to add special modification for > 95th percentile
        !!!set_values_to_pctl
      ) %>%
      select(-c(L, M, S))

    dataset_final <- bind_rows(dataset_final, add_pctl)
  }

  return(dataset_final)
}
