#' For use with `xtable`'s `add.to.row` when column names are repeated and
#' should be merged.
#'
#' Removes consecutive duplicate column names and uses LaTeX's `\multicolumn` to
#' merge the cells. Shuld be passed to `add.to.row` in `print.xtable()`.
#'
#' @param xtab an object of class `xtable`
#'
#' @returns a list with components 'pos' and 'command'
#'
#' @examples
#'
#' library(xtable)
#'
#' iris2 <- split_colnames(iris, sep = "\\.")
#'
#' xtable(iris2) %>%
#'   print.xtable(add.to.row = merge_colnames(.))
#'
#' @export
merge_colnames <- function(xtab){
  header <- names(xtab)

  n <- rle(header)$lengths
  v <- rle(header)$values

  v <- sanitise_percent(v)

<<<<<<< HEAD
  names <- ifelse(n == 1, v, paste0("\\multicolumn{", n, "}{c}{", v, "}"))
=======
  names <- if_else(n == 1, v, paste0("\\multicolumn{", n, "}{c}{", v, "}"))
>>>>>>> 3be3d7c0189fcdf42cda2bc4076eaeba03bcaf6d

  colnames <- list()

  colnames$pos <- list(0)
  colnames$command <- makerow(names)

  return(colnames)
}

