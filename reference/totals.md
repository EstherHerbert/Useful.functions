# Mutates data frame so that summary tables give totals

This function uses `stata_expand` and
[`dplyr::mutate`](https://dplyr.tidyverse.org/reference/mutate.html) to
give a data frame that, when summarised, with give total rows and/or
columns.

## Usage

``` r
totals(df = ., ..., name = "Total")
```

## Arguments

- df:

  A data frame

- ...:

  one or two columns for which we require totals

- name:

  Character string for the name of the total row/column

## Examples

``` r
    df <- totals(mtcars, cyl)
    dplyr::count(df)
#>    n
#> 1 64
```
