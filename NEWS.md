# Useful.functions (development version)

* new `mean_sd()` and `median_iqr()` to summarise numeric vectors
* new `np()` and `pn()` to display counts and percentages of boolean data
* new `yn_table()` to summarise data coded yes/no
* `export_check()` prints to the console even when saving the log and checks for
  missing forms
* `ae_table()` renamed to `count_table()`
* new function `condense()` to condense 2/3 columns into 1
* deprecated the use of `condense = TRUE` in `continuous_table()`, 
  `discrete_table()` and `ticked_table()`
* update to `git_log()` so that multiple git tags are kept in one column
* update to `ticked_table()` to include digits as an option
* new project template and function to initiate it `start_analysis()`
* significant update to how `discrete_table()` works under the hood, unused
  factor levels are now included in the table.
  * added new option `drop.levels` to drop unused levels.
* update to statistics-report R Markdown template to allow for a landscape
  report
* new R Markdown template for presentations
* updates to documentation throughout for clarity

# Useful.functions 0.3.0

* Initial NEWS, future changes will be summarised here
