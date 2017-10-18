#' Produce a dataframe to summarise ticked variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              ticked variables.
#'
#' @param df Data Frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total Logical indicating wether a total column should be created
#' @param set Optional variable that defines extra grouping. This is grouping
#'            obove the grouping given in \code{group}
#'
#' @return A tibble data frame summarising the data
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
      gather(Scoring, tick, -!!group)
    dims <- length(unique(new$Scoring))
    new <- new %>%
      group_by(!!group, Scoring) %>%
      summarise(
        N = n(),
        n = sum(!is.na(tick)),
        p = round0(n/N*100, 1),
        np = paste0(n," (",p,"%)"),
        N = paste0("N = ", N)
      )%>%
      select(-c(n,p)) %>%
      gather(variable, value, -!!group, -Scoring) %>%
      spread(!!group, value) %>%
      mutate(
        Scoring = if_else(variable == "N", "N", Scoring)
      ) %>%
      select(-variable)
  } else {
    new <- df %>%
      select(!!set, !!group, !!variables) %>%
      gather(Scoring, tick, -!!set, -!!group)
    dims <- length(unique(new$Scoring))
    new <- new %>%
      group_by(!!set, !!group, Scoring) %>%
      summarise(
        N = n(),
        n = sum(!is.na(tick)),
        p = round0(n/N*100, 1),
        np = paste0(n," (",p,"%)"),
        N = paste0("N = ", N)
      ) %>%
      select(-c(n,p)) %>%
      unite(temp, !!set, !!group) %>%
      gather(variable, value, -temp, -Scoring) %>%
      spread(temp, value) %>%
      mutate(
        Scoring = if_else(variable == "N", "N", Scoring)
      ) %>%
      select(-variable)
  }

  new$Scoring <- as.factor(new$Scoring) %>%
    relevel("N")

  new <- arrange(new, Scoring) %>%
    .[-c(1:dims-1),]

  return(new)

}
