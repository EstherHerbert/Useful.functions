#' Mean (SD)
#'
#' Calculates and formats the mean and standard deviation.
#'
#' @param x numeric vector
#' @param digits number of digits to round mean and standard deviation to
#' @param na_rm remove `NA` values, default is `FALSE`
#' @param show_n Should the denominator be shown, default is `FALSE`
#' @param note should "SD " be written inside the brackets, default is `FALSE`
#' @param unit optional character string giving unit, e.g., "kg"
#'
#' @examples
#'   mean_sd(outcome$score, na_rm = TRUE)
#'   mean_sd(outcome$score, na_rm = TRUE, show_n = TRUE)
#'   mean_sd(outcome$score, na_rm = TRUE, note = TRUE)
#'
#' @export
mean_sd <- function (x, digits = 2, na_rm = FALSE, show_n = FALSE,
                     note = FALSE, unit = NULL) {

  if(note) {
    note <- "SD "
  } else {
    note <- NULL
  }

  n <- sum(!is.na(x))
  m <- round0(mean(x, na.rm = na_rm), digits = digits)
  sd <- round0(stats::sd(x, na.rm = na_rm), digits = digits)

  if(!is.null(unit)) {
    m <- paste(m, unit)
  }

  rtn <- paste0(m, " (", note, sd, ")")

  if (show_n) {
    rtn <- paste0(n, "; ", rtn)
  }

  return(rtn)
}
