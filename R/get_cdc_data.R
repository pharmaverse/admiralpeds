#' Retrieve CDC growth chart metadataset
#'
#' Retrieves CDC growth chart metadataset
#'
#' @param type Type of Chart
#'
#' A character is expected amongst: "height", "weight", "bmi"
#'
#' @return The appropriate growth chart from the CDC data
#'
#' @family metadata
#' @keywords metadata
#'
#' @export
#'
#' @examples
#' get_cdc_data(type = "bmi") %>% head()
get_cdc_data <- function(type) {
  # Limit input values to the three datasets available from CDC data
  assert_character_scalar(type, values = c("height", "weight", "bmi"))

  # Grab the appropriate one
  switch(type,
    height = cdc_htage,
    weight = cdc_wtage,
    bmi = cdc_bmiage
  )
}
