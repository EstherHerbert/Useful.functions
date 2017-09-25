#' Rounds numners but keeps trailing zeros
#'
#' @description This version of \code{round} is a shortcut for
#'              \code{formatC(x, digits, format = "f")}.
#'
#' @param x a numeric vector
#' @param digits an integer indicating the number of decimal places
#'
#' @return a character string
#'
#' @examples
#' base::round(5.601, 2)
#' Useful.functions::round(5.601, 2)
#'
#' @export
round <- function(x, digits){
  x <- formatC(x, digits = digits, format = "f")
  return(x)
}
