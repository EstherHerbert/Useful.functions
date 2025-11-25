# Median (IQR)

Calculates ad formats the median and interquartile range.

## Usage

``` r
median_iqr(x, digits = 2, na_rm = FALSE, show_n = FALSE, note = FALSE)
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

  should "IQR " be written inside the brackets, default is `FALSE`

## Examples

``` r
  median_iqr(outcome$score, na_rm = TRUE)
#> [1] "5.11 (3.24, 7.22)"
  median_iqr(outcome$score, na_rm = TRUE, show_n = TRUE)
#> [1] "527; 5.11 (3.24, 7.22)"
  median_iqr(outcome$score, na_rm = T, note = TRUE)
#> [1] "5.11 (IQR 3.24, 7.22)"
```
