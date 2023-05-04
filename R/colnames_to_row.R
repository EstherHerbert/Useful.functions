#' Move the column names of a data frame to a row
#'
#' Moving the column names of a data frame to a row is sometimes useful when
#' formatting a table for export. This function does that and the user can
#' specify which row they'd like the column names to be insterted before.
#'
#' @param df the data frame
#' @param row the row number before which the column names will be inserted,
#'            default is (i.e., the names would become the first row of the data
#'            frame).
#'
#' @returns a data frame with column names in tact but added as a row
#'
#' @examples
#'
#' colnames_to_row(iris)
#' colnames_to_row(iris, row = 5)
#'
#' @export
colnames_to_row <- function(df, row = 1) {

  colnames <- names(df)
  colnames <- setNames(colnames, colnames)

  new <- dplyr::mutate(df, dplyr::across(dplyr::everything(), ~as.character(.x)))

  new <- dplyr::add_row(new, !!!colnames, .before = row)

  return(new)

}
