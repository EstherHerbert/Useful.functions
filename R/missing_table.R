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
    df <- df %>%
      totals(!!group)
  }

  if (!missing(group)) {
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(variable, value, -!!group) %>%
      count(!!group, variable, is.na(value)) %>%
      group_by(!!group, variable) %>%
      mutate(
        n = paste0(n, " (", scales::percent(n/sum(n)), ")"),
        Missing = if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      select(-`is.na(value)`) %>%
      spread(group, n)
  }
  else {
    new <- df %>%
      select(!!!variables) %>%
      gather(variable, value) %>%
      count(variable, is.na(value)) %>%
      group_by(variable) %>%
      mutate(
        n = paste0(n, " (", scales::percent(n/sum(n)), ")"),
        Missing = if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      select(-`is.na(value)`)
  }

  new <- new %>%
    filter(Missing == format) %>%
    select(-Missing)

  return(new)
}
