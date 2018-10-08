#' Mutates data frame so that summary tables give totals
#'
#' @description This function uses \code{stat_expand} and \code{mutate} to give
#'              a data frame that, when summarised, with give total rows and/or
#'              columns.
#'
#' @param df A data frame
#' @param ... one or two columns for which we require totals
#' @param name Character string for the name of the total row/column
#'
#' @examples
#'     totals(mtcars, cyl) %>%
#'     count(cyl)
#'
#'     totals(mtcars, cyl, vs, name = "All") %>%
#'     count(cyl, vs) %>%
#'     spread(cyl, n)
#'
#' @export
totals <- function(df = .,
                   ...,
                   name = "Total") {
  require(rlang)

  vars <- enquos(...)
  quo_vars <- sapply(vars, quo_name)

  if (length(vars) == 1) {
    out <- df %>%
      stata_expand(1) %>%
      mutate(
        !!quo_vars := if_else(Duplicate == 1, name , as.character(!!!vars))
      )
  } else if (length(vars) == 2) {
    var1 <- vars[[1]]
    var2 <- vars[[2]]
    out <- df %>%
      stata_expand(3) %>%
      mutate(
        !!quo_vars[[1]] := if_else(Duplicate %in% c(1, 3),
          name,
          as.character(!!!var1)
        ),
        !!quo_vars[[2]] := if_else(Duplicate %in% c(2, 3),
          name,
          as.character(!!!var2)
        )
      )
  } else {
    stop("totals only takes one or two column arguments")
  }

  return(out)
}
