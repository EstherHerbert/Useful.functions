pn <- function (x,
                digits = 1,
                na_rm = FALSE,
                show_denom = FALSE,
                paren = "(",
                note = F) {
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
