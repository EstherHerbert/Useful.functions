#' For use with \code{xtable}'s \code{add.to.row} when
#' \code{tabular.environment = "longtable"}
#'
#' @description Format header information from an xtable for adding to the
#'              printed output at position 0.
#'
#' @param xtab An object of class \code{xtable}.
#' @param add.to.caption Text to be added to all but the last captions, default
#'                       is " (continued)".
#' @param footnote Text to be added to the footnote of all but the last page,
#'                 default is "Continued on next page".
#' @param double.header Logical, does the table have a double header?
#' @param pos position in table to insert the header commands, default is 0.
#'            Use 1 if double header is`TRUE`
#'
#' @return A single character string
#'
#' @examples
#'
#' xtab <- xtable::xtable(iris, caption = "Iris Data")
#' xtable::print.xtable(xtab, tabular.environment = "longtable", floating = FALSE,
#'                      hline.after = c(-1,0),
#'                      add.to.row = longtable_head(xtab))
#'
#' @export
longtable_head <- function(xtab,
                           add.to.caption = " (continued)",
                           footnote = "Continued on next page",
                           double.header = FALSE,
                           pos = 0){

  header <- makerow(sanitise_percent(names(xtab)))
  if(double.header){
    header <- paste0(header, "\n", makerow(xtab[1,]))
  }

  lhead <- list()
  lhead$pos <- list(pos)
  lhead$command <- paste0("\\endfirsthead\n\\caption[]{", attr(xtab, "caption"),
                          add.to.caption, "}\\\\\n\\hline\n", header,
                          "\n\\hline\n\\endhead\n\\hline\n{\\footnotesize ",
                          footnote, "} \n\\endfoot\n\\endlastfoot\n")

  return(lhead)

}
