# Preventing page breaks when using in long tables exported from `xtable()`

When using LaTeX's longtable environment it is sometimes desirable to
prevent a page break for certain lines in the table. In LaTeX this is
done by using `*` at the end of the row. `prevent_pagebreak` adds `*` to
specified lines of output from `print.xtable`.

## Usage

``` r
prevent_pagebreak(pxtab, lines)
```

## Arguments

- pxtab:

  the output from a call to `print.xtable`

- lines:

  either a numeric vector of row numbers or `"multirow"`. If the latter
  then the function will check which lines start with a cell which uses
  `\multirow`.
