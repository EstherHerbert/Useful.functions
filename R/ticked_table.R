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
#' @param digits Number of digits to the right of the decimal point
#' @param condense `r lifecycle::badge("deprecated")` `condense = TRUE` is
#'   deprecated, use [condense()] instead.
#' @param total Logical indicating whether a total column should be created
#'
#' @return A tibble data frame summarising the data
#'
#' @examples
#' df <- data.frame(
#'          pet_cat = sample(c("Ticked", ""), size = 100, replace = TRUE),
#'          pet_dog = sample(c("Ticked", ""), size = 100, replace = TRUE),
#'          pet_pig = sample(c("Ticked", ""), size = 100, replace = TRUE),
#'          group = sample(c("A", "B", "C"), size = 100, replace = TRUE)
#'  )
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
                          digits = 1,
                          condense = FALSE,
                          total = TRUE){

  if (isTRUE(condense)) {
    lifecycle::deprecate_warn("0.4", "ticked_table(condense)", "condense()")
  }

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
      tidyr::pivot_longer(-!!group, names_to = "scoring",
                          values_to = "value") %>%
      dplyr::mutate(
        value = dplyr::case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      dplyr::group_by(!!group, scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = qwraps2::n_perc(value, digits = digits, show_denom = "never", na_rm = T,
                             markup = "markdown")
      ) %>%
      tidyr::pivot_longer(-c(!!group, scoring), names_to = "stat",
                          values_to = "value") %>%
      tidyr::pivot_wider(names_from = !!group, values_from = value) %>%
      dplyr::mutate(
        scoring = dplyr::if_else(stat == "N", "N", scoring)
      ) %>%
      dplyr::select(-stat) %>%
      .[!duplicated(.),]
  } else {
    new <- df %>%
      dplyr::select(!!!variables) %>%
      tidyr::pivot_longer(dplyr::everything(), names_to = "scoring",
                          values_to = "value") %>%
      dplyr::mutate(
        value = dplyr::case_when(
          value == "Ticked" ~ 1,
          TRUE ~ 0
        )
      ) %>%
      dplyr::group_by(scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = qwraps2::n_perc(value, digits = digits, show_denom = "never", na_rm = T,
                             markup = "markdown")
      ) %>%
      tidyr::pivot_longer(-scoring, names_to = "stat", values_to = "value") %>%
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

    if(condense){
      new <- new %>%
        dplyr::mutate(variable = readr::parse_factor(variable)) %>%
        dplyr::group_by(variable) %>%
        dplyr::group_modify(~dplyr::add_row(.x, .before = 1)) %>%
        dplyr::mutate(
          variable = dplyr::if_else(is.na(scoring), as.character(variable),
                             paste("  ", scoring))
        ) %>%
        dplyr::select(-scoring) %>%
        .[-1,]
    }
  }

  return(new)

}
