#' Rounds numbers but keeps trailing zeros
#'
#' @description This function is a shortcut for
#'              \code{formatC(x, digits, format = "f")}.
#'
#' @param x a number
#' @param digits an integer indicating the number of decimal places
#'
#' @return a character string
#'
#' @examples
#' round(5.601, 2)
#' round0(5.601, 2)
#'
#' @export
round0 <- function(x, digits) {
  if (is.na(x)) {
    x <- NA_character_
  } else {
    x <- formatC(x, digits = digits, format = "f")
  }
  return(x)
}
