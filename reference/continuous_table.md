# Produce a data frame to summaries continuous variables

Takes a data frame and produces grouped or un-grouped summaries such as
mean and standard deviation for continuous variables.

## Usage

``` r
continuous_table(
  df = .,
  ...,
  group,
  time,
  total = TRUE,
  digits = 2,
  condense = FALSE
)
```

## Arguments

- df:

  Data frame

- ...:

  Variables to be summarised

- group:

  Optional variable that defines the grouping

- time:

  Optional variable for repeated measures (currently must me used with
  group)

- total:

  Logical indicating whether a total column should be created

- digits:

  Number of digits to the right of the decimal point

- condense:

  **\[deprecated\]** `condense = TRUE` is deprecated, use
  [`condense()`](https://estherherbert.github.io/Useful.functions/reference/condense.md)
  instead.

## Value

A tibble data frame summarising the data

## Examples

``` r
    continuous_table(outcome, score, group = group)
#> # A tibble: 5 × 5
#>   variable scoring      A                 B                 Total            
#>   <chr>    <chr>        <chr>             <chr>             <chr>            
#> 1 NA       NA           N = 276           N = 324           N = 600          
#> 2 score    n            247               280               527              
#> 3 score    Mean (SD)    4.12 (2.23)       6.46 (3.04)       5.36 (2.93)      
#> 4 score    Median (IQR) 4.27 (2.59, 5.54) 6.20 (4.45, 8.74) 5.11 (3.24, 7.22)
#> 5 score    Min, Max     -2.24, 9.89       -1.01, 14.58      -2.24, 14.58     
    continuous_table(outcome, score, group = group, condense = FALSE,
                     total = FALSE)
#> # A tibble: 5 × 4
#>   variable scoring      A                 B                
#>   <chr>    <chr>        <chr>             <chr>            
#> 1 NA       NA           N = 276           N = 324          
#> 2 score    n            247               280              
#> 3 score    Mean (SD)    4.12 (2.23)       6.46 (3.04)      
#> 4 score    Median (IQR) 4.27 (2.59, 5.54) 6.20 (4.45, 8.74)
#> 5 score    Min, Max     -2.24, 9.89       -1.01, 14.58     
    continuous_table(outcome, score, digits = 1)
#> # A tibble: 5 × 3
#>   variable scoring      value         
#>   <chr>    <chr>        <chr>         
#> 1 NA       NA           N = 600       
#> 2 score    n            527           
#> 3 score    Mean (SD)    5.4 (2.9)     
#> 4 score    Median (IQR) 5.1 (3.2, 7.2)
#> 5 score    Min, Max     -2.2, 14.6    
```
