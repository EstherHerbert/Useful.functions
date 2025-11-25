# Mean (SD)

Calculates and formats the mean and standard deviation.

## Usage

``` r
mean_sd(
  x,
  digits = 2,
  na_rm = FALSE,
  show_n = FALSE,
  note = FALSE,
  unit = NULL
)
```

## Arguments

- x:

  numeric vector

- digits:

  number of digits to round mean and standard deviation to

- na_rm:

  remove `NA` values, default is `FALSE`

- show_n:

  Should the denominator be shown, default is `FALSE`

- note:

  should "SD " be written inside the brackets, default is `FALSE`

- unit:

  optional character string giving unit, e.g., "kg"

## Examples

``` r
  mean_sd(outcome$score, na_rm = TRUE)
#> [1] "5.36 (2.93)"
  mean_sd(outcome$score, na_rm = TRUE, show_n = TRUE)
#> [1] "527; 5.36 (2.93)"
  mean_sd(outcome$score, na_rm = T, note = TRUE)
#> [1] "5.36 (SD 2.93)"
```
