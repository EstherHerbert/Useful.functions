#' Combines the functions merge, select and filter to simplify combining
#' data.frames from prospect.
#'
#' @description Often when working from prospect we need to create a data set
#'              made up from variables from various difference data.frames with
#'              filtering applied too. \code{%>%} simplifies this process but
#'              it is still fiddly if you have to use merge, filter and select
#'              for two different data frames. This function does that.
#'
#' @param data.x The first data frame.
#' @param data.y The second data frame.
#' @param select.x Variables to select from the first data frame.
#' @param select.y See \code{select.x}.
#' @param filter.x Rules for filtering the first data frame, unlike in the
#'                 function \code{filter()} we must use \code{&} to sepperate
#'                 our rules.
#' @param filter.y See \code{filter.x}.
#' @param by A vector of character strings giving the columns to merge by.
#'
#' @return A tibble data frame combining the two data frames with the rules
#'         given applied.
#'
#' @examples
#'    x <- data.frame(ID = 1:5, height = rnorm(5, 167, 20),
#'                    group = sample(c("A", "B"), 5, replace = T))
#'    y <- data.frame(ID = 1:5, weight = rnorm(5, 70, 15),
#'                    waist = rnorm(5, 32, 3))
#'
#'    merge_select_filter(x, y, select.x = c(ID, height),
#'                        select.y = c(ID, weight),
#'                        filter.x = height > 130 & group == "A",
#'                        filter.y = weight > 60, by = "ID")
#'
#' @export

merge_select_filter <- function(data.x = .,
                                data.y = .,
                                select.x = c(),
                                select.y = c(),
                                filter.x = .,
                                filter.y = .,
                                by = c(),
                                ...){

  select.x <- enquo(select.x)
  select.y <- enquo(select.y)
  filter.x <- enquo(filter.x)
  filter.y <- enquo(filter.y)

  new.x <- filter_(data.x, filter.x)
  new.y <- filter_(data.y, filter.y)


  new.new.x <- select_(new.x, select.x)
  new.new.y <- select_(new.y, select.y)

  new <- merge(new.new.x, new.new.y, by, ...)

  return(new)
}
