#' @title Start Analysis Template
#' @description Create a new RStudio project for analysis. Creates a folder
#'   structure and RStudio project.
#' @param path The path for the analysis folder.
#' @export
#' @examples
#' try(start_analysis("path/to/new/project"))
#' @importFrom usethis create_project
start_analysis <- function(...) {

  # create the necessary directories
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Outputs", "Tables"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Outputs", "Figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Programs"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Quality Control"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "Reports"), recursive = TRUE, showWarnings = FALSE)

  # copy the scripts to the project
  script_source <- system.file("extdata", package = "Useful.functions")
  file.copy(from = file.path(script_source, c("Master.R", "Read-data.R")),
            file.path(path, "R"), overwrite = TRUE)

}
