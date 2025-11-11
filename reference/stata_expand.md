# Function to recreate the expand function in Stata

Takes a dataframe and duplicates it n times, then creates a variable
(default name is Duplicate) which has a value of 0 if the observation
originally appeared int he dataset and i = 1,..,n for each duplicate.

## Usage

``` r
stata_expand(df, n, name = "Duplicate")
```

## Arguments

- df:

  Data frame

- n:

  Number of times to duplicate (i.e. to end up with 2 copies of
  everything then n = 1)

- name:

  Character string indicating the name of the variable indicating which
  rows are duplicates

## Value

A data frame

## Examples

``` r
df <- data.frame(x = 1:5, y = c("a","b","c","d", "e"))
stata_expand(df, 1)
#>    x y Duplicate
#> 1  1 a         0
#> 2  2 b         0
#> 3  3 c         0
#> 4  4 d         0
#> 5  5 e         0
#> 6  1 a         1
#> 7  2 b         1
#> 8  3 c         1
#> 9  4 d         1
#> 10 5 e         1
```
