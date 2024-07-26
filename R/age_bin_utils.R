#' Get Age Bins of Metadata
#'
#' Creates unique age-bins for each record to speed up joining
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset that is the same as that in `derive_params_growth_age()`
#'
#' @family internal
#' @keywords internal
#' @return list of breaks and labels for age bins
get_age_bins <- function(meta_criteria) {
  unique_ages <- sort(unique(meta_criteria$AGE))
  breaks <- c(unique_ages, Inf)
  labels <- paste0(head(breaks, -1), ",", tail(breaks, -1))
  return(list(breaks = breaks, labels = labels))
}

#' Set Age Bins
#'
#' Adds the unique age-bins to each dataframe to have a column for `by` in join.
#'
#' @param age Age column of dataset
#'
#' @family internal
#' @keywords internal
#' @return Character vector of unique age bins based on metadata
set_age_bins <- function(age, breaks, labels) {
  interval_indices <- findInterval(age, vec = breaks, rightmost.closed = TRUE)
  mapped_labels <- labels[interval_indices]
  return(mapped_labels)
}
