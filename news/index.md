# Changelog

## Useful.functions (development version)

- new
  [`mean_sd()`](https://estherherbert.github.io/Useful.functions/reference/mean_sd.md)
  and
  [`median_iqr()`](https://estherherbert.github.io/Useful.functions/reference/median_iqr.md)
  to summarise numeric vectors
- new
  [`np()`](https://estherherbert.github.io/Useful.functions/reference/pn.md)
  and
  [`pn()`](https://estherherbert.github.io/Useful.functions/reference/pn.md)
  to display counts and percentages of boolean data
- new
  [`yn_table()`](https://estherherbert.github.io/Useful.functions/reference/yn_table.md)
  to summarise data coded yes/no
- [`export_check()`](https://estherherbert.github.io/Useful.functions/reference/export_check.md)
  prints to the console even when saving the log and checks for missing
  forms
- [`ae_table()`](https://estherherbert.github.io/Useful.functions/reference/ae_table.md)
  renamed to
  [`count_table()`](https://estherherbert.github.io/Useful.functions/reference/count_table.md)
- new function
  [`condense()`](https://estherherbert.github.io/Useful.functions/reference/condense.md)
  to condense 2/3 columns into 1
- deprecated the use of `condense = TRUE` in
  [`continuous_table()`](https://estherherbert.github.io/Useful.functions/reference/continuous_table.md),
  [`discrete_table()`](https://estherherbert.github.io/Useful.functions/reference/discrete_table.md)
  and
  [`ticked_table()`](https://estherherbert.github.io/Useful.functions/reference/ticked_table.md)
- update to
  [`git_log()`](https://estherherbert.github.io/Useful.functions/reference/git_log.md)
  so that multiple git tags are kept in one column
- update to
  [`ticked_table()`](https://estherherbert.github.io/Useful.functions/reference/ticked_table.md)
  to include digits as an option
- new project template and function to initiate it
  [`start_analysis()`](https://estherherbert.github.io/Useful.functions/reference/start_analysis.md)
- significant update to how
  [`discrete_table()`](https://estherherbert.github.io/Useful.functions/reference/discrete_table.md)
  works under the hood, unused factor levels are now included in the
  table.
  - added new option `drop.levels` to drop unused levels.
- update to statistics-report R Markdown template to allow for a
  landscape report
- new R Markdown template for presentations
- updates to documentation throughout for clarity

## Useful.functions 0.3.0

- Initial NEWS, future changes will be summarised here
