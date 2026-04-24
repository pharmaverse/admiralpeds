# Get Bins of Metadata

Creates unique age/heights-bins for each record to speed up joining

## Usage

``` r
get_bins(meta_criteria, param)
```

## Arguments

- meta_criteria:

  Metadata dataset

  A metadata dataset that is the same as that in
  [`derive_params_growth_age()`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/derive_params_growth_age.md)/[`derive_params_growth_height()`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/derive_params_growth_height.md)

  Default value

  :   none

- param:

  Character vector

  Accepted values: "AGE"/"HEIGHT_LENGTH"

  Default value

  :   none

## Value

list of breaks and labels for age/height bins

## See also

Other internal:
[`admiralpeds-package`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/admiralpeds-package.md),
[`find_closest_bin()`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/find_closest_bin.md),
[`set_bins()`](https:/pharmaverse.github.io/admiralpeds/131_various_updates_pkgdown_website_and_functionalities/dev/reference/set_bins.md)
