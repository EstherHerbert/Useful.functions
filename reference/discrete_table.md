# Produce a data frame to summarise discrete variables

Takes a data frame and produces the number and percentage for discrete
variables.

## Usage

``` r
discrete_table(
  df = .,
  ...,
  group,
  time,
  total = TRUE,
  n = FALSE,
  missing = "Missing",
  accuracy = 0.1,
  drop.levels = FALSE,
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

- time:

  Optional variable for repeated measures (currently must me used with
  group)

- total:

  Logical indicating whether a total column should be created

- n:

  Logical indicating whether percentages should be out of n (`n = TRUE`)
  or N (`n = FALSE`)

- missing:

  String determining what missing data will be called (if `n = TRUE`).
  Default is "Missing".

- accuracy:

  see details of
  [`scales::label_percent()`](https://scales.r-lib.org/reference/label_percent.html)

- drop.levels:

  logical indicating whether unused levels in the factors should be
  dropped. Default is `FALSE`.

- condense:

  **\[deprecated\]** `condense = TRUE` is deprecated, use
  [`condense()`](https://estherherbert.github.io/Useful.functions/reference/condense.md)
  instead.

## Value

A tibble data frame summarising the data

## Examples

``` r
    discrete_table(outcome, sex, group = group)
#> # A tibble: 5 × 5
#>   variable scoring               A           B           Total      
#>   <chr>    <chr>                 <chr>       <chr>       <chr>      
#> 1 NA       NA                    N = 276     N = 324     N = 600    
#> 2 sex      Female                144 (52.2%) 159 (49.1%) 303 (50.5%)
#> 3 sex      Male                  129 (46.7%) 162 (50.0%) 291 (48.5%)
#> 4 sex      Prefer not to specify 0 (0.0%)    0 (0.0%)    0 (0.0%)   
#> 5 sex      Missing               3 (1.1%)    3 (0.9%)    6 (1.0%)   
    discrete_table(outcome, sex, drop.levels = TRUE)
#> # A tibble: 4 × 3
#>   variable scoring value      
#>   <chr>    <chr>   <chr>      
#> 1 NA       NA      N = 600    
#> 2 sex      Female  303 (50.5%)
#> 3 sex      Male    291 (48.5%)
#> 4 sex      Missing 6 (1.0%)   
    discrete_table(outcome, sex, group = group, time = event_name, n = TRUE,
                   total = FALSE)
#> # A tibble: 13 × 5
#>    event_name variable scoring               A          B         
#>    <chr>      <chr>    <chr>                 <chr>      <chr>     
#>  1 NA         NA       NA                    N = 92     N = 108   
#>  2 Baseline   sex      n                     91         107       
#>  3 Baseline   sex      Female                48 (52.7%) 53 (49.5%)
#>  4 Baseline   sex      Male                  43 (47.3%) 54 (50.5%)
#>  5 Baseline   sex      Prefer not to specify 0 (0.0%)   0 (0.0%)  
#>  6 6 Weeks    sex      n                     91         107       
#>  7 6 Weeks    sex      Female                48 (52.7%) 53 (49.5%)
#>  8 6 Weeks    sex      Male                  43 (47.3%) 54 (50.5%)
#>  9 6 Weeks    sex      Prefer not to specify 0 (0.0%)   0 (0.0%)  
#> 10 12 Weeks   sex      n                     91         107       
#> 11 12 Weeks   sex      Female                48 (52.7%) 53 (49.5%)
#> 12 12 Weeks   sex      Male                  43 (47.3%) 54 (50.5%)
#> 13 12 Weeks   sex      Prefer not to specify 0 (0.0%)   0 (0.0%)  
```
