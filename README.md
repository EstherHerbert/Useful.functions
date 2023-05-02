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

#### `continuous_table()`

Creates a summary table of specified continuous variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

#### `discrete_table()`

Creates a summary table of specified discrete (factor) variables in a data frame. A grouping variable can be provided with an optional total column too (see `totals()`), as well as other options.

## Addins

Addins are functions with are used interactively within RStudio. There are three Addins provided in this package and keyboard short cuts can be created for them to speed up coding. More information on Addins can be found, including how to set keyboard short cuts,  [here](https://docs.posit.co/ide/user/ide/guide/productivity/add-ins.html).

### Insert Section

This Addin inserts dashes from the cursor location to 'end' of the row (width = 80).

***NB:** I plan to update this addin so that the width is read from getOptions.*

### End Box

This Addin inserts spaces and then two hashes to the 'end' of the row (width = 80).

***NB:** I plan to update this addin so that the width is read from getOptions.*

### Month Year

This Addin inserts the current month and year at the cursor location.


## R Markdown template

To save time when writing statistics reports I have created an R Markdown template. Currently the report only exports to pdf (my personal preference) but it could be modified to export to word.

You can access the template either by creating a new R Markdown document from the menu in RStudio and then looking through the templates or using `rmarkdown::draft("my-report.Rmd", template = "statistics-report", package = "Useful.functions")`. Both of these options will create a folder with your report name containing the markdown file and the templates required to generate the report. I recommend you render it to pdf using `rmarkdown::render` rather than using the knit button.

***NB:** I plan to create other templates in the future - e.g., for status reports or presentations.

