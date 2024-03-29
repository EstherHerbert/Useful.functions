#' Mutates data frame so that summary tables give totals
#'
#' @description This function uses `stata_expand` and `dplyr::mutate` to give
#'              a data frame that, when summarised, with give total rows and/or
#'              columns.
#'
#' @param df A data frame
#' @param ... one or two columns for which we require totals
#' @param name Character string for the name of the total row/column
#'
#' @examples
#'     df <- totals(mtcars, cyl)
#'     dplyr::count(df)
#'
#' @export
totals <- function(df = .,
                   ...,
                   name = "Total") {
  vars <- rlang::enquos(...)
  quo_vars <- sapply(vars, rlang::quo_name)

  if (length(vars) == 1) {
    out <- df %>%
      stata_expand(1) %>%
      dplyr::mutate(
        !!quo_vars := dplyr::if_else(Duplicate == 1, !!name , as.character(!!!vars))
      )
  } else if (length(vars) == 2) {
    var1 <- vars[[1]]
    var2 <- vars[[2]]
    out <- df %>%
      stata_expand(3) %>%
      dplyr::mutate(
        !!quo_vars[[1]] := dplyr::if_else(Duplicate %in% c(1, 3),
          name,
          as.character(!!!var1)
        ),
        !!quo_vars[[2]] := dplyr::if_else(Duplicate %in% c(2, 3),
          name,
          as.character(!!!var2)
        )
      )
  } else {
    stop("totals only takes one or two column arguments")
  }

  return(out)
}
