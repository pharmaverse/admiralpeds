#' @title CDC weight-for-age
#' @description CDC weight-for-age charts from age 2 to 20 years (in months)
#' @format A data frame with 436 rows and 5 variables:
#' \describe{
#'   \item{\code{SEX}}{double sex where 1 = male, 2 = female}
#'   \item{\code{AGE}}{double age in months}
#'   \item{\code{L}}{double Box-Cox transformation for normality}
#'   \item{\code{M}}{double Median}
#'   \item{\code{S}}{double Coefficient of variation}
#' }
#' @family datasets
#' @keywords datasets
#' @source \url{https://www.cdc.gov/growthcharts/percentile_data_files.htm}
"cdc_wtage"

#' @title CDC staturue/height-for-age
#' @description CDC height-for-age charts from age 2 to 20 years (in months)
#' @format A data frame with 436 rows and 5 variables:
#' \describe{
#'   \item{\code{SEX}}{double sex where 1 = male, 2 = female}
#'   \item{\code{AGE}}{double age in months}
#'   \item{\code{L}}{double Box-Cox transformation for normality}
#'   \item{\code{M}}{double Median}
#'   \item{\code{S}}{double Coefficient of variation}
#' }
#' @family datasets
#' @keywords datasets
#' @source \url{https://www.cdc.gov/growthcharts/percentile_data_files.htm}
"cdc_htage"

#' @title CDC bmi-for-age
#' @description CDC bmi-for-age charts from age 2 to 20 years (in months)
#' @format A data frame with 438 rows and 5 variables:
#' \describe{
#'   \item{\code{SEX}}{double sex where 1 = male, 2 = female}
#'   \item{\code{AGE}}{double age in months}
#'   \item{\code{L}}{double Box-Cox transformation for normality}
#'   \item{\code{M}}{double Median}
#'   \item{\code{S}}{double Coefficient of variation}
#' }
#' @family datasets
#' @keywords datasets
#' @source \url{https://www.cdc.gov/growthcharts/percentile_data_files.htm}
"cdc_bmiage"
