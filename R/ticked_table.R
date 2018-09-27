#' Produce a dataframe to summarise ticked variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              ticked variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param sep Optional separator between columns for splitting variable into
#'            variable and scoring. See ?separate for more information.
#' @param total Logical indicating wether a total column should be created
#'
#' @return A tibble data frame summarising the data
#'
#' @examples
#'   df <- data.frame(pet_cat = sample(c("Ticked", ""), size = 100, replace = T),
#'                    pet_dog = sample(c("Ticked", ""), size = 100, replace = T),
#'                    pet_pig = sample(c("Ticked", ""), size = 100, replace = T),
#'                    group = sample(c("A", "B", "C"), size = 100, replace = T))
#'
#'   ticked_table(df, pet_cat, pet_dog, group = group, sep = "_")
#'
#'   ticked_table(df, pet_pig, pet_dog)
#'
#' @export
ticked_table <- function (df = .,
                          ...,
                          group = .,
                          sep = .,
                          total = TRUE){

  require(tidyverse)
  require(qwraps2)
  require(magrittr)

  variables <- quos(...)
  if (!missing(group)) {
    group <- enquo(group)
  }
  else {
    total <- FALSE
  }

  if(total){
    df <- df %>%
      totals(!!group)
  }

  if(!missing(group)){
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(scoring, value, -!!group) %>%
      mutate(
        value = case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      group_by(!!group, scoring) %>%
      summarise(
        N = paste("N =", n()),
        np = n_perc(value, digits = 1, show_denom = "never", na_rm = T)
      ) %>%
      gather(stat, value, -!!group, -scoring) %>%
      spread(!!group, value) %>%
      mutate(
        scoring = if_else(stat == "N", "N", scoring)
      ) %>%
      select(-stat) %>%
      .[!duplicated(.),]
  } else {
    new <- df %>%
      select(!!!variables) %>%
      gather(scoring, value) %>%
      mutate(
        value = case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      group_by(scoring) %>%
      summarise(
        N = paste("N =", n()),
        np = n_perc(value, digits = 1, show_denom = "never", na_rm = T)
      ) %>%
      gather(stat, value, -scoring) %>%
      mutate(
        scoring = if_else(stat == "N", "N", scoring)
      ) %>%
      select(-stat) %>%
      .[!duplicated(.),]
  }

  order <- sapply(variables, FUN = quo_name)

  new %<>%
    mutate(
      scoring = parse_factor(scoring, c("N", order))
    ) %>%
    arrange(scoring)%>%
    mutate(
      scoring = if_else(scoring == "N", NA_character_,
                         as.character(scoring))
    )

  if(!missing(sep)){
    new %<>%
      separate(scoring, into = c("variable", "scoring"),
               sep = sep, fill = "right")
  }

  return(new)

}
