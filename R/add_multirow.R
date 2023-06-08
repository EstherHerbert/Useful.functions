#' For use with latex summary tables
#'
#' @description Turns duplicate rows which occur together into NAs and adds
#'              multirow to the remaining rows.
#'
#' @param x Character vector
#' @param width Desired width of column to be passed to multirow in latex. e.g.
#'              `"4cm"`
#' @param pos Character defining the vertical positioning of the text in the
#'            multirow block. Default is "t" - top. Other options are "c" for
#'            centre or "b" for bottom.
#' @param rows Optional number of rows to use, if not given then
#'             `add_multirow` calculates how many rows to use.
#' @param reverse If `TRUE` then all by the last duplicate will be
#'                removed. If rows isn't given then the calculated number of
#'                rows will be negated. This features is useful when colouring
#'                tables.
#'
#' @return A character string/vector
#'
#' @examples
#'     x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
#'     add_multirow(x)
#'     add_multirow(x, reverse = TRUE)
#'     add_multirow(x, width = "2cm", pos = "c")
#'
#' @export
add_multirow <- function(x, width = "4cm", pos = "t", rows, reverse = FALSE) {

  if (is.factor(x)) {
    x <- as.character(x)
  }

  n <- rle(x[!is.na(x)])$lengths

  if (!reverse) {
    x[duplicated(x)] <- NA
  } else if (reverse) {
    x[rev(duplicated(rev(x)))] <- NA
    n <- -1 * n
  }

  if (missing(rows)) {
    rows <- n
  }

  # add multirow
  x[!is.na(x)] <- paste0(
    "\\multirow[", pos, "]{", rows, "}{", width, "}{",
    x[!is.na(x)], "}"
  )

  return(x)
}
