#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param time Optional variable for repeated measures
#'             (currently must me used with group)
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether percentages should be out of n
#'          (\code{n = TRUE}) or N (\code{n = FALSE})
#' @param missing String determining what missing data will be called
#'                (if \code{n = TRue}). Default is "Missing".
#' @param accuracy see details of \code{scales::percent}
#' @param drop If \code{FALSE} then counts for empty groups (i.e. for levels of
#'             factors that don't exist in the data).
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
                           accuracy = 0.1,
                           drop = TRUE) {
  require(tidyverse)
  require(magrittr)

  if(!missing(time) & missing(group)) {
    stop("Time can currenlty only be used with a group variable")
  }

  if (missing(group)) {
    total <- FALSE
  }

  # For totals
  if (total) {
    df <- df %>%
      totals({{group}})
  }

  if(!n){
    df <- df %>%
      mutate_at(
        vars(...),
        ~fct_explicit_na(., na_level = missing)
      )
  }

  if (!missing(group) & missing(time)) {
    new <- df %>%
      select({{group}}, ...) %>%
      pivot_longer(-{{group}}, names_to = "variable", values_to = "scoring") %>%
      count({{group}}, variable, scoring, .drop = drop) %>%
      tidyr::complete({{group}}, nesting(variable, scoring),
                      fill = list(n = 0)) %>%
      group_by({{group}}, variable) %>%
      mutate(
        N = sum(n)
      ) %>%
      filter(!is.na(scoring)) %>%
      mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      ungroup() %>%
      pivot_longer(-c({{group}}, variable, scoring), names_to = "stat",
                   values_to = "value",
                   values_transform = list(value = as.character)) %>%
      pivot_wider(names_from = {{group}}, values_from = value) %>%
      mutate(
        variable = if_else(stat == "N", stat, variable),
        scoring = ifelse(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -scoring),
        ~if_else(variable == "N", paste("N =", .), .)
      )
  } else if(missing(group) & missing(time)) {
    new <- df %>%
      select(...) %>%
      pivot_longer(everything(), names_to = "variable",
                   values_to = "scoring") %>%
      count(variable, scoring, .drop = drop) %>%
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
      pivot_longer(-c(variable, scoring), names_to = "stat",
                   values_to = "value",
                   values_transform = list(value = as.character)) %>%
      mutate(
        variable = if_else(stat == "N", stat, variable),
        scoring = if_else(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.), ] %>%
      select(-stat) %>%
      mutate_at(
        vars(-variable, -scoring),
        ~if_else(variable == "N", paste("N =", .), .)
      )
  } else {
    new <- df %>%
      select({{group}}, {{time}}, ...) %>%
      pivot_longer(-c({{group}}, {{time}}), names_to = "variable",
                   values_to = "scoring") %>%
      count({{group}}, {{time}}, variable, scoring, .drop = drop) %>%
      tidyr::complete({{group}}, {{time}}, nesting(variable, scoring),
                      fill = list(n = 0)) %>%
      group_by({{group}}, {{time}}, variable) %>%
      mutate(
        N = paste("N =", sum(n))
      ) %>%
      filter(!is.na(scoring)) %>%
      mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      ungroup() %>%
      pivot_longer(-c({{group}}, {{time}}, variable, scoring),
                   names_to = "stat", values_to = "value",
                   values_transform = list(value = as.character)) %>%
      pivot_wider(names_from = {{group}}, values_from = value) %>%
      mutate(
        {{time}} := if_else(stat == "N", stat, as.character({{time}})),
        variable = if_else(stat == "N", stat, variable),
        scoring = ifelse(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat)
  }

  order <- select(df, ...) %>%
    colnames()

  order2 <- df %>%
    select(...) %>%
    mutate_all(~as.factor(.)) %>%
    as.list() %>%
    map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  if(!n){
    new <- new %>%
      filter(scoring != "n" | is.na(scoring))
  }

  if(missing(time)){
    suppressWarnings(
      new <- new %>%
        mutate(
          variable = parse_factor(variable, c("N", order)),
          scoring = parse_factor(scoring, c("N", "n", order2) %>%
                                   .[!duplicated(.)]) %>%
            fct_relevel("Other", after = Inf) %>%
            fct_relevel(missing, after = Inf)
        ) %>%
        arrange(variable, scoring) %>%
        mutate_at(
          vars(variable, scoring),
          ~if_else(scoring == "N", NA_character_, as.character(.))
        )
    )
  } else {
    order3 <- df %>%
      mutate({{time}} := as.factor({{time}})) %>%
      select({{time}}) %>%
      map(levels) %>%
      .[[1]]

    suppressWarnings(
      new <- new %>%
        mutate(
          {{time}} := parse_factor({{time}}, c("N", order3)),
          variable = parse_factor(variable, c("N", order)),
          scoring = parse_factor(scoring, c("N", "n", order2) %>%
                                   .[!duplicated(.)]) %>%
            fct_relevel("Other", after = Inf) %>%
            fct_relevel("Missing", after = Inf)
        ) %>%
        arrange({{time}}, variable, scoring) %>%
        mutate_at(
          vars({{time}}, variable, scoring),
          ~if_else(scoring == "N", NA_character_, as.character(.))
        )
    )
  }

  return(new)

}
