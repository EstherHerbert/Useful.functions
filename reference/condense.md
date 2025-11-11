# Condense two or three columns into one

Useful for saving space with summary tables created by
[`continuous_table()`](https://estherherbert.github.io/Useful.functions/reference/continuous_table.md),
[`discrete_table()`](https://estherherbert.github.io/Useful.functions/reference/discrete_table.md),
[`ticked_table()`](https://estherherbert.github.io/Useful.functions/reference/ticked_table.md)
or
[`ae_table()`](https://estherherbert.github.io/Useful.functions/reference/ae_table.md).

## Usage

``` r
condense(
  df,
  first_col = variable,
  second_col = scoring,
  third_col,
  hline = TRUE,
  indent = c("quad", "hang", "space")
)
```

## Arguments

- df:

  a data frame containing at least one column with repeated values.

- first_col:

  variable name of the column to collapse into - should contain repeated
  values. Default is `variable` for quick use with the summary table
  functions.

- second_col:

  variable name of the column to be collapsed into `first_col`. Default
  is `scoring` for quick use with the summary table functions.

- third_col:

  Optionally, a third column to be collapsed into `second_col`.

- hline:

  Logical indicating whether `"\\hline\n"` should be added at the start
  of each unique value in `first_col`. For use with
  [`xtable::xtable()`](https://rdrr.io/pkg/xtable/man/xtable.html).
  Default is `TRUE`.

- indent:

  Character indicating the type of indent to use (the default is
  `"quad"`):

  - `"quad"` uses \\\LaTeX\\'s `\\quad` to indent the second column (and
    `\\qquad \\quad` to indent the third column if given)

  - `"hang"` uses \\\LaTeX\\'s `\\hangindent2em\\hangafter0` to indent
    the second column (and `\\hangindent4em\\hangafter0` to indent the
    third column if given)

  - `"space"` uses `" "` to indent the second column (and `" "` to
    indent the third column if given)

## Examples

``` r
  continuous_table(df = iris, Petal.Length, Petal.Width, group = Species) %>%
       condense()
#> # A tibble: 9 × 5
#>   variable                 setosa            versicolor        virginica   Total
#>   <chr>                    <chr>             <chr>             <chr>       <chr>
#> 1  NA                      N = 50            N = 50            N = 50      N = …
#> 2 "\\hline\n Petal.Length" 50                50                50          150  
#> 3 "\\quad Mean (SD)"       1.46 (0.17)       4.26 (0.47)       5.55 (0.55) 3.76…
#> 4 "\\quad Median (IQR)"    1.50 (1.40, 1.58) 4.35 (4.00, 4.60) 5.55 (5.10… 4.35…
#> 5 "\\quad Min, Max"        1, 1.9            3, 5.1            4.5, 6.9    1, 6…
#> 6 "\\hline\n Petal.Width"  50                50                50          150  
#> 7 "\\quad Mean (SD)"       0.25 (0.11)       1.33 (0.20)       2.03 (0.27) 1.20…
#> 8 "\\quad Median (IQR)"    0.20 (0.20, 0.30) 1.30 (1.20, 1.50) 2.00 (1.80… 1.30…
#> 9 "\\quad Min, Max"        0.1, 0.6          1, 1.8            1.4, 2.5    0.1,…
```
