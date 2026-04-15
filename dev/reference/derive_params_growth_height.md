# Derive Anthropometric indicators (Z-Scores/Percentiles-for-Height/Length) based on Standard Growth Charts

Derive Anthropometric indicators
(Z-Scores/Percentiles-for-Height/Length) based on Standard Growth Charts
for Weight by Height/Length

## Usage

``` r
derive_params_growth_height(
  dataset,
  sex,
  height,
  height_unit,
  meta_criteria,
  parameter,
  analysis_var,
  who_correction = FALSE,
  set_values_to_sds = NULL,
  set_values_to_pctl = NULL
)
```

## Arguments

- dataset:

  Input dataset

  The variables specified in `sex`, `height`, `height_unit`,
  `parameter`, `analysis_var` are expected to be in the dataset.

  Permitted values

  :   a dataset, i.e., a `data.frame` or tibble

  Default value

  :   none

- sex:

  Sex

  Permitted values

  :   a character scalar, i.e., a character vector of length one .

      Expected values: `M`, `F`.

  Default value

  :   none

- height:

  Current Height/length

  Permitted values

  :   a numeric scalar, i.e., a numeric vector of length one .

      Note that this is the actual height/length at the current visit.

  Default value

  :   none

- height_unit:

  Height/Length Unit

  Permitted values

  :   a character scalar, i.e., a character vector of length one .

      Expected values: `cm`.

  Default value

  :   none

- meta_criteria:

  Metadata dataset

  A metadata dataset with the following expected variables:
  `HEIGHT_LENGTH`, `HEIGHT_LENGTHU`, `SEX`, `L`, `M`, `S`

  The dataset can be derived from WHO or user-defined datasets. The WHO
  growth chart metadata datasets are available in the package and will
  require small modifications.

  Datasets `who_wt_for_lgth_boys`/`who_wt_for_lgth_girls` are applicable
  for subject age \< 730.5 days.

  If the `height` value from `dataset` falls between two `HEIGHT_LENGTH`
  values in `meta_criteria`, then the `L`/`M`/`S` values that are
  chosen/mapped will be the `HEIGHT_LENGTH` that has the smaller
  absolute difference to the value in `height`. e.g. If dataset has a
  current age of 50.49 cm, and the metadata contains records for 50 and
  51 cm, the `L`/`M`/`S` corresponding to the 50 cm record will be used.

  - `HEIGHT_LENGTH` - Height/Length

  - `HEIGHT_LENGTHU` - Height/Length Unit

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

  There is WHO metadata available for Weight available in the
  `admiralpeds` package. Weight measures are expected to be in the unit
  "kg".

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
  `set_values_to_sds(exprs(PARAMCD = "WGTHSDS", PARAM = "Weight-for-height z-score"))`
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
  `set_values_to_pctl(exprs(PARAMCD = "WGTHPCTL", PARAM = "Weight-for-height percentile"))`
  defines the parameter code and parameter.

  Permitted values

  :   List of variable-value pairs .

      If left as default value, `NULL`, then parameter not derived in
      output dataset.

  Default value

  :   `NULL`

## Value

The input dataset additional records with the new parameter added.

## See also

Vital Signs Functions for adding Parameters/Records
[`derive_params_growth_age()`](https://pharmaverse.github.io/admiralpeds/dev/reference/derive_params_growth_age.md)

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
library(lubridate, warn.conflicts = FALSE)
library(rlang, warn.conflicts = FALSE)
library(admiral, warn.conflicts = FALSE)
library(pharmaversesdtm, warn.conflicts = FALSE)

# derive weight for height/length only for those under 2 years old using WHO
# weight for length reference file
advs <- pharmaversesdtm::dm_peds %>%
  select(USUBJID, BRTHDTC, SEX) %>%
  right_join(., pharmaversesdtm::vs_peds, by = "USUBJID") %>%
  mutate(
    VSDT = ymd(VSDTC),
    BRTHDT = ymd(BRTHDTC)
  ) %>%
  derive_vars_duration(
    new_var = AAGECUR,
    new_var_unit = AAGECURU,
    start_date = BRTHDT,
    end_date = VSDT,
    out_unit = "days"
  )

heights <- pharmaversesdtm::vs_peds %>%
  filter(VSTESTCD == "HEIGHT") %>%
  select(USUBJID, VSSTRESN, VSSTRESU, VSDTC) %>%
  rename(
    HGTTMP = VSSTRESN,
    HGTTMPU = VSSTRESU
  )

advs <- advs %>%
  right_join(., heights, by = c("USUBJID", "VSDTC"))

advs_under2 <- advs %>%
  filter(AAGECUR < 730.5)

who_under2 <- bind_rows(
  (admiralpeds::who_wt_for_lgth_boys %>%
    mutate(
      SEX = "M",
      height_unit = "cm"
    )
  ),
  (admiralpeds::who_wt_for_lgth_girls %>%
    mutate(
      SEX = "F",
      height_unit = "cm"
    )
  )
) %>%
  rename(
    HEIGHT_LENGTH = Length,
    HEIGHT_LENGTHU = height_unit
  )

derive_params_growth_height(
  advs_under2,
  sex = SEX,
  height = HGTTMP,
  height_unit = HGTTMPU,
  meta_criteria = who_under2,
  parameter = VSTESTCD == "WEIGHT",
  analysis_var = VSSTRESN,
  who_correction = TRUE,
  set_values_to_sds = exprs(
    PARAMCD = "WGTHSDS",
    PARAM = "Weight-for-height/length z-score"
  ),
  set_values_to_pctl = exprs(
    PARAMCD = "WGTHPCTL",
    PARAM = "Weight-for-height/length percentile"
  )
)
#> # A tibble: 162 × 37
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
#> # ℹ 152 more rows
#> # ℹ 27 more variables: VSORRESU <chr>, VSSTRESC <chr>, VSSTRESN <dbl>,
#> #   VSSTRESU <chr>, VSSTAT <chr>, VSLOC <chr>, VSBLFL <chr>, VISITNUM <dbl>,
#> #   VISIT <chr>, VISITDY <int>, VSDTC <chr>, VSDY <int>, VSTPT <chr>,
#> #   VSTPTNUM <dbl>, VSELTM <chr>, VSTPTREF <chr>, VSEVAL <chr>, EPOCH <chr>,
#> #   VSDT <date>, BRTHDT <date>, AAGECUR <dbl>, AAGECURU <chr>, HGTTMP <dbl>,
#> #   HGTTMPU <chr>, AVAL <dbl>, PARAMCD <chr>, PARAM <chr>
```
