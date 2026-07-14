# Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on Standard Growth Charts

Derive Anthropometric indicators (Z-Scores/Percentiles-for-Age) based on
Standard Growth Charts for Height/Weight/BMI/Head Circumference by Age

## Usage

``` r
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
```

## Arguments

- dataset:

  Input dataset

  The variables specified in `sex`, `age`, `age_unit`, `parameter`,
  `analysis_var` are expected to be in the dataset.

  Permitted values

  :   a dataset, i.e., a `data.frame` or tibble

  Default value

  :   none

- sex:

  Sex

  Permitted values

  :   a character scalar, i.e., a character vector of length one .

      Expected Values: `M`, `F`.

  Default value

  :   none

- age:

  Current Age

  Permitted values

  :   a numeric scalar, i.e., a numeric vector of length one .

      Note that this is the actual age at the current visit.

  Default value

  :   none

- age_unit:

  Age Unit

  Permitted values

  :   a character scalar, i.e., a character vector of length one .

      Expected values: `days`, `weeks`, `months`.

      **Important**: The age unit specified in this parameter must match
      the age unit in the metadata (`AGEU` variable). The function does
      NOT automatically convert age units. If mismatches occur between
      the data and metadata age units, records will not be matched and
      warnings will be issued.

      **Age Unit Conversion**: If your data and metadata have different
      age units, you must standardize them before calling this function.
      The following conversion factors can be used:

      - 1 week = 7 days

      - 1 month = 30.4375 days

      - 1 year = 365.25 days

      Example: To convert months to days:

          dataset <- dataset %>%
            mutate(age_days = if_else(age_unit == "months", age * 30.4375, age))

  Default value

  :   none

- meta_criteria:

  Metadata dataset

  A metadata dataset with the following expected variables: `AGE`,
  `AGEU`, `SEX`, `L`, `M`, `S`.

  The dataset can be derived from CDC/WHO or user-defined datasets. The
  CDC/WHO growth chart metadata datasets are available in the package
  and will require small modifications.

  If the `age` value from `dataset` falls between two `AGE` values in
  `meta_criteria`, then the `L`/`M`/`S` values that are chosen/mapped
  will be the `AGE` that has the smaller absolute difference to the
  value in `age`. e.g. If dataset has a current age of 27.49 months, and
  the metadata contains records for 27 and 28 months, the `L`/`M`/`S`
  corresponding to the 27 months record will be used.

  - `AGE` - Age

  - `AGEU` - Age Unit (must match the age unit in the input dataset)

  - `SEX` - Sex

  - `L` - Power in the Box-Cox transformation to normality

  - `M` - Median

  - `S` - Coefficient of variation

  Permitted values

  :   a dataset, i.e., a `data.frame` or tibble

  Default value

  :   none

- parameter:

  Anthropometric measurement parameter to calculate z-score or
  percentile

  A condition is expected with the input dataset `VSTESTCD`/`PARAMCD`
  for which we want growth derivations:

  e.g. `parameter = VSTESTCD == "WEIGHT"`.

  There is CDC/WHO metadata available for Height, Weight, BMI, and Head
  Circumference available in the `admiralpeds` package.

  Permitted values

  :   an unquoted condition, e.g., `parameter = VSTESTCD == "WEIGHT"`

  Default value

  :   none

- analysis_var:

  Variable containing anthropometric measurement

  Permitted values

  :   a numeric scalar, i.e., a numeric vector of length one e.g.
      `AVAL`, `VSSTRESN`.

  Default value

  :   none

- bmi_cdc_correction:

  Extended CDC BMI-for-age correction

  CDC developed extended percentiles (\>95%) to monitor high BMI values,
  if set to `TRUE` the CDC's correction is applied.

  Permitted values

  :   a logical scalar, i.e., a logical vector of length one, i.e.
      `TRUE`/`FALSE`

  Default value

  :   `FALSE`

