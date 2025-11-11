# For use with `xtable`'s `add.to.row`

Collapses a vector into a character string separated by "&".

## Usage

``` r
makerow(x, hline = FALSE)
```

## Arguments

- x:

  A vector or single row of a data frame (which is then converted to a
  vector within the function)

- hline:

  Logical indicating whether a hline is needed after the row

## Value

A single character string

## Examples

``` r
  x <- c("A", 125, "Apple", 0.2, "75g")
  makerow(x)
#> [1] "A & 125 & Apple & 0.2 & 75g \\\\"
  makerow(x, hline = TRUE)
#> [1] "A & 125 & Apple & 0.2 & 75g \\\\\\hline"
```
