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
#' @param total Logical indicating whether a total column should be created
#'
#' @export
ae_table <- function (df = .,
                      ...,
                      group = .,
                      ID = .,
                      N = .,
                      accuracy = 0.1,
                      total = FALSE) {

  require(tidyverse)

  variables <- quos(...)
  ID <- enquo(ID)

  if(!missing(group)) group <- enquo(group) else total <- FALSE

  if(total){
    df <- df %>%
      totals(!!group)
  }

  if(!missing(group)){
    new <- df %>%
      pivot_longer(cols = c(!!!variables), names_to = "variable",
                   values_to = "scoring",
                   values_transform = list(scoring = as.character)) %>%
      group_by(!!group, variable, scoring) %>%
      summarise(
        events = n(),
        across(!!ID, n_distinct, .names = "individuals"),
        .groups = "drop"
      ) %>%
      complete(!!group, nesting(variable, scoring),
               fill = list(events = 0, individuals = 0)
      ) %>%
      left_join(N) %>%
      mutate(
        individuals = paste0(individuals, " (",
                             scales::percent(individuals/N,
                                             accuracy = accuracy), ")"),
        N = paste("N =", N)
      ) %>%
      pivot_longer(events:individuals, names_to = "stat", values_to = "value",
                   values_transform = list(value = as.character)) %>%
      unite(group, !!group, stat) %>%
      pivot_longer(cols = c(N, value), names_to = "stat",
                   values_to = "value") %>%
      pivot_wider(names_from = group, values_from = value) %>%
      mutate(
        across(c(variable, scoring), ~if_else(stat == "N", "N", .))
      ) %>%
      .[!duplicated(.), ] %>%
      select(-stat)
  } else {
    new <- df %>%
      pivot_longer(cols = c(!!!variables), names_to = "variable",
                   values_to = "scoring",
                   values_transform = list(scoring = as.character)) %>%
      group_by(variable, scoring) %>%
      summarise(
        events = n(),
        across(!!ID, n_distinct, .names = "individuals"),
        .groups = "drop"
      ) %>%
      bind_cols(N) %>%
      mutate(
        individuals = paste0(individuals, " (",
                             scales::percent(individuals/N,
                                             accuracy = accuracy), ")"),
        N = paste("N =", N)
      ) %>%
      pivot_longer(events:individuals, names_to = "group", values_to = "value",
                   values_transform = list(value = as.character)) %>%
      pivot_longer(cols = c(N, value), names_to = "stat",
                   values_to = "value") %>%
      pivot_wider(names_from = group, values_from = value) %>%
      mutate(
        across(c(variable, scoring), ~if_else(stat == "N", "N", .))
      ) %>%
      .[!duplicated(.), ] %>%
      select(-stat)
  }

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(~as.factor(.)) %>%
    as.list() %>%
    map(~levels(.)) %>%
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
      mutate(
        across(.cols = c(variable, scoring),
               .fns = ~if_else(scoring == "N", NA_character_, as.character(.)))
      )
  )

  return(new)

}
