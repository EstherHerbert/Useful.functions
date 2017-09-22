#' Sanitise function for use with print.xtable
#'
#' @description Takes a string of text and sanitises only the use of "%" for
#'              use with latex
#'
#' @param str String of text
#'
#' @examples
#'     str <- "\\multirow{2}{4cm}{75%}"
#'     sanitise_percent(str)
#'
#' @export
sanitise_percent <- function (str){

  result <- str
  result <- gsub("%", "\\%", result, fixed = TRUE)

  return(result)

}
