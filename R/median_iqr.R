#' Median (IQR)
#'
#' Calculates ad formats the median and interquartile range.
#'
#' @param x numeric vector
#' @param digits number of digits to round mean and standard deviation to
#' @param na_rm remove `NA` values, default is `FALSE`
#' @param show_n Should the denominator be shown, default is `FALSE`
#' @param note should "IQR " be written inside the brackets, default is `FALSE`
#'
#' @examples
#'   median_iqr(outcome$score, na_rm = TRUE)
#'   median_iqr(outcome$score, na_rm = TRUE, show_n = TRUE)
#'   median_iqr(outcome$score, na_rm = TRUE, note = TRUE)
#'
#' @export
median_iqr <- function (x, digits = 2, na_rm = FALSE, show_n = FALSE,
                        note = FALSE) {

  if(note) {
    note <- "IQR "
  } else {
    note <- NULL
  }

  n <- sum(!is.na(x))
  m <- round0(stats::median(x, na.rm = na_rm), digits = digits)
  qs <- round0(stats::quantile(x, probs = c(1, 3)/4, na.rm = na_rm),
              digits = digits)
  rtn <- paste0(m, " (", note, qs[1L], ", ", qs[2L], ")")

  if (show_n) {
    rtn <- paste0(n, "; ", rtn)
  }

  return(rtn)
}
