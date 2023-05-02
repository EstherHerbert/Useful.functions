# Useful.functions

This package brings together some functions I have created to perform repetitive tasks.

***NB:** this README file is a work in progress, for more info on functions please see the specific help files once the package is installed*

## Installation

``` r
install.packages('devtools')
devtools::install_github("EstherHerbert/Useful.functions")
library(Useful.functions)
```

## Functions

### Working with data from CTRU database

#### `read_prospect()`

This function reads in data from the prospect database. It takes the file path to the exported csv file and the data dictionary (typically called 'lookups.csv'); applies the factor labels and does some basic formatting. 

***NB:** the lookups file can be provided in a couple of different formats, currently `read_prospect()` only works with one of these.*

#### `apply_labels()`

This function applies the field labels to the column of a data frame. This is particularly useful after creating a summary table (e.g. with `discrete_table()`, see below).

#### `export_check()`

This function checks the read in file lengths against the export notes provided by prospect.

***NB:** this is experimental at the moment and has had limited checking*

### Summary tables

####`continuous_table()`

Creates a summary table of specified continuous variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

#### `discrete_table()`

Creates a summary table of specified discrete (factor) variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.
