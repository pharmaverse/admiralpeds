# Get Started

## Introduction

As this is a package extension, if you are new to
[admiral](https://pharmaverse.github.io/admiral/) then the best place to
first start reading would be the [Get
Started](https://pharmaverse.github.io/admiral/articles/admiral.html)
page. This extension package follows the same main idea and conventions,
and re-uses many functions from
[admiral](https://pharmaverse.github.io/admiral/), so it is important to
thoroughly understand these to be able to use
[admiralpeds](https://pharmaverse.github.io/admiralpeds/).

## Creating Pediatrics ADaM Datasets

You can see guidance on how to create select ADaMs for pediatric
clinical trials by reading our vignettes under the User Guides section
of this site.

[admiralpeds](https://pharmaverse.github.io/admiralpeds/) also provides
template R scripts as a starting point. They can be created by calling
[`use_ad_template()`](https:/pharmaverse.github.io/admiral/v1.4.1/cran-release/reference/use_ad_template.html)
from [admiral](https://pharmaverse.github.io/admiral/), e.g.,

``` r
library(admiral)
```

``` r
use_ad_template(
  adam_name = "advs",
  save_path = "./ad_advs.R",
  package = "admiralpeds"
)
```

A list of all available templates can be obtained by
[`list_all_templates()`](https:/pharmaverse.github.io/admiral/v1.4.1/cran-release/reference/list_all_templates.html)
from [admiral](https://pharmaverse.github.io/admiral/):

``` r
list_all_templates(package = "admiralpeds")
```

## Support

Support is provided via [pharmaverse
Slack](https://pharmaverse.slack.com/).
