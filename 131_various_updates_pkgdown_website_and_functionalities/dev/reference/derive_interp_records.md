# Derive interpolated rows for the CDC charts (\>=2 yrs old)

Derive a linear interpolation of rows for the CDC charts (\>=2 yrs old)
by age in days for the following parameters: HEIGHT, WEIGHT and BMI

## Usage

``` r
derive_interp_records(dataset, by_vars = NULL, parameter)
```

## Arguments

- dataset:

  Input metadataset

  The variables `AGE`, `AGEU`, `SEX`, `L`, `M`, `S` are expected to be
  in the dataset

  For BMI the additional variables `P95` and `Sigma` are expected to be
  in the dataset

  Note that `AGE` must be in days so that `AGEU` is equal to `"DAYS"`

  Permitted values

  :   a dataset, i.e., a `data.frame` or tibble

  Default value

  :   none

- by_vars:

  Grouping variables

  The variable from `dataset` which identifies the group of observations
  to interpolate separately.

  Permitted values

  :   list of variables created by
      [`exprs()`](https://rlang.r-lib.org/reference/defusing-advanced.html),
      e.g., `exprs(SEX)`

  Default value

  :   `NULL`

- parameter:

  CDC/WHO metadata parameter

  Permitted values

  :   a character scalar, i.e., a character vector of length one .

      `"WEIGHT"`, `"HEIGHT"` or `"BMI"` only - Must not be `NULL` e.g.
      `parameter = "WEIGHT"`, `parameter = "HEIGHT"`, or
      `parameter = "BMI"`.

  Default value

  :   none

## Value

The input dataset plus additional interpolated records: a record for
each day from the minimum age to the maximum age.

If any variables in addition to the expected ones are in the input
dataset, LOCF (Last Observation Carried Forward) is applied to populate
them for the new records.

## See also

Metadata
[`cdc_bmiage`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/cdc_bmiage.md),
[`cdc_htage`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/cdc_htage.md),
[`cdc_wtage`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/cdc_wtage.md),
[`who_bmi_for_age_boys`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_bmi_for_age_boys.md),
[`who_bmi_for_age_girls`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_bmi_for_age_girls.md),
[`who_hc_for_age_boys`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_hc_for_age_boys.md),
[`who_hc_for_age_girls`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_hc_for_age_girls.md),
[`who_lgth_ht_for_age_boys`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_lgth_ht_for_age_boys.md),
[`who_lgth_ht_for_age_girls`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_lgth_ht_for_age_girls.md),
[`who_wt_for_age_boys`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_wt_for_age_boys.md),
[`who_wt_for_age_girls`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_wt_for_age_girls.md),
[`who_wt_for_lgth_boys`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_wt_for_lgth_boys.md),
[`who_wt_for_lgth_girls`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/who_wt_for_lgth_girls.md)

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
library(rlang, warn.conflicts = FALSE)

cdc_htage <- admiralpeds::cdc_htage %>%
  mutate(
    SEX = case_when(
      SEX == 1 ~ "M",
      SEX == 2 ~ "F",
      TRUE ~ NA_character_
    ),
    # Ensure first that Age unit is "DAYS"
    AGE = round(AGE * 30.4375),
    AGEU = "DAYS"
  )

# Interpolate the AGE by SEX
derive_interp_records(
  dataset = cdc_htage,
  by_vars = exprs(SEX),
  parameter = "HEIGHT"
)
#> # A tibble: 13,152 × 6
#>    SEX     AGE     L     M      S AGEU 
#>    <chr> <dbl> <dbl> <dbl>  <dbl> <chr>
#>  1 F       730  1.07  85.0 0.0408 DAYS 
#>  2 F       731  1.07  85.0 0.0408 DAYS 
#>  3 F       732  1.07  85.0 0.0408 DAYS 
#>  4 F       733  1.07  85.1 0.0408 DAYS 
#>  5 F       734  1.07  85.1 0.0408 DAYS 
#>  6 F       735  1.07  85.1 0.0408 DAYS 
#>  7 F       736  1.06  85.1 0.0408 DAYS 
#>  8 F       737  1.06  85.2 0.0408 DAYS 
#>  9 F       738  1.06  85.2 0.0408 DAYS 
#> 10 F       739  1.06  85.2 0.0408 DAYS 
#> # ℹ 13,142 more rows
```
