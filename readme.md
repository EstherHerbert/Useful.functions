# Useful.functions

This package brings together some functions I have created to perform repetitive tasks.

## Installation

```
install.packages('devtools')
devtools::install_github("EstherHerbert/Useful.functions")
library(Useful.functions)
```

## Functions

### `add_multirow()`
For use with latex summary tables. Turns duplicate rows which occur together into NAs and adds multirow to the remaining rows.

### `ae_table()`
Produce a data frame to summarise adverse event data. Takes a data frame of adverse events and produces the number of events and number and percentage of individuals with an adverse event.

### `apply_labels()`
Apply labels from a dataspec to a column.

### `continuous_table()`
Produce a data frame to summaries continuous variables. Takes a data frame and produces grouped or un-grouped summaries such as mean and standard deviation for continuous variables.

### `discrete_table()`
Produce a data frame to summarise discrete variables. Takes a data frame and produces the number and percentage for discrete variables.

### `file_stamp()`
Produce a file name string with date-time stamp.

### `makerow()`
For use with \code{xtable}'s \code{add.to.row}. Collapses a vector into a character string separated by "&".

### `missing_table()`
Produce a data frame to summarise data completeness for variables. Takes a data frame and calculates the proportions present/missing for given variables.

### `my_tidy.emmGrid()`
Extend broom's tidy.emmGrid function to provide confidence intervals.

### `package_info()`
Obtain version information for loaded packages.

### `read_prospect()`
Reads in csv files as exported by Prospect. Takes a .csv file exported from Prospect and reads it in to R along with the factor labels from the lookups.csv file produced by Prospect. When using this function you must first read the lookups.csv file into R.

### `remove_duplicates()`
For use with tables, turns duplicate rows into NAs.

### `round0()`
Rounds numbers but keeps trailing zeros. This function is a shortcut for \code{formatC(x, digits, format = "f")}.

### `sanitise_percent()`
Sanitise function for use with print.xtable. Takes a string of text and sanitises only the use of "%" for use with latex.

### `search_list()`
Searches a list of data frames. Takes a list of data frames and searches their variables for either a specific variable name or for a string within the variable names.

### `stata_expand()`
Function to recreate the expand function in Stata. Takes a data frame and duplicates it n times, then creates a variable (default name is Duplicate) which has a value of 0 if the observation originally appeared in the dataset and i = 1,..,n for each duplicate.

### `ticked_table()`
Produce a data frame to summarise ticked variables. Takes a data frame and produces the number and percentage for ticked variables.

### `totals()`
Mutates data frame so that summary tables give totals. This function uses \code{stat_expand} and \code{mutate} to give a data frame that, when summarised, with give total rows and/or columns.

## Addins

### `end_box()`

### `insert_section()`

### `monthyear()`
