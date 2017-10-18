#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total Logical indicating wether a total column should be created
#' @param set Optional variable that defines extra grouping. This is grouping
#'            obove the grouping given in \code{group}
#'
#' @examples
#'     library(ggplot2)
#'     discrete_table(df = mpg, group = manufacturer, variables = c(drv, year))
#'
#' @return A tibble data frame summarising the data
#'
#' @export
discrete_table <- function(df        = .,
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
      )
  }

  if(missing(set)){
    new <- df %>%
      select(!!group, !!variables) %>%
      gather(key = variable, value = Scoring, -!!group)

    dims <- length(unique(new$variable)) # to correct the column totals

    new <- new %>%
      stata_expand(1) %>%
      mutate(
        variable = if_else(Duplicate == 1, "N", variable),
        Scoring = if_else(Duplicate == 1, "", Scoring)
      ) %>%
      group_by(!!group, variable, Scoring) %>%
      summarise(
        n = n()
      ) %>%
      group_by(!!group, variable) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = if_else(variable == "N",
                     paste("N =", N/dims),
                     paste0(n, " (", p, "%)"))
      ) %>%
      select(-c(n,N,p)) %>%
      spread(key = !!group, value = np)
  } else {
    new <- df %>%
      select(!!set, !!group, !!variables) %>%
      gather(key = variable, value = Scoring, -!!set, -!!group)

    dims <- length(unique(new$variable)) # to correct the column totals

    new <- new %>%
      stata_expand(1) %>%
      mutate(
        variable = if_else(Duplicate == 1, "N", variable),
        Scoring = if_else(Duplicate == 1, "", Scoring)
      ) %>%
      group_by(!!set, !!group, variable, Scoring) %>%
      summarise(
        n = n()
      ) %>%
      group_by(!!set, !!group, variable) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = if_else(variable == "N",
                     paste("N =", N/dims),
                     paste0(n, " (", p, "%)"))
      ) %>%
      select(-c(n,N,p)) %>%
      unite(temp, !!set, !!group) %>%
      spread(key = temp, value = np)
  }

  # Putting column totals at the top
  new$variable <- as.factor(new$variable) %>%
    relevel("N")

  new <- new %>%
    ungroup() %>%
    select(-(variable:Scoring)) %>%
    names() %>%
    mutate_at(new,
              .,
              funs(if_else(is.na(.), "0 (0.0%)", .))
    ) %>%
    mutate(
      Scoring = if_else(is.na(Scoring), "Missing", Scoring)
    ) %>%
    arrange(variable)

  return(new)

}
