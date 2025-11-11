# For use with latex summary tables

Turns duplicate rows which occur together into NAs and adds multirow to
the remaining rows.

## Usage

``` r
add_multirow(
  x,
  width = "*",
  pos = "t",
  rows = .,
  reverse = FALSE,
  hline = TRUE
)
```

## Arguments

- x:

  Character vector

- width:

  Desired width of column to be passed to multirow in latex. e.g.
  `"4cm"`

- pos:

  Character defining the vertical positioning of the text in the
  multirow block. Default is "t" - top. Other options are "c" for centre
  or "b" for bottom.

- rows:

  Optional number of rows to use, if not given then `add_multirow`
  calculates how many rows to use.

- reverse:

  If `TRUE` then all by the last duplicate will be removed. If rows
  isn't given then the calculated number of rows will be negated. This
  features is useful when colouring tables.

- hline:

  Logical indicating whether a hline should be added to the start of
  each multirow.

## Value

A character string/vector

## Examples

``` r
    x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
    add_multirow(x)
#>  [1] "\\hline\n\\multirow[t]{5}{*}{a}" NA                               
#>  [3] NA                                NA                               
#>  [5] NA                                "\\hline\n\\multirow[t]{2}{*}{c}"
#>  [7] NA                                "\\hline\n\\multirow[t]{7}{*}{y}"
#>  [9] NA                                NA                               
#> [11] NA                                NA                               
#> [13] NA                                NA                               
    add_multirow(x, reverse = TRUE)
#>  [1] NA                                 NA                                
#>  [3] NA                                 NA                                
#>  [5] "\\hline\n\\multirow[t]{-5}{*}{a}" NA                                
#>  [7] "\\hline\n\\multirow[t]{-2}{*}{c}" NA                                
#>  [9] NA                                 NA                                
#> [11] NA                                 NA                                
#> [13] NA                                 "\\hline\n\\multirow[t]{-7}{*}{y}"
    add_multirow(x, width = "2cm", pos = "c")
#>  [1] "\\hline\n\\multirow[c]{5}{2cm}{a}" NA                                 
#>  [3] NA                                  NA                                 
#>  [5] NA                                  "\\hline\n\\multirow[c]{2}{2cm}{c}"
#>  [7] NA                                  "\\hline\n\\multirow[c]{7}{2cm}{y}"
#>  [9] NA                                  NA                                 
#> [11] NA                                  NA                                 
#> [13] NA                                  NA                                 
```
