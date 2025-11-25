# Adds LaTex `\clines` to an object of class `"xtable"`

Produces a list with 'pos' and 'command' to use with `xtable()`'s
`add.to.row` option. This will create a partial horizontal line across
specified columns of the table. Users can either specify the row numbers
they'd like to add the cline to or the function will look for the rows
which use multirow in a specified column.

## Usage

``` r
add_clines(xtab, rows = "multirow", cols, check.column)
```

## Arguments

- xtab:

  the `xtable` object

- rows:

  either `"multirow"` (the default) or row numbers to add a cline to

- cols:

  a character string with the columns over which to draw the cline (e.g,
  `"2-3"`)

- check.column:

  a character string of the column to check when `rows = "multirow"`

## Value

A list with levels 'pos' and 'command' to give to the `add.to.row`
option of `xtable()`.

## Examples

``` r
xtab <- xtable::xtable(head(iris))

xtable::print.xtable(xtab, add.to.row = add_clines(., rows = c(2, 3), cols = "3-4"))
#> % latex table generated in R 4.5.2 by xtable 1.8-4 package
#> % Tue Nov 25 16:56:00 2025
#> \begin{table}[ht]
#> \centering
#> \begin{tabular}{rrrrrl}
#>   \hline
#>  & Sepal.Length & Sepal.Width & Petal.Length & Petal.Width & Species \\ 
#>   \hline
#> 1 & 5.10 & 3.50 & 1.40 & 0.20 & setosa \\ 
#>   2 & 4.90 & 3.00 & 1.40 & 0.20 & setosa \\ 
#>    \cline{3-4}
#> 3 & 4.70 & 3.20 & 1.30 & 0.20 & setosa \\ 
#>    \cline{3-4}
#> 4 & 4.60 & 3.10 & 1.50 & 0.20 & setosa \\ 
#>   5 & 5.00 & 3.60 & 1.40 & 0.20 & setosa \\ 
#>   6 & 5.40 & 3.90 & 1.70 & 0.40 & setosa \\ 
#>    \hline
#> \end{tabular}
#> \end{table}
```
