#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param time Optional variable for repeated measures
#'             (currenlty must me used with group)
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether percentages should be out of n
#'          (\code{n = TRUE}) or N (\code{n = FALSE})
#' @param missing String determining what missing data will be called
#'                (if \code{n = TRue}). Default is "Missing".
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
                           time = .,
                           total = TRUE,
                           n = FALSE,
                           missing = "Missing",
                           accuracy = 0.1) {
  require(tidyverse)
  require(magrittr)

  if(!missing(time) & missing(group)) {
    stop("Time can currenlty only be used with a group variable")
  }

  variables <- quos(...)

  if (!missing(group)) {
    group <- enquo(group)
  } else {
    total <- FALSE
  }

  if(!missing(time)) time <- enquo(time)

  # For totals
  if (total) {
    df <- df %>%
      totals(!!group)
  }

  if(!n){
    df %<>%
      mutate_at(
        vars(!!!variables),
        ~fct_explicit_na(., na_level = missing)
      )
  }

  if (!missing(group) & missing(time)) {
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
        ~if_else(variable == "N", paste("N =", .), .)
      )
  } else if(missing(group) & missing(time)) {
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
        ~if_else(variable == "N", paste("N =", .), .)
      )
  } else {
    new <- df %>%
      select(!!group, !!time, !!!variables) %>%
      gather(variable, scoring, -!!group, -!!time) %>%
      count(!!group, !!time, variable, scoring) %>%
      tidyr::complete(!!group, !!time, nesting(variable, scoring),
                      fill = list(n = 0)) %>%
      group_by(!!group, !!time, variable) %>%
      mutate(
        N = paste("N =", sum(n))
      ) %>%
      filter(!is.na(scoring)) %>%
      mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      ungroup() %>%
      gather(stat, value, -!!group, -!!time, -variable, -scoring) %>%
      spread(!!group, value) %>%
      mutate(
        !!time := if_else(stat == "N", stat, as.character(!!time)),
        variable = if_else(stat == "N", stat, variable),
        scoring = ifelse(stat %in% c("N", "n"), stat, scoring)
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat)
  }

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(~as.factor(.)) %>%
    as.list() %>%
    map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  if(!n){
    new %<>%
      filter(scoring != "n" | is.na(scoring))
  }

  if(missing(time)){
    suppressWarnings(
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
          ~if_else(scoring == "N", NA_character_, as.character(.))
        )
    )
  } else {
    order3 <- df %>%
      mutate(!!time := as.factor(!!time)) %>%
      select(!!time) %>%
      map(levels) %>%
      .[[1]]

    suppressWarnings(
      new %<>%
        mutate(
          !!time := parse_factor(!!time, c("N", order3)),
          variable = parse_factor(variable, c("N", order)),
          scoring = parse_factor(scoring, c("N", "n", order2) %>%
                                   .[!duplicated(.)]) %>%
            fct_relevel("Other", after = Inf) %>%
            fct_relevel("Missing", after = Inf)
        ) %>%
        arrange(!!time, variable, scoring) %>%
        mutate_at(
          vars(!!time, variable, scoring),
          ~if_else(scoring == "N", NA_character_, as.character(.))
        )
    )
  }

  return(new)

}
