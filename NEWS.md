# Useful.functions (development version)

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

# Useful.functions 0.3.0

* Initial NEWS, future changes will be summarised here
