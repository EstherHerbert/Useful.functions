# Produce a data frame to summarise counts of events

Takes a data frame of events and produces the number of events and
number and percentage of individuals with at least one event.

## Usage

``` r
count_table(df, ..., ID, N, group, accuracy = 0.1, total = FALSE, all = FALSE)
```

## Arguments

- df:

  Data Frame

- ...:

  Variables to be summarised

- ID:

  Variable that defines the individual identifier (e.g. screening
  number)

- N:

  a data frame with the group counts (typically produced using
  [`dplyr::count()`](https://dplyr.tidyverse.org/reference/count.html))

- group:

  optional, variable that defines the grouping

- accuracy:

  see details of
  [`scales::percent()`](https://scales.r-lib.org/reference/percent_format.html)

- total:

  Logical indicating whether a total column should be created, default
  is `FALSE`

- all:

  logical indicating whether a row summarising all events should be
  created, default is `FALSE`

## Examples

``` r
  N <- dplyr::count(outcome, group, name = "N")
  count_table(outcome_aes, serious, related, ID = screening, N = N,
              group = group)
#> # A tibble: 5 × 6
#>   variable scoring A_events A_individuals B_events B_individuals
#>   <chr>    <chr>   <chr>    <chr>         <chr>    <chr>        
#> 1 NA       NA      N = 276  N = 276       N = 324  N = 324      
#> 2 serious  No      45       37 (13.4%)    45       36 (11.1%)   
#> 3 serious  Yes     4        4 (1.4%)      6        6 (1.9%)     
#> 4 related  No      47       39 (14.1%)    50       41 (12.7%)   
#> 5 related  Yes     2        2 (0.7%)      1        1 (0.3%)     

  N <- dplyr::count(outcome, name = "N")
  count_table(outcome_aes, serious, related, ID = screening, N = N)
#> # A tibble: 5 × 4
#>   variable scoring events  individuals
#>   <chr>    <chr>   <chr>   <chr>      
#> 1 NA       NA      N = 600 N = 600    
#> 2 serious  No      90      73 (12.2%) 
#> 3 serious  Yes     10      10 (1.7%)  
#> 4 related  No      97      80 (13.3%) 
#> 5 related  Yes     3       3 (0.5%)   
  count_table(outcome_aes, serious, ID = screening, N = N, all = TRUE)
#> # A tibble: 4 × 4
#>   variable scoring events  individuals
#>   <chr>    <chr>   <chr>   <chr>      
#> 1 NA       NA      N = 600 N = 600    
#> 2 All      n       100     82 (13.7%) 
#> 3 serious  No      90      73 (12.2%) 
#> 4 serious  Yes     10      10 (1.7%)  
```
