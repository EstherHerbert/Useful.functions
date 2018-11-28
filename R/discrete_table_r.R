#' Produce a dataframe to summarise discrete variables with row percentages.
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables. Unlike \code{discrete_table} this function
#'              gives row sums.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Variable that defines the grouping
#'
#' @examples
#'     library(ggplot2) # for the data
#'     discrete_table_r(df = mpg, drv, year, group = manufacturer)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
discrete_table_r <- function(df = .,
                             ...,
                             group = .) {
  require(tidyverse)
  require(magrittr)

  variables <- quos(...)
  group <- enquo(group)

  df %<>%
    mutate_at(
      vars(!!!variables),
      funs(fct_explicit_na(., na_level = "Missing"))
    )

  new <- df %>%
    select(!!group, !!!variables) %>%
    gather(variable, scoring, -!!group) %>%
    count(!!group, variable, scoring) %>%
    group_by(variable, scoring) %>%
    mutate(
      Total = sum(n),
      n = paste0(n, " (", scales::percent(n/Total), ")")
    ) %>%
    spread(!!group, n, fill = "0 (0.0%)") %>%
    ungroup()

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(funs(as.factor(.))) %>%
    as.list() %>%
    map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  new %<>%
    mutate(
      variable = parse_factor(variable, c("N", order)),
      scoring = parse_factor(scoring, c("N", order2) %>% .[!duplicated(.)]) %>%
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
