#' Searches a list of dataframes.
#'
#' @description Takes a list of dataframes and searches their variables for
#'              either a specific variable name or for a string within the
#'              variable names.
#'
#' @usage search_list(ls, string, exact = TRUE, ignore.case = FALSE)
#'
#' @param ls A list of dataframes
#' @param string A string, either the exact variable name or something to search
#'               for.
#' @param exact Logical. If \code{exact = TRUE} then \code{search_list} finds
#'              the exact variable, if \code{exact = FALSE} then
#'              \code{search_list} finds all variable names containing that
#'              string using \code{stringr::str_detect()}.
#' @param ignore.case Logical. Determines whether to ignore case when
#'                    \code{exact = FALSE}.
#'
#' @return A data.frame
#'
#' @examples files <- list(mtcars = mtcars, iris = iris)
#' search_list(files, "Sepal", exact = F)
#' search_list(files, "hp")
#'
#' @export
search_list <- function(ls,
                        string,
                        exact = TRUE,
                        ignore.case = FALSE){

  v.names <- suppressWarnings(purrr::map2_df(ls, names(ls), function(x, y){
    data.frame(file = y, variable = names(x))
  }))

  if (exact) {
    dplyr::filter(v.names, variable == string)
  } else if (ignore.case) {
    v.names %>%
      dplyr::filter(stringr::str_detect(variable,
                                        stringr::coll(string,
                                                      ignore_case = TRUE)))
  } else {
    v.names %>%
      dplyr::filter(stringr::str_detect(variable, string))
  }

}
