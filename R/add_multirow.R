#' For use with latex summary tables
#'
#' @description Turns duplicate rows which occur together into NAs and adds
#'              multirow to the remaining rows.
#'
#' @param x Character vector
#' @param width Desired width of column to be passed to multirow in latex. e.g.
#'              \code{"4cm"}
#'
#' @examples
#'     x <- c(rep("a", 5), rep("c", 2), rep("y", 7))
#'     add_multirow(x)
#'     add_multirow(x, width = "2cm")
#'
#' @export
add_multirow <- function(x, width = "4cm"){

  oldx <- c(FALSE, x[-1]==x[-length(x)])
  # is the value equal to the previous?
  res <- x
  res[oldx] <- NA

  # add multirow
  res[!is.na(res)] <- paste0("\\multirow{2}{", width, "}{",
                             res[!is.na(res)], "}")

  return(res)

}
