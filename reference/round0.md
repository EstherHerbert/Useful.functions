# Rounds numbers but keeps trailing zeros

This function is a shortcut for `formatC(x, digits, format = "f")`.

## Usage

``` r
round0(x, digits)
```

## Arguments

- x:

  a numeric vector

- digits:

  an integer indicating the number of decimal places

## Value

a character string

## Examples

``` r
round(5.601, 2)
#> [1] 5.6
round0(5.601, 2)
#> [1] "5.60"
```
