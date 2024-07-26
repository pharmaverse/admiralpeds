#' Get Bins of Metadata
#'
#' Creates unique age/heights-bins for each record to speed up joining
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset that is the same as that in `derive_params_growth_age()`/`derive_params_growth_height()`
#'
#' @family internal
#' @keywords internal
#' @return list of breaks and labels for age/height bins
get_bins <- function(meta_criteria, param) {
  if(param == "AGE") {
    unique_vals <- sort(unique(meta_criteria$AGE))
  }
  else if(param == "HEIGHT_LENGTH") {
    unique_vals <- sort(unique(meta_criteria$HEIGHT_LENGTH))
  }
  breaks <- c(unique_vals, Inf)
  labels <- paste0(head(breaks, -1), ",", tail(breaks, -1))
  return(list(breaks = breaks, labels = labels))
}

#' Set Age/Height Bins
#'
#' Adds the unique age/height-bins to each dataframe to have a column for `by` in join.
#'
#' @param age Age column of dataset
#'
#' @family internal
#' @keywords internal
#' @return Character vector of unique age/height bins based on metadata
set_bins <- function(param, breaks, labels) {
  interval_indices <- findInterval(param, vec = breaks, rightmost.closed = TRUE)
  mapped_labels <- labels[interval_indices]
  return(mapped_labels)
}
