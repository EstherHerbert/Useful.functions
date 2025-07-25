% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/start_analysis.R
\name{start_analysis}
\alias{start_analysis}
\title{Sets up the analysis folder}
\usage{
start_analysis(
  path,
  createGitignore = TRUE,
  rprofile = TRUE,
  statsReport = NULL
)
}
\arguments{
\item{path}{the path to the new analysis folder}

\item{createGitignore}{logical indicating whether a \code{.gitignore} file should
be created with standard items which git should ignore. Default is \code{TRUE}.}

\item{rprofile}{logical indicating whether a project \code{.Rprofile} should be
created to automatically open the \code{Master.R} script when the project is
opened. Default is \code{TRUE}.}

\item{statsReport}{optional character string with the name of the statistics
report to be created. This will be created in the Reports folder.}
}
\description{
\code{start_analysis()} creates a new directory in which it creates the
recommended folder structure, copies template \code{Master.R} and \code{Read-data.R}
scripts, and optionally creates a \code{.gitignore} file and the template
statistics report also included in \code{Useful.functions}.
}
\details{
This template package can also be implemented through the
\href{https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects}{RStudio IDE}.
}
