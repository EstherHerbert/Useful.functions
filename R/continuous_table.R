#' Produce a dataframe to summaries continuous variables
#'
#' @description Takes a dataframe and produces grouped summaries such as mean
#'              and standard deviation for continuous variables.
#'
#' @param df Data frame
#' @param group Variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total Logical indicating wether a total column should be created
#' @param set Optional variable that defines extra grouping. This is grouping
#'            obove the grouping given in \code{group}
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
                              group     = group,
                              variables = c(),
                              total     = TRUE,
                              set       = .,
                              ...){
  require(tidyverse)
  group <- enquo(group)
  variables <- enquo(variables)
  if(!missing(set)){
    set <- enquo(set)
  }

  # duplicating data to obtail totals
  if(total){
    df <- df %>%
      stata_expand(n = 1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1, "All", as.character(!!group))
      )
  }

  if(missing(set)){ # if no higher level setting given
    new <- df %>%
      select(!!group, !!variables) %>%
      gather(key = variable, value = value, -!!group) %>%
      group_by(!!group, variable) %>%
      summarise(
        n = sum(!is.na(value)),
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        q25 = round0(quantile(value, probs = 0.25, na.rm = T), 1),
        q75 = round0(quantile(value, probs = 0.75, na.rm = T), 1),
        min = round0(min(value, na.rm = T), 1),
        max = round0(max(value, na.rm = T), 1)
      ) %>%
      mutate(
        n = paste0("n = ", n),
        `Mean (SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", q25, "-", q75, ")"),
        `Min - Max` = paste0(min, " - ", max)
      ) %>%
      select(-c(m,sd,med,q25,q75,min,max)) %>%
      gather(key = Scoring, value = value, -!!group, -variable) %>%
      spread(key = !!group, value = value)
  } else { # if higher level setting given
    new <- df %>%
      select(!!set, !!group, !!variables) %>%
      gather(key = variable, value = value, -!!set, -!!group) %>%
      group_by(!!set, !!group, variable) %>%
      summarise(
        n = sum(!is.na(value)),
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        q25 = round0(quantile(value, probs = 0.25, na.rm = T), 1),
        q75 = round0(quantile(value, probs = 0.75, na.rm = T), 1),
        min = round0(min(value, na.rm = T), 1),
        max = round0(max(value, na.rm = T), 1)
      ) %>%
      mutate(
        n = paste0("n = ", n),
        `Mean (SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", q25, "-", q75, ")"),
        `Min - Max` = paste0(min, " - ", max)
      ) %>%
      select(-c(m,sd,med,q25,q75,min,max)) %>%
      gather(key = Scoring, value = value, -!!set, -!!group, -variable) %>%
      unite(temp, !!set, !!group) %>%
      spread(key = temp, value = value)
  }

  # make sure
  new$Scoring <- factor(new$Scoring,
                        levels = levels(as.factor(new$Scoring))[c(4,1:3)])
  new <- arrange(new, variable, Scoring)

  return(new)

}

