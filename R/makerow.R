#' For use with `xtable`'s `add.to.row`
#'
#' @description Collapses a vector into a character string separated by "&".
#'
#' @param x A vector or single row of a data frame (which is then converted to
#'          a vector within the function)
#' @param hline Logical indicating whether a hline is needed after the row
#'
#' @return A single character string
#'
#' @examples
#'   x <- c("A", 125, "Apple", 0.2, "75g")
#'   makerow(x)
#'   makerow(x, hline = TRUE)
#'
#' @export

makerow <- function(x, hline = FALSE) {
  if (!is.vector(x)) {
    x <- unlist(x)
  }

  x[is.na(x)] <- ""

  if(hline){
    paste0(x, collapse = " & ") %>%
      paste("\\\\\\hline")
  } else{
    paste0(x, collapse = " & ") %>%
      paste("\\\\")
  }
}
