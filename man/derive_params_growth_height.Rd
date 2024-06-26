% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/derive_params_growth_height.R
\name{derive_params_growth_height}
\alias{derive_params_growth_height}
\title{Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length)
based on Standard Growth Charts}
\usage{
derive_params_growth_height(
  dataset,
  sex,
  height,
  height_unit,
  meta_criteria,
  parameter,
  analysis_var,
  set_values_to_sds = NULL,
  set_values_to_pctl = NULL
)
}
\arguments{
\item{dataset}{Input dataset

The variables specified in \code{sex}, \code{height}, \code{height_unit}, \code{parameter}, \code{analysis_var}
are expected to be in the dataset.}

\item{sex}{Sex

A character vector is expected.

Expected Values: \code{M}, \code{F}}

\item{height}{Current Height/length

A numeric vector is expected. Note that this is the actual height at the current visit.}

\item{height_unit}{Height/Length Unit
A character vector is expected.

Expected values: 'cm'}

\item{meta_criteria}{Metadata dataset

A metadata dataset with the following expected variables:
\code{HEIGHT_LENGTH}, \code{HEIGHT_LENGTHU}, \code{SEX}, \code{L}, \code{M}, \code{S}

The dataset can be derived from WHO or user-defined datasets.
The WHO growth chart metadata datasets are available in the package and will
require small modifications.

Datasets \code{who_wt_for_lgth_boys}/\code{who_wt_for_lgth_girls} are for subject age < 730.5 days.
Datasets \code{who_wt_for_ht_boys}/\code{who_wt_for_ht_girls} are for subjects age >= 730.5 days.
\itemize{
\item \code{HEIGHT_LENGTH} - Height/Length
\item \code{HEIGHT_LENGTHU} - Height/Length Unit
\item \code{SEX} - Sex
\item \code{L} - Power in the Box-Cox transformation to normality
\item \code{M} - Median
\item \code{S} - Coefficient of variation
}}

\item{parameter}{Anthropometric measurement parameter to calculate z-score or percentile

A condition is expected with the input dataset \code{VSTESTCD}/\code{PARAMCD}
for which we want growth derivations:

e.g. \code{parameter = VSTESTCD == "WEIGHT"}.

There is WHO metadata available for Weight available in the \code{admiralpeds} package.
Weight measures are expected to be in the unit "kg".}

\item{analysis_var}{Variable containing anthropometric measurement

A numeric vector is expected, e.g. \code{AVAL}, \code{VSSTRESN}}

\item{set_values_to_sds}{Variables to be set for Z-Scores

The specified variables are set to the specified values for the new
observations. For example,
\verb{set_values_to_sds(exprs(PARAMCD = “WTASDS”, PARAM = “Weight-for-height z-score”))}
defines the parameter code and parameter.

The formula to calculate the Z-score is as follows:

\deqn{\frac{((\frac{obs}{M})^L - 1)}{L * S}}

where "obs" is the observed value for the respective anthropometric measure being calculated.

\emph{Permitted Values}: List of variable-value pairs

If left as default value, \code{NULL}, then parameter not derived in output dataset}

\item{set_values_to_pctl}{Variables to be set for Percentile

The specified variables are set to the specified values for the new
observations. For example,
\verb{set_values_to_pctl(exprs(PARAMCD = “WTHPCTL”, PARAM = “Weight-for-height percentile”))}
defines the parameter code and parameter.

\emph{Permitted Values}: List of variable-value pair

If left as default value, \code{NULL}, then parameter not derived in output dataset}
}
\value{
The input dataset additional records with the new parameter added.
}
\description{
Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length)
based on Standard Growth Charts for Weight by Height/Length
}
\examples{
library(dplyr)
library(lubridate)
library(rlang)
library(admiral)

advs <- dm_peds \%>\%
  select(USUBJID, BRTHDTC, SEX) \%>\%
  right_join(., vs_peds, by = "USUBJID") \%>\%
  mutate(
    VSDT = ymd(VSDTC),
    BRTHDT = ymd(BRTHDTC)
  ) \%>\%
  derive_vars_duration(
    new_var = AAGECUR,
    new_var_unit = AAGECURU,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "days"
  )

heights <- vs_peds \%>\%
  filter(VSTESTCD == "HEIGHT") \%>\%
  select(USUBJID, VSSTRESN, VSSTRESU, VSDTC) \%>\%
  rename(
    HGTTMP = VSSTRESN,
    HGTTMPU = VSSTRESU
  )

advs <- advs \%>\%
  right_join(., heights, by = c("USUBJID", "VSDTC"))

advs_under2 <- advs \%>\%
  filter(AAGECUR < 730)

advs_over2 <- advs \%>\%
  filter(AAGECUR >= 730.5)

who_under2 <- bind_rows(
  (admiralpeds::who_wt_for_lgth_boys \%>\%
    mutate(
      SEX = "M",
      height_unit = "cm"
    )
  ),
  (admiralpeds::who_wt_for_lgth_girls \%>\%
    mutate(
      SEX = "F",
      height_unit = "cm"
    )
  )
) \%>\%
  rename(
    HEIGHT_LENGTH = Length,
    HEIGHT_LENGTHU = height_unit
  )

who_over2 <- bind_rows(
  (admiralpeds::who_wt_for_ht_boys \%>\%
    mutate(
      SEX = "M",
      height_unit = "cm"
    )
  ),
  (admiralpeds::who_wt_for_ht_girls \%>\%
    mutate(
      SEX = "F",
      height_unit = "cm"
    )
  )
) \%>\%
  rename(
    HEIGHT_LENGTH = Height,
    HEIGHT_LENGTHU = height_unit
  )


advs_under2 <- derive_params_growth_height(
  advs_under2,
  sex = SEX,
  height = HGTTMP,
  height_unit = HGTTMPU,
  meta_criteria = who_under2,
  parameter = VSTESTCD == "WEIGHT",
  analysis_var = VSSTRESN,
  set_values_to_sds = exprs(
    PARAMCD = "WGHSDS",
    PARAM = "Weight-for-height z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "WGHPCTL",
    PARAM = "Weight-for-height percentile"
  )
)

advs_over2 <- derive_params_growth_height(
  advs_over2,
  sex = SEX,
  height = HGTTMP,
  height_unit = HGTTMPU,
  meta_criteria = who_over2,
  parameter = VSTESTCD == "WEIGHT",
  analysis_var = VSSTRESN,
  set_values_to_sds = exprs(
    PARAMCD = "WGHSDS",
    PARAM = "Weight-for-height z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "WGHPCTL",
    PARAM = "Weight-for-height percentile"
  )
)

bind_rows(advs_under2, advs_over2)
}
\seealso{
Vital Signs Functions for adding Parameters/Records
\code{\link{derive_params_growth_age}()}
}
\concept{der_prm_bds_vs}
\keyword{der_prm_bds_vs}
