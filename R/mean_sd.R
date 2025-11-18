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
