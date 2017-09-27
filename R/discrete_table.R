#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total logical indicating wether a total column should be created
#'
#' @examples
#'     library(ggplot2)
#'     discrete_table(df = mpg, group = manufacturer, variables = c(drv, year))
#'
#' @export
discrete_table <- function(df        = .,
                           group     = group,
                           variables = c(),
                           total = TRUE,
                           ...){
  group <- enquo(group)
  variables <- enquo(variables)

  # duplicating data to obtail totals
  if(total){
    df <- df %>%
      stata_expand(n = 1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1, "Total", as.character(!!group))
      )
  }

  new <- df %>%
    select(!!group, !!variables) %>%
    gather(key = variable, value = Scoring, -!!group) %>%
    group_by(!!group, variable, Scoring) %>%
    summarise(
      n = n()
    ) %>%
    group_by(!!group, variable) %>%
    mutate(
      N = sum(n),
      p = round(n/N*100, 1),
      np = paste0(n, " (", p, "%)")
    ) %>%
    select(-c(n,N,p)) %>%
    spread(key = !!group, value = np)

  return(new)

}
