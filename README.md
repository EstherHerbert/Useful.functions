# Useful.functions

This package brings together some functions I have created to perform repetitive tasks.

***NB:** this README file is a work in progress, for more info on functions please see the specific help files once the package is installed*

## Installation

Install the latest release with the following code:

``` r
install.packages('devtools')
devtools::install_github("EstherHerbert/Useful.functions@*release")
library(Useful.functions)
```

If you'd like to install the latest development version then you can omit `@*release` from the call to `install_github()`.

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

#### `continuous_table()`

Creates a summary table of specified continuous variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

#### `discrete_table()`

Creates a summary table of specified discrete (factor) variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

#### `missing_table()`

Creates a table summarising whether specified variables are present/missing in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

#### `ticked_table()`

Creates a summary table of specified 'ticked' (binary) variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

***NB:** at the moment this function summarises variables which are `"Ticked"`, `""`, or `NA`.*

#### `ae_table()`

Creates a summary table of numbers of events and number and percentage of individuals for adverse event data (although could be used with other event data). A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

**NB:** at the moment you need to create a variable beforehand (e.g., called "All AEs") to summarise a total count of AEs.

### Functions for use with 'xtable'

Typically I write my reports to R Markdown (exporting to pdf) and I like to use the 'xtable' package to convert my tables to LaTeX. However, I have found that occasionally 'xtable' doesn't have as much versatility as I'd like. These functions assist with that.

#### `add_multirow()`

Turns duplicate rows (within a variable) which occur consecutively into NAs and adds [multirow](https://ctan.org/pkg/multirow?lang=en) to the remaining rows.

#### `makerow()`

Collapses a vector into a character string separated by "&", helpful for the `add.to.row` option in `xtable()`.

#### `sanitise_percent()`

Takes a string of text and sanitises only the use of "%" for use with `print.xtable()`.

### Other functions

#### `diagPlot()`

Produces diagnostic plots for the results of various model fitting functions.

#### `file_stamp()`

Produces a file name string with date-time stamp.

#### package_info()

Gets the current loaded packages and their versions. I find this useful when writing my script header.

#### `remove_duplicates()`

Turns duplicates in a vector into NAs.

#### `round0()`

Rounding numbers whilst keeping trailing zeros, it's a short cut for `formatC(x, digits, format = "f")`.

#### `row_to_colnames()`

Takes a row of data and uses it to replace the column names. Default is to use the first row as the colnames but you can specify annother row.

#### search_list()

Takes a list of data frames and searches their variables for either a specific variable name or for a string within the variable names.

#### `split_colnames()`

Splits column names into two rows. The first row are the new column names, the second are the first row of the data.

#### `stata_expand()`

Recreates the expand function in Stata. Takes a data frame and duplicates it n times, then creates a variable (default name is Duplicate) which has a value of 0 if he observation originally appeared in the dataset and i = 1,..,n for each duplicate.

#### `totals()`

This function uses `stata_expand()` and `dplyr::mutate()` to give a data frame that, when summarised, will give total rows and/or columns.

## Addins

Addins are functions with are used interactively within RStudio. There are three Addins provided in this package and keyboard short cuts can be created for them to speed up coding. More information on Addins can be found, including how to set keyboard short cuts, [here](https://docs.posit.co/ide/user/ide/guide/productivity/add-ins.html).

### Insert Section

This Addin inserts dashes from the cursor location to 'end' of the row (width obtained with `getOptions`).

### End Box

This Addin inserts spaces and then two hashes to the 'end' of the row (width obtained with `getOptions`).


### Month Year

This Addin inserts the current month and year at the cursor location.

## R Markdown template

To save time when writing statistics reports I have created an R Markdown template. Currently the report only exports to pdf (my personal preference) but it could be modified to export to word.

You can access the template either by creating a new R Markdown document from the menu in RStudio and then looking through the templates or using `rmarkdown::draft("my-report.Rmd", template = "statistics-report", package = "Useful.functions")`. Both of these options will create a folder with your report name containing the markdown file and the templates required to generate the report. I recommend you render it to pdf using `rmarkdown::render` rather than using the knit button.

\***NB:** I plan to create other templates in the future - e.g., for status reports or presentations.
