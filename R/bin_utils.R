#' Get Bins of Metadata
#'
#' Creates unique age/heights-bins for each record to speed up joining
#'
#' @param meta_criteria Metadata dataset
#'
#'   A metadata dataset that is the same as that in
#'   `derive_params_growth_age()`/`derive_params_growth_height()`
#'
#' @param param Character vector
#'
#'   Accepted values: "AGE"/"HEIGHT_LENGTH"
#'
#' @family internal
#' @keywords internal
#' @return list of breaks and labels for age/height bins
get_bins <- function(meta_criteria, param) {
  if (param == "AGE") {
    unique_vals <- sort(unique(meta_criteria$AGE))
  } else if (param == "HEIGHT_LENGTH") {
    unique_vals <- sort(unique(meta_criteria$HEIGHT_LENGTH))
  }
  breaks <- c(unique_vals, Inf)
  labels <- paste0(head(breaks, -1), ",", tail(breaks, -1))
  return(list(breaks = breaks, labels = labels)) # nolint
}


#' Find closest bin
#'
#' @param param Parameter
#'
#'  Vector containing parameter that needs closest bin checking
#'
#' @param breaks Breaks created in `get_bins()`
#'
#' @param labels Labels created in `get_bins()`
#'
#' @family internal
#' @keywords internal
#'
#' @return detects appropriate bin
find_closest_bin <- function(param, breaks, labels) {
  if (is.na(param)) {
    return(NA)
  }

  # Find the index of the bin where the param should be placed
  interval_index <- findInterval(param, vec = breaks, rightmost.closed = TRUE)

  # Handle edge cases where param is before the first bin or after the last bin
  if (param < breaks[1]) {
    return(labels[1])
  }
  if (param >= breaks[length(breaks) - 1]) {
    return(labels[length(labels)])
  }

  # Determine the closest bin by comparing distances to the previous and next bins
  lower_bound <- breaks[interval_index]
  upper_bound <- breaks[interval_index + 1]

  if (is.na(lower_bound)) {
    return(labels[1])
  }
  if (is.na(upper_bound)) {
    return(labels[length(labels)])
  }

  distance_to_lower <- abs(param - lower_bound)
  distance_to_upper <- abs(param - upper_bound)

  if (distance_to_lower <= distance_to_upper) {
    return(labels[interval_index]) # nolint
  } else {
    return(labels[interval_index + 1]) # nolint
  }
}

#' Set Age/Height Bins
#'
#' Adds the unique age/height-bins to each dataframe to have a column for `by` in join.
#'
#' @family internal
#' @keywords internal
#' @return Character vector of unique age/height bins based on metadata
set_bins <- function(param, breaks, labels) {
  mapped_labels <- sapply(param, find_closest_bin, breaks = breaks, labels = labels) # nolint
  return(mapped_labels) # nolint
}
