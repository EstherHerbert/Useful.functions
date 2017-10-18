#' Produce a dataframe to summaries continuous variables
#'
#' @description Takes a dataframe and produces grouped or ungrouped summaries
#'              such as mean and standard deviation for continuous variables.
#'
#' @param df Data frame
#' @param group Optional variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total Logical indicating wether a total column should be created
#'
#' @examples
#'     continuous_table(df = iris, group = Species,
#'                      variables = c(Petal.Length, Petal.Width))
#'     continuous_table(df = iris, group = Species,
#'                      variables = c(Sepal.Length, Sepal.Width),
#'                      total = FALSE)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
continuous_table <- function(df        = .,
                             group = .,
                             variables = c(),
                             total     = TRUE,
                             ...){
  require(tidyverse)
  if(!missing(group)){
    group <- enquo(group)
  } else {
    total <- FALSE
  }
  variables <- enquo(variables)

  # duplicating data to obtail totals
  if(total){
    df <- df %>%
      stata_expand(n = 1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1, "All", as.character(!!group))
      )
  }

  if(!missing(group)){
    new <- df %>%
      select(!!group, !!variables) %>%
      gather(key = variable, value = value, -!!group)

    dims <- length(unique(new$variable))

    new <- new %>%
      group_by(!!group, variable) %>%
      summarise(
        N = n(),
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        q25 = round0(quantile(value, probs = 0.25, na.rm = T), 1),
        q75 = round0(quantile(value, probs = 0.75, na.rm = T), 1),
        min = round0(min(value, na.rm = T), 1),
        max = round0(max(value, na.rm = T), 1),
        mis = sum(is.na(value)),
        p = round0(mis/N*100, 1)
      ) %>%
      mutate(
        N = paste0("N = ", N),
        `Mean (SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", q25, "-", q75, ")"),
        `Min - Max` = paste0(min, " - ", max),
        Missing = paste0(mis," (",p,"%)")
      ) %>%
      select(-c(m,sd,med,q25,q75,min,max,mis,p)) %>%
      gather(key = Scoring, value = value, -!!group, -variable) %>%
      spread(key = !!group, value = value) %>%
      mutate(
        variable = if_else(Scoring == "N", "N", variable)
      )
  } else{
    new <- df %>%
      select(!!variables) %>%
      gather(key = variable, value = value)

    dims <- length(unique(new$variable))

    new <- new %>%
      group_by(variable) %>%
      summarise(
        N = n(),
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        q25 = round0(quantile(value, probs = 0.25, na.rm = T), 1),
        q75 = round0(quantile(value, probs = 0.75, na.rm = T), 1),
        min = round0(min(value, na.rm = T), 1),
        max = round0(max(value, na.rm = T), 1),
        mis = sum(is.na(value)),
        p = round0(mis/N*100, 1)
      ) %>%
      mutate(
        N = paste0("N = ", N),
        `Mean (SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", q25, "-", q75, ")"),
        `Min - Max` = paste0(min, " - ", max),
        Missing = paste0(mis," (",p,"%)")
      ) %>%
      select(-c(m,sd,med,q25,q75,min,max,mis,p)) %>%
      gather(key = Scoring, value = value, -variable) %>%
      mutate(
        variable = if_else(Scoring == "N", "N", variable)
      )
  }

  new$variable <- as.factor(new$variable) %>%
    relevel("N")

  new <- arrange(new, variable)

  if(dims > 1){
    new <- new[-c(1:dims-1),]
  }

  return(new)

}
