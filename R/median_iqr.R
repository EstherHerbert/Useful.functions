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
