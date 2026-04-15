# CDC BMI-for-age-chart

BMI-for-age charts, 2 to 20.5 years

## Usage

``` r
cdc_bmiage
```

## Format

A data frame with 438 rows and 7 variables:

- `SEX`:

  Sex: 1 = male, 2 = female

- `AGE`:

  Age in months

- `L`:

  Box-Cox transformation for normality

- `M`:

  Median

- `S`:

  Coefficient of variation

- `Sigma`:

  Sigma

- `P95`:

  95th Percentile

## Source

<https://www.cdc.gov/growthcharts/percentile_data_files.htm>

## See also

Metadata
[`cdc_htage`](https://pharmaverse.github.io/admiralpeds/dev/reference/cdc_htage.md),
[`cdc_wtage`](https://pharmaverse.github.io/admiralpeds/dev/reference/cdc_wtage.md),
[`derive_interp_records()`](https://pharmaverse.github.io/admiralpeds/dev/reference/derive_interp_records.md),
[`who_bmi_for_age_boys`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_bmi_for_age_boys.md),
[`who_bmi_for_age_girls`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_bmi_for_age_girls.md),
[`who_hc_for_age_boys`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_hc_for_age_boys.md),
[`who_hc_for_age_girls`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_hc_for_age_girls.md),
[`who_lgth_ht_for_age_boys`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_lgth_ht_for_age_boys.md),
[`who_lgth_ht_for_age_girls`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_lgth_ht_for_age_girls.md),
[`who_wt_for_age_boys`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_wt_for_age_boys.md),
[`who_wt_for_age_girls`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_wt_for_age_girls.md),
[`who_wt_for_lgth_boys`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_wt_for_lgth_boys.md),
[`who_wt_for_lgth_girls`](https://pharmaverse.github.io/admiralpeds/dev/reference/who_wt_for_lgth_girls.md)
