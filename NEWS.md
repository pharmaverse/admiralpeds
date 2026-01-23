# admiralpeds 0.3.0

## Documentation

- Added the "Ask AI" widget to the the bottom right of each page. It enables users to ask questions about `{admiralpeds}` and the
rest of the `{admiral}` ecosystem and receive answers from an LLM. It is trained on the documentation of all `{admiral}` packages
and provided by [kapa.ai](https://docs.kapa.ai/kapa-for-open-source). (#120)

- Used custom `{admiraldev}` roclet, resulting in cleared "Permitted" and "Default" values in function documentation. (#112)

- Added links to `{admiral}` ecosystem. (#114)

- Updated the installation instructions in `README.md`. (#115)

## Various

<details>

<summary>Developer Notes</summary>

* Updated `{lintr}` configurations to use central configurations from `{admiraldev}`. (#113)

* Removed explicit `return()` statements from `derive_params_growth_age()` and `derive_params_growth_height()`. (#123)

</details>

# admiralpeds 0.2.1

## Documentation

- Removed display of data types from the `WHO` metadata. (#104)

## Various

<details>

<summary>Developer Notes</summary>

* Updated the company name as `Cytel Inc.` in `LICENSE.md`. (#109)
* Added copyright holder logos. (#106)
* Updated the default math-rendering to `mathjax`. (#104)

</details>

# admiralpeds 0.2.0

## Updates of Template program

- `ADVS` template updated in line with {admiral} to calculate change from baseline variables only for post-baseline records. (#95)

## Documentation

- Added CRAN installation instructions to README. (#10)
- Subject based test data (e.g. DM, VS) has been migrated out of `{admiralpeds}` to `{pharmaversesdtm}`. (#40)

# admiralpeds 0.1.0

- Initial package release focused mainly on Anthropometric indicators (i.e. child growth development charts).