- who_correction:

  WHO adjustment for weight-based indicators

  WHO constructed a restricted application of the LMS method for
  weight-based indicators. More details on these exact rules applied can
  be found at the document page 302 of the [WHO Child Growth Standards
  Guidelines](https://www.who.int/publications/i/item/924154693X). If
  set to `TRUE` the WHO correction is applied.

  Permitted values

  :   a logical scalar, i.e., a logical vector of length one, i.e.
      `TRUE`/`FALSE`

  Default value

  :   `FALSE`

- set_values_to_sds:

  Variables to be set for Z-Scores

  The specified variables are set to the specified values for the new
  observations. For example,
  `set_values_to_sds(exprs(PARAMCD = "BMIASDS", PARAM = "BMI-for-age z-score"))`
  defines the parameter code and parameter.

  The formula to calculate the Z-score is as follows:

  \$\$\frac{((\frac{obs}{M})^L - 1)}{L \* S}\$\$

  where "obs" is the observed value for the respective anthropometric
  measure being calculated.

  Permitted values

  :   List of variable-value pairs .

      If left as default value, `NULL`, then parameter not derived in
      output dataset.

  Default value

  :   `NULL`

- set_values_to_pctl:

  Variables to be set for Percentile

  The specified variables are set to the specified values for the new
  observations. For example,
  `set_values_to_pctl(exprs(PARAMCD = "BMIAPCTL", PARAM = "BMI-for-age percentile"))`
  defines the parameter code and parameter.

  Permitted values

  :   List of variable-value pairs .

      If left as default value, `NULL`, then parameter not derived in
      output dataset.

  Default value

  :   `NULL`

## Value

The input dataset additional records with the new parameter added.

## Details

### Age Unit Matching

This function requires that the age unit (`age_unit` parameter) in the
input dataset matches the age unit (`AGEU` variable) in the metadata
(`meta_criteria`). The function does NOT perform automatic age unit
conversion.

If records from the input dataset cannot be matched to the metadata due
to:

- Mismatched age units (e.g., data in days but metadata in months)

- Missing metadata for the specific age/sex combination

a warning (as shown in the example below) will be issued, listing the
number of unmatched records. These records will NOT appear in the output
dataset.

To resolve age unit mismatches, standardize your data before calling
this function.

## See also

Vital Signs Functions for adding Parameters/Records:
[`derive_params_growth_height()`](https://pharmaverse.github.io/admiralpeds/reference/derive_params_growth_height.md)

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
library(lubridate, warn.conflicts = FALSE)
library(rlang, warn.conflicts = FALSE)
library(admiral, warn.conflicts = FALSE)
library(pharmaversesdtm, warn.conflicts = FALSE)

advs <- pharmaversesdtm::dm_peds %>%
  select(USUBJID, BRTHDTC, SEX) %>%
  right_join(., pharmaversesdtm::vs_peds, by = "USUBJID") %>%
  mutate(
    VSDT = ymd(VSDTC),
    BRTHDT = ymd(BRTHDTC)
  ) %>%
  derive_vars_duration(
    new_var = AGECUR_D,
    new_var_unit = CURU_D,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "days",
    trunc_out = FALSE
  ) %>%
  derive_vars_duration(
    new_var = AGECUR_M,
    new_var_unit = CURU_M,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "months",
    trunc_out = FALSE
  ) %>%
  mutate(
    AGECUR = if_else(AGECUR_D >= 365.25 * 2, AGECUR_M, AGECUR_D),
    AGECURU = if_else(AGECUR_D >= 365.25 * 2, CURU_M, CURU_D)
  )

# metadata is in months
cdc_meta_criteria <- admiralpeds::cdc_htage %>%
  mutate(
    age_unit = "months",
    SEX = if_else(SEX == 1, "M", "F")
  )

# metadata is in days
who_meta_criteria <- bind_rows(
  (admiralpeds::who_lgth_ht_for_age_boys %>%
    mutate(
      SEX = "M",
      age_unit = "days"
    )
  ),
  (admiralpeds::who_lgth_ht_for_age_girls %>%
    mutate(
      SEX = "F",
      age_unit = "days"
    )
  )
) %>%
  rename(AGE = Day)

criteria <- bind_rows(
  cdc_meta_criteria,
  who_meta_criteria
) %>%
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
#> # A tibble: 7 × 47
#>   USUBJID     BRTHDTC   SEX   STUDYID DOMAIN VSSEQ VSTESTCD VSTEST VSPOS VSORRES
#>   <chr>       <chr>     <chr> <chr>   <chr>  <int> <chr>    <chr>  <chr> <chr>  
#> 1 01-701-1023 2010-08-… M     CDISCP… VS        55 HEIGHT   Height NA    88.75  
#> 2 01-701-1023 2010-08-… M     CDISCP… VS        59 HEIGHT   Height NA    89.23  
#> 3 01-701-1028 2010-07-… M     CDISCP… VS        63 HEIGHT   Height NA    98.32  
#> 4 01-701-1028 2010-07-… M     CDISCP… VS        67 HEIGHT   Height NA    98.95  
#> 5 01-701-1028 2010-07-… M     CDISCP… VS        75 HEIGHT   Height NA    99.68  
#> 6 01-701-1028 2010-07-… M     CDISCP… VS        83 HEIGHT   Height NA    100.45 
#> 7 01-701-1028 2010-07-… M     CDISCP… VS       103 HEIGHT   Height NA    102.82 
#> # ℹ 37 more variables: VSORRESU <chr>, VSSTRESC <chr>, VSSTRESN <dbl>,
#> #   VSSTRESU <chr>, VSSTAT <chr>, VSLOC <chr>, VSBLFL <chr>, VISITNUM <dbl>,
#> #   VISIT <chr>, VISITDY <int>, VSDTC <chr>, VSDY <int>, VSTPT <chr>,
#> #   VSTPTNUM <dbl>, VSELTM <chr>, VSTPTREF <chr>, VSEVAL <chr>, EPOCH <chr>,
#> #   VSDT <date>, BRTHDT <date>, AGECUR_D <dbl>, CURU_D <chr>, AGECUR_M <dbl>,
#> #   CURU_M <chr>, AGECUR <dbl>, AGECURU <chr>, sex_join <chr>, ageu_join <chr>,
#> #   age_bins <list>, metadata_age <dbl>, L <dbl>, M <dbl>, S <dbl>, …
#> Warning: ! 7 record(s) could not be matched to metadata (see printed records above).
#> ✖ Z-score (SDS) and/or percentile parameters could not be derived for these
#>   records.
#> ℹ This is most likely due to mismatched age units between data and metadata.
#> ℹ Data age unit must match metadata AGEU variable.
#> ℹ Conversion factors: 1 year = 365.25 days, 1 month = 30.4375 days, 1 week = 7
#>   days
#> ℹ Consider standardizing age units before calling this function.
#> # A tibble: 232 × 39
#>    USUBJID     BRTHDTC  SEX   STUDYID DOMAIN VSSEQ VSTESTCD VSTEST VSPOS VSORRES
#>    <chr>       <chr>    <chr> <chr>   <chr>  <int> <chr>    <chr>  <chr> <chr>  
#>  1 01-701-1015 2013-01… F     CDISCP… VS         1 BMI      BMI    NA    16.577…
#>  2 01-701-1015 2013-01… F     CDISCP… VS         5 BMI      BMI    NA    16.615…
#>  3 01-701-1015 2013-01… F     CDISCP… VS         9 BMI      BMI    NA    16.697…
#>  4 01-701-1015 2013-01… F     CDISCP… VS        13 BMI      BMI    NA    16.816…
#>  5 01-701-1015 2013-01… F     CDISCP… VS        17 BMI      BMI    NA    16.824…
#>  6 01-701-1015 2013-01… F     CDISCP… VS        21 BMI      BMI    NA    16.915…
#>  7 01-701-1015 2013-01… F     CDISCP… VS        25 BMI      BMI    NA    17.051…
#>  8 01-701-1015 2013-01… F     CDISCP… VS        29 BMI      BMI    NA    17.162…
#>  9 01-701-1015 2013-01… F     CDISCP… VS        33 BMI      BMI    NA    17.248…
#> 10 01-701-1015 2013-01… F     CDISCP… VS        37 BMI      BMI    NA    17.433…
#> # ℹ 222 more rows
#> # ℹ 29 more variables: VSORRESU <chr>, VSSTRESC <chr>, VSSTRESN <dbl>,
#> #   VSSTRESU <chr>, VSSTAT <chr>, VSLOC <chr>, VSBLFL <chr>, VISITNUM <dbl>,
#> #   VISIT <chr>, VISITDY <int>, VSDTC <chr>, VSDY <int>, VSTPT <chr>,
#> #   VSTPTNUM <dbl>, VSELTM <chr>, VSTPTREF <chr>, VSEVAL <chr>, EPOCH <chr>,
#> #   VSDT <date>, BRTHDT <date>, AGECUR_D <dbl>, CURU_D <chr>, AGECUR_M <dbl>,
#> #   CURU_M <chr>, AGECUR <dbl>, AGECURU <chr>, AVAL <dbl>, PARAMCD <chr>, …
```
