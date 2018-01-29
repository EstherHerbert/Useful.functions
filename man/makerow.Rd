% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/makerow.R
\name{makerow}
\alias{makerow}
\title{For use with \code{xtable}'s \code{add.to.row}}
\usage{
makerow(x)
}
\arguments{
\item{x}{A vector or single row of a data frame (which is then converted to
a vector within the function)}
}
\value{
A single character string
}
\description{
Collapses a vector into a character string seperated by "&".
}
\examples{
  x <- c("A", 125, "Apple", 0.2, "75g")
  makerow(x)

}