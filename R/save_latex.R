#' Save output from print.xtable
#'
#' @description Saves output from print.xtable without having to wrap
#'              \code{sink()} above and below.
#' @usage save_latex(latex, file)
#'
#' @param latex Output from \code{print.xtable}
#' @param file File location to save to.
#'
#' @export
save_latex <- function(latex, file){
  sink(file)
  cat(latex)
  sink()
}
