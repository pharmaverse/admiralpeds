% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_cdc_data.R
\name{get_cdc_data}
\alias{get_cdc_data}
\title{Retrieve CDC growth chart metadataset}
\usage{
get_cdc_data(type)
}
\arguments{
\item{type}{Type of Chart

\emph{Permitted Values}: \code{"height"}, \code{"weight"}, \code{"bmi"}}
}
\value{
A data-frame of the appropriate growth chart from the CDC data
}
\description{
Retrieves CDC growth chart metadataset
}
\details{
Each data frame will be denoted as below:
\describe{
\item{\code{SEX}}{Sex: 1 = male, 2 = female}
\item{\code{AGE}}{Age in months}
\item{\code{L}}{Box-Cox transformation for normality}
\item{\code{M}}{Median}
\item{\code{S}}{Coefficient of variation}
}

This metadata is sourced from the
\href{https://www.cdc.gov/growthcharts/percentile_data_files.htm}{CDC website}.
}
\examples{
get_cdc_data(type = "bmi")
}
\concept{metadata}
\keyword{metadata}
