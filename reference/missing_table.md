# Produce a dataframe to summarise data completeness for variables

Takes a dataframe and calculates the proportions present/missing for
given variables.

## Usage

``` r
missing_table(df = ., ..., group = ., format = "Missing", total = TRUE)
```

## Arguments

- df:

  Data Frame

- ...:

  Variables to be summarised

- group:

  Optional variable that defines the grouping

- format:

  Should the propotion missing or present be given?

- total:

  Logical indicating whether a total column should be created

## Value

A tibble data frame summarising the data completeness
