# Reads in csv files as exported by Prospect

Takes a csv file exported from Prospect and reads it in to R along with
the factor labels from the `lookups.csv` file produced by Prospect. When
using this function you must first read the `lookups.csv` file into R.

## Usage

``` r
read_prospect(file, dictionary = lookups, convert.date = TRUE, ...)
```

## Arguments

- file:

  The file to be read in

- dictionary:

  The file in which the lookups reside, default is `lookups`

- convert.date:

  Convert fields ending in `_dt` or `_date` to date format

- ...:

  arguments to be passed to
  [`utils::read.csv()`](https://rdrr.io/r/utils/read.table.html).
  `stringsAsFactors` is set to `FALSE` within `read_prospect()`,
  re-specifying it in the call will throw an error.

## Value

An object of class
[`data.frame`](https://rdrr.io/r/base/data.frame.html)
