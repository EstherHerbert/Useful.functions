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
#' iris2 <- split_colnames(iris, sep = "\\.")
#'
#' xtab <- xtable::xtable(iris2)
#' xtable::print.xtable(xtab, add.to.row = merge_colnames(xtab))
#'
#' @export
merge_colnames <- function(xtab){
  header <- names(xtab)

  n <- rle(header)$lengths
  v <- rle(header)$values

  v <- sanitise_percent(v)

  names <- ifelse(n == 1, v, paste0("\\multicolumn{", n, "}{c}{", v, "}"))

  colnames <- list()

  colnames$pos <- list(0)
  colnames$command <- makerow(names)

  return(colnames)
}

