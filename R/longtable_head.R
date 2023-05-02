#' For use with \code{xtable}'s \code{add.to.row} when
#' \code{tabular.environment = "longtable"}
#'
#' @description Format header information from an xtable for adding to the
#'              printed output at position 0.
#'
#' @param xtab An object of class \code{xtable}.
#' @param footnote A character string
#'
#' @return A single character string
#'
#' @examples
#'
#' xtable::xtable(iris, caption = "Iris Data") %>%
#'     xtable::print.xtable(tabular.environment = "longtable", floating = F,
#'                          hline.after = c(-1,0),
#'                          add.to.row = longtable_head(.))
#'
#' @export
longtable_head <- function(xtab,
                           add.to.caption = " (continued)",
                           footnote = "Continued on next page",
                           double.header = FALSE,
                           pos = 0){

  header <- makerow(names(xtab))
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
