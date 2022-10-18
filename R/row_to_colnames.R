#' Tools for working with column names
#'
#' @description Takes a row of data and uses it to replace the column names.
#'
#' @param df A data frame.
#' @param row Row number to convert to the column names, default is the first
#'            row.
#' @export
row_to_colnames <- function(df, row = 1){

  new <- df

  colnames(new) <- stringr::str_replace_na(df[row,], " ")

  new <- new[-row,]

  return(new)

}
