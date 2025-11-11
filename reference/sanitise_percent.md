# Sanitise function for use with `print.xtable`

Takes a string of text and sanitises only the use of "%" for use with
latex

## Usage

``` r
sanitise_percent(str)
```

## Arguments

- str:

  String of text

## Examples

``` r
    str <- "\\multirow{2}{4cm}{75%}"
    sanitise_percent(str)
#> [1] "\\multirow{2}{4cm}{75\\%}"
```
