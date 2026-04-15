# Changelog

## admiralpeds (development version)

### Documentation

- Added a new vignette “Explore ADaM Templates” to the “Get Started”
  menu. It displays the
  [admiralpeds](https://pharmaverse.github.io/admiralpeds/) templates.
  ([\#132](https://github.com/pharmaverse/admiralpeds/issues/132))

### Various

Developer Notes

- Added the `Downloads` Badge and corrected the `Test Coverage` Badge.
  ([\#129](https://github.com/pharmaverse/admiralpeds/issues/129))

## admiralpeds 0.3.0

CRAN release: 2026-01-23

### Documentation

- Added the “Ask AI” widget to the the bottom right of each page. It
  enables users to ask questions about
  [admiralpeds](https://pharmaverse.github.io/admiralpeds/) and the rest
  of the [admiral](https://pharmaverse.github.io/admiral/) ecosystem and
  receive answers from an LLM. It is trained on the documentation of all
  [admiral](https://pharmaverse.github.io/admiral/) packages and
  provided by [kapa.ai](https://docs.kapa.ai/kapa-for-open-source).
  ([\#120](https://github.com/pharmaverse/admiralpeds/issues/120))

- Used custom [admiraldev](https://pharmaverse.github.io/admiraldev/)
  roclet, resulting in cleared “Permitted” and “Default” values in
  function documentation.
  ([\#112](https://github.com/pharmaverse/admiralpeds/issues/112))

- Added links to [admiral](https://pharmaverse.github.io/admiral/)
  ecosystem.
  ([\#114](https://github.com/pharmaverse/admiralpeds/issues/114))

- Updated the installation instructions in `README.md`.
  ([\#115](https://github.com/pharmaverse/admiralpeds/issues/115))

### Various

Developer Notes

- Updated [lintr](https://lintr.r-lib.org) configurations to use central
  configurations from
  [admiraldev](https://pharmaverse.github.io/admiraldev/).
  ([\#113](https://github.com/pharmaverse/admiralpeds/issues/113))

- Removed explicit [`return()`](https://rdrr.io/r/base/function.html)
  statements from
  [`derive_params_growth_age()`](https://pharmaverse.github.io/admiralpeds/dev/reference/derive_params_growth_age.md)
  and
  [`derive_params_growth_height()`](https://pharmaverse.github.io/admiralpeds/dev/reference/derive_params_growth_height.md).
  ([\#123](https://github.com/pharmaverse/admiralpeds/issues/123))

## admiralpeds 0.2.1

CRAN release: 2025-08-20

### Documentation

- Removed display of data types from the `WHO` metadata.
  ([\#104](https://github.com/pharmaverse/admiralpeds/issues/104))

### Various

Developer Notes

- Updated the company name as `Cytel Inc.` in `LICENSE.md`.
  ([\#109](https://github.com/pharmaverse/admiralpeds/issues/109))
- Added copyright holder logos.
  ([\#106](https://github.com/pharmaverse/admiralpeds/issues/106))
- Updated the default math-rendering to `mathjax`.
  ([\#104](https://github.com/pharmaverse/admiralpeds/issues/104))

## admiralpeds 0.2.0

CRAN release: 2025-01-16

### Updates of Template program

- `ADVS` template updated in line with {admiral} to calculate change
  from baseline variables only for post-baseline records.
  ([\#95](https://github.com/pharmaverse/admiralpeds/issues/95))

### Documentation

- Added CRAN installation instructions to README.
  ([\#10](https://github.com/pharmaverse/admiralpeds/issues/10))
- Subject based test data (e.g. DM, VS) has been migrated out of
  [admiralpeds](https://pharmaverse.github.io/admiralpeds/) to
  [pharmaversesdtm](https://pharmaverse.github.io/pharmaversesdtm/).
  ([\#40](https://github.com/pharmaverse/admiralpeds/issues/40))

## admiralpeds 0.1.0

CRAN release: 2024-08-21

- Initial package release focused mainly on Anthropometric indicators
  (i.e. child growth development charts).
