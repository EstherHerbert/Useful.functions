#' Produce a dataframe to summarise ticked variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              ticked variables.
#'
#' @param df Data Frame
#' @param group Optional variable that defines the grouping
#' @param variables Variables to be summarised
#' @param total Logical indicating wether a total column should be created
#'
#' @return A tibble data frame summarising the data
#'
#' @examples
#'   df <- data.frame(pet_cat = sample(c("Yes", NA), size = 100, replace = T),
#'                    pet_dog = sample(c("Yes", NA), size = 100, replace = T),
#'                    pet_pig = sample(c("Yes", NA), size = 100, replace = T),
#'                    group = sample(c("A", "B", "C"), size = 100, replace = T))
#'
#'   ticked_table(df, group = group,
#'                variables = grep("pet_", colnames(df), value = T))
#'
#'   ticked_table(df, variables = grep("pet_", colnames(df), value = T))
#'
#' @export
ticked_table <- function(df        = .,
                         group     = .,
                         variables = c(),
                         total     = TRUE,
                         ...){
  require(tidyverse)

  variables <- enquo(variables)

  if(!missing(group)){
    group <- enquo(group)
  } else {
    total <- FALSE
  }

  # duplicating data to obtail totals
  if(total){
    df <- df %>%
      stata_expand(n = 1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1, "All", as.character(!!group))
      ) %>%
      select(-Duplicate)
  }

  if(!missing(group)){
    new <- df %>%
      select(!!group, !!variables) %>%
      gather(Scoring, tick, -!!group)

    dims <- length(unique(new$Scoring))

    new <- new %>%
      group_by(!!group, Scoring) %>%
      summarise(
        N = n(),
        n = sum(!is.na(tick)),
        p = round0(n/N*100, 1),
        np = paste0(n," (",p,"%)"),
        N = paste0("N = ", N)
      )%>%
      select(-c(n,p)) %>%
      gather(variable, value, -!!group, -Scoring) %>%
      spread(!!group, value) %>%
      mutate(
        Scoring = if_else(variable == "N", "N", Scoring)
      ) %>%
      select(-variable)
  } else {
    new <- df %>%
      select(!!variables) %>%
      gather(Scoring, tick)

    dims <- length(unique(new$Scoring))

    new <- new %>%
      group_by(Scoring) %>%
      summarise(
        N = n(),
        n = sum(!is.na(tick)),
        p = round0(n/N*100, 1),
        np = paste0(n," (",p,"%)"),
        N = paste0("N = ", N)
      )%>%
      select(-c(n,p)) %>%
      gather(variable, value, -Scoring) %>%
      mutate(
        Scoring = if_else(variable == "N", "N", Scoring)
      ) %>%
      select(-variable)
  }

  new$Scoring <- as.factor(new$Scoring) %>%
    relevel("N")

  new <- arrange(new, Scoring) %>%
    .[-c(1:dims-1),]

  return(new)

}
