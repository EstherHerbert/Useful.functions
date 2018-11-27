#' Searches a list of dataframes.
#'
#' @description Takes a list of dataframes and searches their variables for
#'              either a specific variable name or for a string within the
#'              variable names.
#'
#' @usage search_list(ls, string, exact = TRUE)
#'
#' @param ls A list of dataframes
#' @param string A string, either the exact variable name or something to search
#'               for.
#' @param exact Logical. If \code{exact = TRUE} then \code{search_list} finds
#'              the exact variable, if \code{exact = FALSE} then
#'              \code{search_list} finds all variable names containing that
#'              string using \code{stringr::str_detect()}.
#'
#' @return A data.frame
#'
#' @examples files <- list(mtcars = mtcars, iris = iris)
#' search_list(files, "Sepal", exact = F)
#' search_list(files, "hp")
#'
#' @export
search_list <- function(ls, string, exact = TRUE){

  require(tidyverse)

  v.names <- suppressWarnings(map2_df(ls, names(ls), function(x, y){
    data.frame(file = y, variable = names(x))
  }))

  if (exact) {
    filter(v.names, variable == string)
  } else {
    v.names %>%
      filter(str_detect(variable, string))
  }

}
