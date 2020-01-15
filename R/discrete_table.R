#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether percentages should be out of n
#'          (\code{n = TRUE}) or N (\code{n = FALSE})
#' @param accuracy see details of \code{scales::percent}
#'
#' @examples
#'     library(ggplot2) # for the data
#'     discrete_table(df = mpg, drv, year, group = manufacturer)
#'     discrete_table(df = mpg, drv)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
discrete_table <- function(df = .,
                           ...,
                           group = .,
                           total = TRUE,
                           n = FALSE,
                           accuracy = 0.1) {
  require(tidyverse)
  require(magrittr)

  variables <- quos(...)

  if (!missing(group)) {
    group <- enquo(group)
  } else {
    total <- FALSE
  }

  # For totals
  if (total) {
    df <- df %>%
      totals(!!group)
  }

  if(!n){
    df %<>%
      mutate_at(
        vars(!!!variables),
        funs(fct_explicit_na(., na_level = "Missing"))
      )
  }

  if (!missing(group)) {
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(variable, scoring, -!!group) %>%
      count(!!group, variable, scoring) %>%
      tidyr::complete(!!group, nesting(variable, scoring), fill = list(n = 0)) %>%
      group_by(!!group, variable) %>%
      mutate(
        N = sum(n)
      ) %>%
      filter(!is.na(scoring)) %>%
      mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      ungroup() %>%
      gather(stat, value, -!!group, -variable, -scoring) %>%
      spread(!!group, value) %>%
      mutate(
        variable = if_else(stat == "N", stat, variable),
        scoring = ifelse(stat %in% c("N", "n"), stat, scoring)
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -scoring),
        funs(if_else(variable == "N", paste("N =", .), .))
      )
  } else {
    new <- df %>%
      select(!!!variables) %>%
      gather(variable, scoring) %>%
      count(variable, scoring) %>%
      group_by(variable) %>%
      mutate(
        N = sum(n)
      ) %>%
      filter(!is.na(scoring)) %>%
      mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      ungroup() %>%
      gather(stat, value, -variable, -scoring) %>%
      mutate(
        variable = if_else(stat == "N", stat, variable),
        scoring = if_else(stat %in% c("N", "n"), stat, scoring)
      ) %>%
      .[!duplicated(.), ] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -scoring),
        funs(if_else(variable == "N", paste("N =", .), .))
      )
  }

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(funs(as.factor(.))) %>%
    as.list() %>%
    map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  if(!n){
    new %<>%
      filter(scoring != "n" | is.na(scoring))
  }

  new %<>%
    mutate(
      variable = parse_factor(variable, c("N", order)),
      scoring = parse_factor(scoring, c("N", "n", order2) %>%
                               .[!duplicated(.)]) %>%
        fct_relevel("Other", after = Inf) %>%
        fct_relevel("Missing", after = Inf)
    ) %>%
    arrange(variable, scoring) %>%
    mutate_at(
      vars(variable, scoring),
      funs(if_else(scoring == "N", NA_character_, as.character(.)))
    )

  return(new)
}
