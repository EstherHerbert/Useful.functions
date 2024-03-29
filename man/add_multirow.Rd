% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_multirow.R
\name{add_multirow}
\alias{add_multirow}
\title{For use with latex summary tables}
\usage{
add_multirow(
  x,
  width = "*",
  pos = "t",
  rows = .,
  reverse = FALSE,
  hline = TRUE
)
}
\arguments{
\item{x}{Character vector}

\item{width}{Desired width of column to be passed to multirow in latex. e.g.
\code{"4cm"}}

\item{pos}{Character defining the vertical positioning of the text in the
multirow block. Default is "t" - top. Other options are "c" for
centre or "b" for bottom.}

\item{rows}{Optional number of rows to use, if not given then
\code{add_multirow} calculates how many rows to use.}

\item{reverse}{If \code{TRUE} then all by the last duplicate will be
removed. If rows isn't given then the calculated number of
rows will be negated. This features is useful when colouring
tables.}

\item{hline}{Logical indicating whether a hline should be added to the start
of each multirow.}
}
\value{
A character string/vector
}
\description{
Turns duplicate rows which occur together into NAs and adds
multirow to the remaining rows.
}
\examples{
    x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
    add_multirow(x)
    add_multirow(x, reverse = TRUE)
    add_multirow(x, width = "2cm", pos = "c")

}
