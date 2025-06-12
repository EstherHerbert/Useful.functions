
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Useful.functions

<!-- badges: start -->

<!-- badges: end -->

This package brings together some functions I have created to perform
repetitive tasks.

***NB:** this README file is a work in progress, for more info on
functions please see the specific help files once the package is
installed*

## Installation

Install the latest release with the following code:

``` r
install.packages('devtools')
devtools::install_github("EstherHerbert/Useful.functions@*release")
library(Useful.functions)
```

If you’d like to install the latest development version then you can
omit `@*release` from the call to `install_github()`.

## Functions

Functions in this package are roughly split into the following
categories:

- Working with data from Prospect
- Summary tables
- Functions for use with `xtable::xtable()`
- Other functions

## Addins

Addins are functions with are used interactively within RStudio. There
are three Addins provided in this package and keyboard short cuts can be
created for them to speed up coding. More information on Addins can be
found, including how to set keyboard short cuts,
[here](https://docs.posit.co/ide/user/ide/guide/productivity/add-ins.html).

- Insert Section
- End Box
- Month Year

## Templates

### Report template

To save time when writing statistics reports I have created an R
Markdown template. Currently the report only exports to pdf (my personal
preference) but it could be modified to export to word.

You can access the template either by creating a new R Markdown document
from the menu in RStudio and then looking through the templates or using
`rmarkdown::draft("my-report.Rmd", template = "statistics-report", package = "Useful.functions")`.
Both of these options will create a folder with your report name
containing the markdown file and the templates required to generate the
report. I recommend you render it to pdf using `rmarkdown::render`
rather than using the knit button.

### Project template

This project template sets up the recommended folder structure for an
analysis. It also copies in template `Master.R` and `Read-data.R`
scripts. Optionally, it can also:

- set-up a `.gitignore` file
- create a project specific `.Rprofile` to open `Master.R` whenever the
  project is opened.
- use the report template above to start a statistics report

You can access the project template either by using the
`start_analysis()` function, or by creating a new project in RStudio
from the menu.
