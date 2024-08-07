% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/derive_params_growth_age.R
\name{derive_params_growth_age}
\alias{derive_params_growth_age}
\title{Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts}
\usage{
derive_params_growth_age(
  dataset,
  sex,
  age,
  age_unit,
  meta_criteria,
  parameter,
  analysis_var,
  bmi_cdc_correction = FALSE,
  who_correction = FALSE,
  set_values_to_sds = NULL,
  set_values_to_pctl = NULL
)
}
\arguments{
\item{dataset}{Input dataset

The variables specified in \code{sex}, \code{age}, \code{age_unit}, \code{parameter}, \code{analysis_var}
are expected to be in the dataset.}

\item{sex}{Sex

A character vector is expected.

Expected Values: \code{M}, \code{F}}

\item{age}{Current Age

A numeric vector is expected. Note that this is the actual age at the current visit.}

\item{age_unit}{Age Unit
A character vector is expected.

Expected values: \code{days}, \code{weeks}, \code{months}}

\item{meta_criteria}{Metadata dataset

A metadata dataset with the following expected variables:
\code{AGE}, \code{AGEU}, \code{SEX}, \code{L}, \code{M}, \code{S}

The dataset can be derived from CDC/WHO or user-defined datasets.
The CDC/WHO growth chart metadata datasets are available in the package and will
require small modifications.

If the \code{age} value from \code{dataset} falls between two \code{AGE} values in \code{meta_criteria},
then the \code{L}/\code{M}/\code{S} values that are chosen/mapped will be the \code{AGE} that has the
smaller absolute difference to the value in \code{age}.
e.g. If dataset has a current age of 27.49 months, and the metadata contains records
for 27 and 28 months, the \code{L}/\code{M}/\code{S} corresponding to the 27 months record will be used.
\itemize{
\item \code{AGE} - Age
\item \code{AGEU} - Age Unit
\item \code{SEX} - Sex
\item \code{L} - Power in the Box-Cox transformation to normality
\item \code{M} - Median
\item \code{S} - Coefficient of variation
}}

\item{parameter}{Anthropometric measurement parameter to calculate z-score or percentile

A condition is expected with the input dataset \code{VSTESTCD}/\code{PARAMCD}
for which we want growth derivations:

e.g. \code{parameter = VSTESTCD == "WEIGHT"}.

There is CDC/WHO metadata available for Height, Weight, BMI, and Head Circumference available
in the \code{admiralpeds} package.}

\item{analysis_var}{Variable containing anthropometric measurement

A numeric vector is expected, e.g. \code{AVAL}, \code{VSSTRESN}}

\item{bmi_cdc_correction}{Extended CDC BMI-for-age correction

A logical scalar, e.g. \code{TRUE}/\code{FALSE} is expected.
CDC developed extended percentiles (>95\%) to monitor high BMI values,
if set to \code{TRUE} the CDC's correction is applied.}

\item{who_correction}{WHO adjustment for weight-based indicators

A logical scalar, e.g. \code{TRUE}/\code{FALSE} is expected.
WHO constructed a restricted application of the LMS method for weight-based indicators.
More details on these exact rules applied can be found at the document page 302 of the
\href{https://www.who.int/publications/i/item/924154693X}{WHO Child Growth Standards Guidelines}.
If set to \code{TRUE} the WHO correction is applied.}

\item{set_values_to_sds}{Variables to be set for Z-Scores

The specified variables are set to the specified values for the new
observations. For example,
\code{set_values_to_sds(exprs(PARAMCD = "BMIASDS", PARAM = "BMI-for-age z-score"))}
defines the parameter code and parameter.

The formula to calculate the Z-score is as follows:

\deqn{\frac{((\frac{obs}{M})^L - 1)}{L * S}}

where "obs" is the observed value for the respective anthropometric measure being calculated.

\emph{Permitted Values}: List of variable-value pairs

If left as default value, \code{NULL}, then parameter not derived in output dataset}

\item{set_values_to_pctl}{Variables to be set for Percentile

The specified variables are set to the specified values for the new
observations. For example,
\code{set_values_to_pctl(exprs(PARAMCD = "BMIAPCTL", PARAM = "BMI-for-age percentile"))}
defines the parameter code and parameter.

\emph{Permitted Values}: List of variable-value pair

If left as default value, \code{NULL}, then parameter not derived in output dataset}
}
\value{
The input dataset additional records with the new parameter added.
}
\description{
Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts
for Height/Weight/BMI/Head Circumference by Age
}
\examples{
library(dplyr, warn.conflicts = FALSE)
library(lubridate, warn.conflicts = FALSE)
library(rlang, warn.conflicts = FALSE)
library(admiral, warn.conflicts = FALSE)

advs <- dm_peds \%>\%
  select(USUBJID, BRTHDTC, SEX) \%>\%
  right_join(., vs_peds, by = "USUBJID") \%>\%
  mutate(
    VSDT = ymd(VSDTC),
    BRTHDT = ymd(BRTHDTC)
  ) \%>\%
  derive_vars_duration(
    new_var = AGECUR_D,
    new_var_unit = CURU_D,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "days",
    trunc_out = FALSE
  ) \%>\%
  derive_vars_duration(
    new_var = AGECUR_M,
    new_var_unit = CURU_M,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "months",
    trunc_out = FALSE
  ) \%>\%
  mutate(
    AGECUR = ifelse(AGECUR_D >= 365.25 * 2, AGECUR_M, AGECUR_D),
    AGECURU = ifelse(AGECUR_D >= 365.25 * 2, CURU_M, CURU_D)
  )

# metadata is in months
cdc_meta_criteria <- admiralpeds::cdc_htage \%>\%
  mutate(
    age_unit = "months",
    SEX = ifelse(SEX == 1, "M", "F")
  )

# metadata is in days
who_meta_criteria <- bind_rows(
  (admiralpeds::who_lgth_ht_for_age_boys \%>\%
    mutate(
      SEX = "M",
      age_unit = "days"
    )
  ),
  (admiralpeds::who_lgth_ht_for_age_girls \%>\%
    mutate(
      SEX = "F",
      age_unit = "days"
    )
  )
) \%>\%
  rename(AGE = Day)

criteria <- bind_rows(
  cdc_meta_criteria,
  who_meta_criteria
) \%>\%
  rename(AGEU = age_unit)

derive_params_growth_age(
  advs,
  sex = SEX,
  age = AGECUR,
  age_unit = AGECURU,
  meta_criteria = criteria,
  parameter = VSTESTCD == "HEIGHT",
  analysis_var = VSSTRESN,
  set_values_to_sds = exprs(
    PARAMCD = "HGTSDS",
    PARAM = "Height-for-age z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "HGTPCTL",
    PARAM = "Height-for-age percentile"
  )
)
}
\seealso{
Vital Signs Functions for adding Parameters/Records
\code{\link{derive_params_growth_height}()}
}
\concept{der_prm_bds_vs}
\keyword{der_prm_bds_vs}
