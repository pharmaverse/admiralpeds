

if (FALSE) {
# remove installed dplyr
pak::pkg_remove("dplyr")
  search()
  find.package("dplyr")  # expect error
  getNamespaceVersion("dplyr")

}


# CHOOSE ONE

if (FALSE) {
# install CRAN v 1.1.4
pak::pkg_install("dplyr")

# install dev  v. 1.1.4.9000
pak::pkg_install("tidyverse/dplyr")
}
# restart R/ load_all()   PROBLEM??
devtools::load_all()

# Check:
search()
find.package("dplyr")
print(getNamespaceVersion("admiralpeds"))
print(getNamespaceVersion("dplyr"))
print(packageVersion("dplyr"))
print(packageDate("dplyr"))
# ------------------------ legacy


## Test 1:
test_that("1 : > 1 is ok for CRAN, but throws error if version > 1.1.4", {

x <- 1
if (packageVersion("dplyr") !=  "1.1.4") {
  expect_warning(dplyr::case_when(
                 x == 1 ~ c("A", "B"),
                 .default = c("Z"))
                 )
} else {
expect_true(dplyr::case_when(
            x == 1 ~ c("A", "B"),
           .default = c("Z")
))

} # else

})

# Run all the examples !    fails on VSTESTCD
devtools::run_examples()

# get_cdc_data ----
## Test 1: CDC weight-for-age chart ----
test_that("get_cdc_data Test 1: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_wtage)
})

## Test 2: CDC height-for-age chart ----
test_that("get_cdc_data Test 2: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_htage)
})

## Test 3: CDC bmi-for-age chart ----
test_that("get_cdc_data Test 3: CDC weight-for-age chart", {
  expect_snapshot(admiralpeds::cdc_bmiage)
})



# ------------------------ prior tests


# at 5JAN2026   - copy of examples from dplyr case_when.R

# CRAN version is 1.1.4,  date  2023-11-17

# Should fail if  dplyr version > 1.4
packageVersion("dplyr")  # 1.1.4.9000
x <- 1


#' @examples
#' x <- 1:70
#' case_when(
#'   x %% 35 == 0 ~ "fizz buzz",
#'   x %% 5 == 0 ~ "fizz",
#'   x %% 7 == 0 ~ "buzz",
#'   .default = as.character(x)
#' )
#'
#' # Like an if statement, the arguments are evaluated in order, so you must
#' # proceed from the most specific to the most general. This won't work:
#' case_when(
#'   x %% 5 == 0 ~ "fizz",
#'   x %% 7 == 0 ~ "buzz",
#'   x %% 35 == 0 ~ "fizz buzz",
#'   .default = as.character(x)
#' )
#'
#' # If none of the cases match and no `.default` is supplied, NA is used:
#' case_when(
#'   x %% 35 == 0 ~ "fizz buzz",
#'   x %% 5 == 0 ~ "fizz",
#'   x %% 7 == 0 ~ "buzz"
#' )
#'
#' # Note that `NA` values on the LHS are treated like `FALSE` and will be
#' # assigned the `.default` value. You must handle them explicitly if you
#' # want to use a different value. The exact way to handle missing values is
#' # dependent on the set of LHS conditions you use.
#' x[2:4] <- NA_real_
#' case_when(
#'   x %% 35 == 0 ~ "fizz buzz",
#'   x %% 5 == 0 ~ "fizz",
#'   x %% 7 == 0 ~ "buzz",
#'   is.na(x) ~ "nope",
#'   .default = as.character(x)
#' )
#'
#' # `case_when()` is not a replacement for basic if/else control flow. When
#' # you have a single scalar condition, using if/else is faster, simpler to
#' # reason about, and is lazy on the branch that isn't run. For example, this
#' # seems to work:
#' x <- "value"
#' case_when(is.character(x) ~ x, .default = "not-a-character")
#'
#' # Until `x` is a non-character type
#' x <- 1
#' try(case_when(is.character(x) ~ x, .default = "not-a-character"))
#'
#' # Instead, you should use if/else
#' if (is.character(x)) {
#'   y <- x
#' } else {
#'   y <- "not-a-character"
#' }
#' y
#'
#' # If you believe that you've covered every possible case, then set
#' # `.unmatched = "error"` rather than supplying a `.default`. This adds an
#' # extra layer of safety to `case_when()` and is particularly useful when you
#' # have a series of complex expressions!
#' set.seed(123)
#' x <- sample(50)
#'
test_that("Oops, we forgot to handle `50`", {

  expect_error(
#' try(case_when(
#'   x < 10 ~ "ten",
#'   x < 20 ~ "twenty",
#'   x < 30 ~ "thirty",
#'   x < 40 ~ "forty",
#'   x < 50 ~ "fifty",
#'   .unmatched = "error"
#' ))
  )
})

