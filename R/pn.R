#' Count and Percentage
#'
#' Functions to display counts and percentages.
#'
#' @param x A boolean vector
#' @param digits Number of digits to display percentages to, default is 1
#' @param na_rm Logical indicating whether NAs should be removed from the
#'   calculation of the denominator, default is `FALSE`
#' @param show_denom Logical, should the denominator be shown, default is `FALSE`
#' @param paren String indicating which parentheses to use, options are `"("` (for ()) or `"["` (for[])
#' @param note Should "n = " preface the count in `pn()`
#'
#' @examples
#'   pn(outcome$limp_yn == "Yes", note = TRUE)
#'   np(outcome$limp_yn == "Yes", show_denom = TRUE, na_rm = T)
#'
#'
#' @export
pn <- function (x,
                digits = 1,
                na_rm = FALSE,
                show_denom = FALSE,
                paren = "(",
                note = FALSE) {
  if (na_rm) {
    d <- sum(!is.na(x))
  } else {
    d <- length(x)
  }

  n <- sum(x, na.rm = T)
  p <- round(100 * n / d, digits)

  parenf <- switch(paren, "(" = ")", "[" = "]")

  if (note) {
    note <- "n = "
  } else {
    note <- NULL
  }

  if (show_denom) {
    rtn <- paste0(p, "% ", paren, note, n, "/", d, parenf)

  } else {
    rtn <- paste0(p, "% ", paren, note, n, parenf)
  }

  return(rtn)

}

#' @rdname pn
#' @export
np <- function (x,
                digits = 1,
                na_rm = FALSE,
                show_denom = FALSE,
                paren = "(") {

  if (na_rm) {
    d <- sum(!is.na(x))
  } else {
    d <- length(x)
  }

  n <- sum(x, na.rm = T)
  p <- round(100 * n / d, digits)

  parenf <- switch(paren, "(" = ")", "[" = "]")

  if (show_denom) {
    rtn <- paste0(n, "/", d, " ", paren, p, "%", parenf)

  } else {
    rtn <- paste0(n, " ", paren, p, "%", parenf)
  }

  return(rtn)

}
