#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param total Logical indicating wether a total column should be created
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
                           total = TRUE){

  variables <- quos(...)

  if(!missing(group)){
    group <- enquo(group)
  } else {
    total = FALSE
  }

  # For totals
  if(total){
    df <- df %>%
      stata_expand(1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1,
                                     "Total",
                                     as.character(!!group))
      )
  }

  if(!missing(group)){
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(variable, scoring, -!!group) %>%
      count(!!group, variable, scoring) %>%
      group_by(!!group, variable) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = paste0(n, " (", p, "%)")
      ) %>%
      ungroup() %>%
      select(-c(n,p)) %>%
      gather(stat, value, -!!group, -variable, -scoring) %>%
      spread(!!group, value, fill = "0 (0.0%)") %>%
      mutate_at(
        vars(variable, scoring),
        funs(if_else(stat == "N", "N", as.character(.)))
      ) %>%
      .[!duplicated(.[1:3]),] %>%
      select(-stat)
  } else {
    new <- df %>%
      select(!!!variables) %>%
      gather(variable, scoring) %>%
      count(variable, scoring) %>%
      group_by(variable) %>%
      mutate(
        N = sum(n),
        p = round0(n/N*100, 1),
        np = paste0(n, " (", p, "%)")
      ) %>%
      ungroup() %>%
      select(-c(n,p)) %>%
      gather(stat, value, -variable, -scoring) %>%
      mutate_at(
        vars(variable, scoring),
        funs(if_else(stat == "N", "N", as.character(.)))
      ) %>%
      .[!duplicated(.),] %>%
      select(-stat)
  }

  order <- sapply(variables, FUN = quo_name)

  order2 <- df %>%
    select(!!!variables) %>%
    mutate_all(funs(as.factor(.))) %>%
    as.list() %>%
    map(~levels(.)) %>%
    unlist(.) %>%
    unname()

  print(order2)

  new %<>%
    mutate(
      variable = parse_factor(variable, c("N",order)),
      scoring = parse_factor(scoring, c("N", order2))
    ) %>%
    arrange(variable, scoring)

  return(new)

}