#'
#' case_when(
#'   x < 10 ~ "ten",
#'   x < 20 ~ "twenty",
#'   x < 30 ~ "thirty",
#'   x < 40 ~ "forty",
#'   x <= 50 ~ "fifty",
#'   .unmatched = "error"
#' )
#'
#' # Note that `NA` is considered unmatched and must be handled with its own
#' # explicit case, even if that case just propagates the missing value!
#' x[c(2, 5)] <- NA
#'
#' case_when(
#'   x < 10 ~ "ten",
#'   x < 20 ~ "twenty",
#'   x < 30 ~ "thirty",
#'   x < 40 ~ "forty",
#'   x <= 50 ~ "fifty",
#'   is.na(x) ~ NA,
#'   .unmatched = "error"
#' )
#'
#' # `replace_when()` is useful when you're updating an existing vector,
#' # rather than creating an entirely new one. Note the so-far unused "puppy"
#' # factor level:
#' pets <- tibble(
#'   name = c("Max", "Bella", "Chuck", "Luna", "Cooper"),
#'   type = factor(
#'     c("dog", "dog", "cat", "dog", "cat"),
#'     levels = c("dog", "cat", "puppy")
#'   ),
#'   age = c(1, 3, 5, 2, 4)
#' )
#'
#' # We can replace some values with `"puppy"` based on arbitrary conditions.
#' # Even though we are using a character `"puppy"` value, `replace_when()` will
#' # automatically cast it to the factor type of `type` for us.
#' pets |>
#'   mutate(
#'     type = replace_when(type, type == "dog" & age <= 2 ~ "puppy")
#'   )
#'
#' # Compare that with this `case_when()` call, which loses the factor class.
#' # It's always better to use `replace_when()` when updating a few values in
#' # an existing vector!
#' pets |>
#'   mutate(
#'     type = case_when(type == "dog" & age <= 2 ~ "puppy", .default = type)
#'   )
#'
#' # `case_when()` and `replace_when()` evaluate all RHS expressions, and then
#' # construct their result by extracting the selected (via the LHS expressions)
#' # parts. For example, `NaN`s are produced here because `sqrt(y)` is evaluated
#' # on all of `y`, not just where `y >= 0`.
#' y <- seq(-2, 2, by = .5)
#' replace_when(y, y >= 0 ~ sqrt(y))
#'
#' # These functions are particularly useful inside `mutate()` when you want to
#' # create a new variable that relies on a complex combination of existing
#' # variables
#' starwars |>
#'   select(name:mass, gender, species) |>
#'   mutate(
#'     type = case_when(
#'       height > 200 | mass > 200 ~ "large",
#'       species == "Droid" ~ "robot",
#'       .default = "other"
#'     )
#'   )
#'
#' # `case_when()` is not a tidy eval function. If you'd like to reuse
#' # the same patterns, extract the `case_when()` call into a normal
#' # function:
#' case_character_type <- function(height, mass, species) {
#'   case_when(
#'     height > 200 | mass > 200 ~ "large",
#'     species == "Droid" ~ "robot",
#'     .default = "other"
#'   )
#' }
#'
#' case_character_type(150, 250, "Droid")
#' case_character_type(150, 150, "Droid")
#'
#' # Such functions can be used inside `mutate()` as well:
#' starwars |>
#'   mutate(type = case_character_type(height, mass, species)) |>
#'   pull(type)
#'
#' # `case_when()` ignores `NULL` inputs. This is useful when you'd
#' # like to use a pattern only under certain conditions. Here we'll
#' # take advantage of the fact that `if` returns `NULL` when there is
#' # no `else` clause:
#' case_character_type <- function(height, mass, species, robots = TRUE) {
#'   case_when(
#'     height > 200 | mass > 200 ~ "large",
#'     if (robots) species == "Droid" ~ "robot",
#'     .default = "other"
#'   )
#' }
#'
#' starwars |>
#'   mutate(type = case_character_type(height, mass, species, robots = FALSE)) |>
#'   pull(type)
#'
#' # `replace_when()` can also be used in combination with `pick()` to
#' # conditionally mutate rows within multiple columns using a single condition.
#' # Here `replace_when()` returns a data frame with new `species` and `name`
#' # columns, which `mutate()` then automatically unpacks.
#' starwars |>
#'   select(homeworld, species, name) |>
#'   mutate(replace_when(
#'     pick(species, name),
#'     homeworld == "Tatooine" ~ tibble(
#'       species = "Tatooinese",
#'       name = paste(name, "(Tatooine)")
#'     )
#'   ))
NULL
