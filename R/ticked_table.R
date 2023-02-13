#' Produce a dataframe to summarise ticked variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              ticked variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param sep Optional separator between columns for splitting variable into
#'            variable and scoring. See ?tidyr::separate for more information.
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

  variables <- rlang::quos(...)
  if (!missing(group)) {
    group <- rlang::enquo(group)
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
      dplyr::select(!!group, !!!variables) %>%
      tidyr::gather(scoring, value, -!!group) %>%
      dplyr::mutate(
        value = dplyr::case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      dplyr::group_by(!!group, scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = qwraps2::n_perc(value, digits = 1, show_denom = "never", na_rm = T,
                    markup = "markdown")
      ) %>%
      tidyr::gather(stat, value, -!!group, -scoring) %>%
      tidyr::spread(!!group, value) %>%
      dplyr::mutate(
        scoring = dplyr::if_else(stat == "N", "N", scoring)
      ) %>%
      dplyr::select(-stat) %>%
      .[!duplicated(.),]
  } else {
    new <- df %>%
      dplyr::select(!!!variables) %>%
      tidyr::gather(scoring, value) %>%
      dplyr::mutate(
        value = dplyr::case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      dplyr::group_by(scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = qwraps2::n_perc(value, digits = 1, show_denom = "never", na_rm = T,
                    markup = "markdown")
      ) %>%
      tidyr::gather(stat, value, -scoring) %>%
      dplyr::mutate(
        scoring = dplyr::if_else(stat == "N", "N", scoring)
      ) %>%
      dplyr::select(-stat) %>%
      .[!duplicated(.),]
  }

  order <- sapply(variables, FUN = rlang::quo_name)

  new <- new %>%
    dplyr::mutate(
      scoring = readr::parse_factor(scoring, c("N", order))
    ) %>%
    dplyr::arrange(scoring)%>%
    dplyr::mutate(
      scoring = dplyr::if_else(scoring == "N", NA_character_,
                         as.character(scoring))
    )

  if(!missing(sep)){
    new <- new %>%
      tidyr::separate(scoring, into = c("variable", "scoring"),
               sep = sep, fill = "right")
  }

  return(new)

}
