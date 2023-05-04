#' Adds LaTex `\clines` to an object of class `"xtable"`
#'
#' Produces a list with 'pos' and 'command' to use with `xtable()`'s
#' `add.to.row` option. This will create a partial horizontal line across
#' specified columns of the table. Users can either specify the row numbers
#' they'd like to add the cline to or the function will look for the rows which
#' use multirow in a specified column.
#'
#' @param xtab the `xtable` object
#' @param rows either `"multirow"` (the default) or row numbers to add a cline
#'             to
#' @param cols a character string with the columns over which to draw the cline
#'             (e.g, `"2-3"`)
#' @param check.column a character string of the column to check when
#'                     `rows = "multirow"`
#'
#' @returns A list with levels 'pos' and 'command' to give to the `add.to.row`
#'          option of `xtable()`.
#'
#' @examples
#'
#' library(xtable)
#'
#' xtab <- xtable(head(iris))
#'
#' print(xtab, add.to.row = add_clines(., rows = c(2, 3), cols = "3-4"))
#'
#' @export
add_clines <- function(xtab, rows = "multirow", cols, check.column){

  if(length(rows) == 1){
    if(rows == "multirow"){
      if(missing(check.column))
        stop("when rows is 'multirow' a check.column name or number must be given")
      rows <- str_which(xtab[,check.column], "\\\\multirow") - 1
    }
  }

  clines <- list()
  clines$pos <- list(rows)
  clines$command <- paste0("\\cline{", cols, "}\n")

  return(clines)

}
