#' Produce a dataframe to summarise data completeness for variables
#'
#' @description Takes a dataframe and calculates the proportions present/missing
#'              for given variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param format Should the propotion missing or present be given?
#' @param total Logical indicating whether a total column should be created
#'
#' @return A tibble data frame summarising the data completeness
#'
#' @export
missing_table <- function (df = .,
                           ...,
                           group = .,
                           format = "Missing",
                           total = TRUE)
{
  require(tidyverse)
  require(magrittr)

  variables <- quos(...)

  if (!missing(group)) {
    group <- enquo(group)
  }
  else {
    total <- FALSE
  }

  if (total) {
    df <- df %>% totals(!!group)
  }

  if (!missing(group)) {
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(variable, value, -!!group) %>%
      count(!!group, variable, is.na(value)) %>%
      tidyr::complete(!!group, variable, `is.na(value)`, fill = list(n = 0)) %>%
      group_by(!!group, variable) %>%
      mutate(
        N = sum(n),
        n = paste0(n, " (", scales::percent(n/N, accuracy = 0.1), ")"),
        Missing = if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      select(-`is.na(value)`) %>%
      ungroup %>%
      gather(stat, value, n, N) %>%
      spread(!!group, value) %>%
      mutate_at(
        vars(variable, Missing),
        ~if_else(stat == "N", "N", .)
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -Missing),
        funs(if_else(variable == "N", paste("N =", .), .))
      )
  }
  else {
    new <- df %>%
      select(!!!variables) %>%
      gather(variable, value) %>%
      count(variable, is.na(value)) %>%
      tidyr::complete(variable, `is.na(value)`, fill = list(n = 0)) %>%
      group_by(variable) %>%
      mutate(
        N = sum(n),
        n = paste0(n, " (", scales::percent(n/N, accuracy = 0.1), ")"),
        Missing = if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      select(-`is.na(value)`) %>%
      ungroup %>%
      gather(stat, value, n, N) %>%
      mutate_at(
        vars(variable, Missing),
        ~if_else(stat == "N", "N", .)
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -Missing),
        funs(if_else(variable == "N", paste("N =", .), .))
      )
  }

  order <- sapply(variables, FUN = quo_name)

  new <- new %>%
    mutate(
      variable = parse_factor(variable, c("N", order))
    ) %>%
    arrange(variable) %>%
    filter(Missing %in% c(format, "N")) %>%
    select(-Missing)

  return(new)
}
