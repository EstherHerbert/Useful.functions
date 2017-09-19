#' Produce a dataframe to summarise discrete variables
#' 
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#' 
#' @param df Data Frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' 
#' @export
discrete_table <- function(df        = .,
                           group     = group,
                           variables = c(),
                           ...){
  group <- enquo(group)
  variables <- enquo(variables)
  
  # duplicating data to obtail totals
  source('~/Documents/R/stata_expand.R')
  df <- df %>%
    stata_expand(n = 1) %>%
    mutate(
      !!quo_name(group) := if_else(Duplicate == 1, "Total", as.character(!!group))
    )
  
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
      p = formatC(n/N*100, digits = 1, format = "f"),
      np = paste0(n, " (", p, "%)")
    ) %>%
    select(-c(n,N,p)) %>%
    spread(key = !!group, value = np)
  
  return(new)
}