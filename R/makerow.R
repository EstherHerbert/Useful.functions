#' For use with \code{xtable}'s \code{add.to.row}
#'
#' @description Collapses a vector into a character string seperated by "&".
#'
#' @param x A vector or single row of a data frame (which is then converted to
#'          a vector within the function)
#'
#' @return A single character string
#'
#' @examples
#'   x <- c("A", 125, "Apple", 0.2, "75g")
#'   makerow(x)
#'
#' @export

makerow <- function(x) {
  if (!is.vector(x)) {
    x <- unlist(x)
  }

  x[is.na(x)] <- ""

  paste0(x, collapse = " & ")
}
