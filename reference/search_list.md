# Searches a list of dataframes.

Takes a list of dataframes and searches their variables for either a
specific variable name or for a string within the variable names.

## Usage

``` r
search_list(ls, string, exact = TRUE, ignore.case = FALSE)
```

## Arguments

- ls:

  A list of dataframes

- string:

  A string, either the exact variable name or something to search for.

- exact:

  Logical. If `exact = TRUE` then `search_list` finds the exact
  variable, if `exact = FALSE` then `search_list` finds all variable
  names containing that string using
  [`stringr::str_detect()`](https://stringr.tidyverse.org/reference/str_detect.html).

- ignore.case:

  Logical. Determines whether to ignore case when `exact = FALSE`.

## Value

A data.frame

## Examples

``` r
files <- list(mtcars = mtcars, iris = iris)
search_list(files, "Sepal", exact = FALSE)
#>   file     variable
#> 1 iris Sepal.Length
#> 2 iris  Sepal.Width
search_list(files, "hp")
#>     file variable
#> 1 mtcars       hp
```
