# Produce a dataframe to summarise ticked variables

Takes a dataframe and produces the number and percentage for ticked
variables.

## Usage

``` r
ticked_table(
  df = .,
  ...,
  group,
  sep,
  digits = 1,
  total = TRUE,
  n = FALSE,
  boolean = FALSE,
  condense = FALSE
)
```

## Arguments

- df:

  Data Frame

- ...:

  Variables to be summarised

- group:

  Optional variable that defines the grouping

- sep:

  Optional separator between columns for splitting variable into
  variable and scoring. See ?tidyr::separate for more information.

- digits:

  Number of digits to the right of the decimal point

- total:

  Logical indicating whether a total column should be created

- n:

  Logical indicating whether the second header row should be converted
  into a row of denominators. Helpful for when `ticked_table()` forms
  part of a larger table. Default is `FALSE`

- boolean:

  Logical indicating whether the variables are already coded as
  TRUE/FALSE or 0/1. Default is `FALSE`

- condense:

  **\[deprecated\]** `condense = TRUE` is deprecated, use
  [`condense()`](https://estherherbert.github.io/Useful.functions/reference/condense.md)
  instead.

## Value

A tibble data frame summarising the data

## Examples

``` r
  ticked_table(outcome, pet_cat, pet_dog, group = group, sep = "_")
#> # A tibble: 3 × 5
#>   variable scoring A          B           Total      
#>   <chr>    <chr>   <chr>      <chr>       <chr>      
#> 1 NA       NA      N = 276    N = 324     N = 600    
#> 2 pet      cat     48 (17.4%) 75 (23.1%)  123 (20.5%)
#> 3 pet      dog     96 (34.8%) 105 (32.4%) 201 (33.5%)

  ticked_table(outcome, pet_fish, pet_dog)
#> # A tibble: 3 × 2
#>   scoring  value      
#>   <chr>    <chr>      
#> 1 NA       N = 600    
#> 2 pet_fish 99 (16.5%) 
#> 3 pet_dog  201 (33.5%)

  ticked_table(outcome, pet_fish, pet_dog, sep = "_", n = TRUE)
#> # A tibble: 3 × 3
#>   variable scoring value      
#>   <chr>    <chr>   <chr>      
#> 1 pet      n       600        
#> 2 pet      fish    99 (16.5%) 
#> 3 pet      dog     201 (33.5%)
```
