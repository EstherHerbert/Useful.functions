# Wrangle the Edith database specification into a single lookups data frame

This function takes the Lookups and Fields tabs from the Edith database
specification (exported as separate csv files) and wrangles them into a
single lookups data frame for use with
[`read_prospect()`](https://estherherbert.github.io/Useful.functions/reference/read_prospect.md)
and
[`apply_labels()`](https://estherherbert.github.io/Useful.functions/reference/apply_labels.md).

## Usage

``` r
wrangle_lookups(lookups, fields, clean = FALSE, keep = NULL)
```

## Arguments

- lookups:

  a data frame read in from the Lookups.csv file as exported from Edith

- fields:

  a data frame read in from the Fields.csv file as exported from Edith

- clean:

  logical indicating whether field and field_label columns should be
  cleaned up:

  - removing `"[calculated] "` from field column

  - removing `"[Calculated] "` and `"Calculated "` from field_label
    column

  - converting field_label column to sentence case

- keep:

  optional character vector specifying additional fields to keep from
  `fields`
