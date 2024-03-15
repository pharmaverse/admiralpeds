#' Retrieve CDC growth chart metadataset
#'
#' Retrieves CDC growth chart metadataset
#'
#' @param type Type of Chart
#'
#'   *Permitted Values*: `"height"`, `"weight"`, `"bmi"`
#'
#' @return A data-frame of the appropriate growth chart from the CDC data
#'
#' @details
#'
#' Each data frame will be denoted as below:
#' \describe{
#'   \item{\code{SEX}}{Sex: 1 = male, 2 = female}
#'   \item{\code{AGE}}{Age in months}
#'   \item{\code{L}}{Box-Cox transformation for normality}
#'   \item{\code{M}}{Median}
#'   \item{\code{S}}{Coefficient of variation}
#' }
#'
#' This metadata is sourced from [CDC website](https://www.cdc.gov/growthcharts/percentile_data_files.htm).
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
