#' Produce a dataframe to summarise adverse event data.
#'
#' @description Takes a dataframe of adverse events and produces the number of
#'              events and number and percentage of individuals with an adverse
#'              event.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Variable that defines the grouping
#' @param ID Variable that defines the individual identifier (e.g. screening
#'           number)
#' @param accuracy see details of \code{scales::percent}
#'
#' @export
ae_table <- function(df = .,
                     ...,
                     group = .,
                     ID = .,
                     N = .,
                     accuracy = 0.1) {

  require(tidyverse)

  variables <- quos(...)
  group <- enquo(group)
  ID <- enquo(ID)

  new <- df %>%
    gather(variable, scoring, !!!variables) %>%
    group_by(!!group, variable, scoring) %>%
    summarise(
      events = n(),
      individuals = n_distinct(!!ID)
    ) %>%
    ungroup() %>%
    left_join(N) %>%
    complete(!!group, nesting(variable, scoring),
             fill = list(events = 0, individuals = 0)) %>%
    mutate(
      individuals = paste0(individuals, " (",
                           scales::percent(individuals/N, accuracy = accuracy),
                           ")"),
      N = paste("N =", N)
    ) %>%
    gather(stat, value, events, individuals) %>%
    unite(group, !!group, stat) %>%
    gather(stat, value, N, value) %>%
    spread(group, value) %>%
    mutate_at(
      vars(variable, scoring),
      ~if_else(stat == "N", "N", .)
    ) %>%
    .[!duplicated(.),] %>%
    select(-stat)

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(~as.factor(.)) %>%
    as.list() %>%
    map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  suppressWarnings(
    new <- new %>%
      mutate(
        variable = parse_factor(variable, c("N", order)),
        scoring = parse_factor(scoring, c("N", order2) %>%
                                 .[!duplicated(.)]) %>%
          fct_relevel("Other", after = Inf) %>%
          fct_relevel("Missing", after = Inf)
      ) %>%
      arrange(variable, scoring) %>%
      mutate_at(
        vars(variable, scoring),
        ~if_else(scoring == "N", NA_character_, as.character(.))
      )
  )

  return(new)
}
