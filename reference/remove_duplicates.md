# For use with tables

Turns duplicate rows into NAs

## Usage

``` r
remove_duplicates(x, keepLast = FALSE)
```

## Arguments

- x:

  Character vector

- keepLast:

  Logical indicating whether the last incidence should be kept instead
  of the first (which is the default).

## Value

A character string/vector

## Examples

``` r
    x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
    remove_duplicates(x)
#>  [1] "a" NA  NA  NA  NA  "c" NA  "y" NA  NA  NA  NA  NA  NA 
```
