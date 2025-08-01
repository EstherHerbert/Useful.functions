% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/discrete_table.R
\name{discrete_table}
\alias{discrete_table}
\title{Produce a data frame to summarise discrete variables}
\usage{
discrete_table(
  df = .,
  ...,
  group,
  time,
  total = TRUE,
  n = FALSE,
  missing = "Missing",
  accuracy = 0.1,
  drop.levels = FALSE,
  condense = FALSE
)
}
\arguments{
\item{df}{Data Frame}

\item{...}{Variables to be summarised}

\item{group}{Optional variable that defines the grouping}

\item{time}{Optional variable for repeated measures (currently must me used
with group)}

\item{total}{Logical indicating whether a total column should be created}

\item{n}{Logical indicating whether percentages should be out of n
(\code{n = TRUE}) or N (\code{n = FALSE})}

\item{missing}{String determining what missing data will be called
(if \code{n = TRUE}). Default is "Missing".}

\item{accuracy}{see details of \code{\link[scales:label_percent]{scales::label_percent()}}}

\item{drop.levels}{logical indicating whether unused levels in the factors
should be dropped. Default is \code{FALSE}.}

\item{condense}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}} \code{condense = TRUE} is
deprecated, use \code{\link[=condense]{condense()}} instead.}
}
\value{
A tibble data frame summarising the data
}
\description{
Takes a data frame and produces the number and percentage for
discrete variables.
}
\examples{
    discrete_table(outcome, sex, group = group)
    discrete_table(outcome, sex, drop.levels = TRUE)
    discrete_table(outcome, sex, group = group, time = event_name, n = TRUE,
                   total = FALSE)

}
