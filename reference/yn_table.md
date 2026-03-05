# Produce a data frame to summarise discrete variables coded as Yes/No

Takes a data frame and produces the number and percentage for yes/no
variables. Note that the denominator currently always excludes missing
values.

## Usage

``` r
yn_table(df = ., ..., group, time, digits = 1, total = TRUE, show_denom = TRUE)
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

- digits:

  Number of digits to display percentages to, default is 1

- total:

  Logical indicating whether a total column should be created

- show_denom:

  Logical, should the denominator for each variable be shown. Default is
  `TRUE`.

## Value

A tibble data frame summarising the data

## Examples

``` r
yn_table(outcome, limp_yn, group = group)
#> # A tibble: 2 × 5
#>   variable scoring B              A              Total        
#>   <chr>    <chr>   <chr>          <chr>          <chr>        
#> 1 NA       NA      N = 324        N = 276        N = 600      
#> 2 limp_yn  ""      59/307 (19.2%) 54/258 (20.9%) 113/565 (20%)
yn_table(outcome, limp_yn, group = group, total = FALSE)
#> # A tibble: 2 × 4
#>   variable scoring B              A             
#>   <chr>    <chr>   <chr>          <chr>         
#> 1 NA       NA      N = 324        N = 276       
#> 2 limp_yn  ""      59/307 (19.2%) 54/258 (20.9%)
yn_table(outcome, limp_yn, show_denom = FALSE)
#> # A tibble: 2 × 3
#>   variable scoring value    
#>   <chr>    <chr>   <chr>    
#> 1 NA       NA      N = 600  
#> 2 limp_yn  ""      113 (20%)
yn_table(outcome, limp_yn, group = group, time = event_name, total = F)
#> # A tibble: 4 × 5
#>   variable event_name scoring B              A            
#>   <chr>    <chr>      <chr>   <chr>          <chr>        
#> 1 NA       NA         NA      N = 108        N = 92       
#> 2 limp_yn  Baseline   ""      19/100 (19%)   11/86 (12.8%)
#> 3 limp_yn  6 Weeks    ""      19/104 (18.3%) 26/86 (30.2%)
#> 4 limp_yn  12 Weeks   ""      21/103 (20.4%) 17/86 (19.8%)

```
