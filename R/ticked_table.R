#' Produce a dataframe to summarise ticked variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              ticked variables.
#'
#' @param df Data Frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total logical indicating wether a total column should be created
#' @param set Optional variable that defines extra grouping. This is grouping
#'            obove the grouping given in \code{group}
#'
#' @export
ticked_table <- function(df        = .,
                         group     = group,
                         variables = c(),
                         total     = TRUE,
                         set       = .,
                         ...){
  require(tidyverse)

  group <- enquo(group)
  variables <- enquo(variables)
  if(!missing(set)){
    set <- enquo(set)
  }

  # duplicating data to obtail totals
  if(total){
    df <- df %>%
      stata_expand(n = 1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1, "All", as.character(!!group))
      ) %>%
      select(-Duplicate)
  }

  if(missing(set)){
    new <- df %>%
      select(!!group, !!variables) %>%
      gather(Scoring, tick, -!!group) %>%
      group_by(!!group, Scoring) %>%
      summarise(
        n = sum(!is.na(tick))
      ) %>%
      group_by(!!group) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = paste0(n, " (", p, "%)")
      ) %>%
      select(-c(n,N,p)) %>%
      spread(!!group, np)
  } else {
    new <- df %>%
      select(!!set, !!group, !!variables) %>%
      gather(Scoring, tick, -!!set, -!!group) %>%
      group_by(!!set, !!group, Scoring) %>%
      summarise(
        n = sum(!is.na(tick))
      ) %>%
      group_by(!!group) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = paste0(n, " (", p, "%)")
      ) %>%
      select(-c(n,N,p)) %>%
      unite(temp, !!set, !!group)
      spread(temp, np)
  }

  return(new)

}
