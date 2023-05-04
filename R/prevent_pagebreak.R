#' Preventing page breaks when using in long tables exported from `xtable()`
#'
#' When using LaTeX's longtable environment it is sometimes desirable to prevent a page break for certain lines in the table. In LaTeX this is done by using `*` at the end of the row. `prevent_pagebreak` adds `*` to specified lines of output from `print.xtable`.
#'
#' @param pxtab the output from a call to `print.xtable`
#' @param lines either a numeric vector of row numbers or `"multirow"`. If the latter then the function will check which lines start with a cell which uses `\multirow`.
#'
#' @export
prevent_pagebreak <- function(pxtab, lines){

  tab <- str_split(pxtab, "\n")[[1]]

  if(lines == "multirow"){
    lines <- str_which(tab, regex("^\\\\multirow"))
  }

  tab[lines] <- str_remove(tab[lines], " $")

  tab[lines] <- paste0(tab[lines], "*")

  out <- paste(tab, collapse = "\n")

  cat(out)
  return(invisible(out))

}
