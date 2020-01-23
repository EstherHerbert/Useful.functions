#' For use with tables
#'
#' @description Turns duplicate rows into NAs
#'
#' @param x Character vector
#' @param reverse Logical indicating whether the last incidence should be kept
#'                instead of the first (which is the default).
#'
#' @return A character string/vector
#'
#' @examples
#'     x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
#'     remove_duplicates(x)
#'
#' @export
remove_duplicates <- function(x, keepLast = FALSE) {
  n <- rle(x[!is.na(x)])$lengths

  if (is.factor(x)) {
    x <- as.character(x)
  }

  x[duplicated(x, fromLast = keepLast)] <- NA

  return(x)
}
