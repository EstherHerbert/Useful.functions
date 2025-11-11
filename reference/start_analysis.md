# Sets up the analysis folder

`start_analysis()` creates a new directory in which it creates the
recommended folder structure, copies template `Master.R` and
`Read-data.R` scripts, and optionally creates a `.gitignore` file and
the template statistics report also included in `Useful.functions`.

## Usage

``` r
start_analysis(
  path,
  createGitignore = TRUE,
  rprofile = TRUE,
  statsReport = NULL
)
```

## Arguments

- path:

  the path to the new analysis folder

- createGitignore:

  logical indicating whether a `.gitignore` file should be created with
  standard items which git should ignore. Default is `TRUE`.

- rprofile:

  logical indicating whether a project `.Rprofile` should be created to
  automatically open the `Master.R` script when the project is opened.
  Default is `TRUE`.

- statsReport:

  optional character string with the name of the statistics report to be
  created. This will be created in the Reports folder.

## Details

This template package can also be implemented through the [RStudio
IDE](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects).
