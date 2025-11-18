# Count and Percentage

Functions to display counts and percentages.

## Usage

``` r
pn(x, digits = 1, na_rm = FALSE, show_denom = FALSE, paren = "(", note = FALSE)

np(x, digits = 1, na_rm = FALSE, show_denom = FALSE, paren = "(")
```

## Arguments

- x:

  A boolean vector

- digits:

  Number of digits to display percentages to, default is 1

- na_rm:

  Logical indicating whether NAs should be removed from the calculation
  of the denominator, default is `FALSE`

- show_denom:

  Logical, should the denominator be shown, default is `FALSE`

- paren:

  String indicating which parentheses to use, options are `"("` (for ())
  or `"["` (for\[\])

- note:

  Should "n = " preface the count in `pn()`

## Examples

``` r
  pn(outcome$limp_yn == "Yes", note = TRUE)
#> [1] "18.8% (n = 113)"
  np(outcome$limp_yn == "Yes", show_denom = TRUE, na_rm = T)
#> [1] "113/565 (20%)"

```
