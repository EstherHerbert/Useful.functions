#' Sets up the analysis folder
#'
#' `start_analysis()` creates a new directory in which it creates the
#'   recommended folder structure, copies template `Master.R` and `Read-data.R`
#'   scripts, and optionally creates a `.gitignore` file and the template
#'   statistics report also included in `Useful.functions`.
#'
#'   This template package can also be implemented through the
#'   [RStudio IDE][https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects].
#'
#' @param path the path to the new analysis folder
#' @param createGitignore logical indicating whether a `.gitignore` file should
#'   be created with standard items which git should ignore.
#' @param statsReport optional character string with the name of the statistics
#'   report to be created. This will be created in the Reports folder.
#'
#' @export
start_analysis <- function(path, createGitignore = TRUE, statsReport = NULL) {


  # create the necessary directories
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Outputs", "Tables"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Outputs", "Figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Programs"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Quality Control"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Reports"), recursive = TRUE, showWarnings = FALSE)

  # initialize the project
  rstudioapi::initializeProject(path)

  # copy the scripts to the project
  script_source <- system.file("extdata", package = "Useful.functions")
  file.copy(from = file.path(script_source, c("Master.R", "Read-data.R")),
            file.path(path, "Programs"), overwrite = TRUE)


  if(isTRUE(createGitignore)) {
    git_ignores <-
      c(
        "Outputs/",
        "Data/",
        "*.Rproj",
        ".Rprofile",
        ".Rproj.user/",
        ".RData",
        "Reports/**/Images/",
        "Reports/**/*.pdf",
        "Quality Control/",
        ".Rhistory",
        "git_log_*.csv"
      )

    writeLines(paste(git_ignores, sep = '\n'),
               con = file.path(path,'.gitignore'))
  }

  if (!is.null(statsReport) && statsReport != "") {
    file <- file.path(path, "Reports", statsReport)
    rmarkdown::draft(file, template = "statistics-report",
                     package = "Useful.functions", edit = FALSE)
  }

}
