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
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether the second header row should be converted
#'   into a row of denominators. Helpful for when `ticked_table()` forms part of
#'   a larger table. Default is `FALSE`
#' @param boolean Logical indicating whether the variables are already coded as
#'   TRUE/FALSE or 0/1. Default is `FALSE`
#' @param condense `r lifecycle::badge("deprecated")` `condense = TRUE` is
#'   deprecated, use [condense()] instead.
#'
#' @return A tibble data frame summarising the data
#'
#' @examples
#'   ticked_table(outcome, pet_cat, pet_dog, group = group, sep = "_")
#'
#'   ticked_table(outcome, pet_fish, pet_dog)
#'
#'   ticked_table(outcome, pet_fish, pet_dog, sep = "_", n = TRUE)
#'
#' @export
ticked_table <- function (df = .,
                          ...,
                          group,
                          sep,
                          digits = 1,
                          total = TRUE,
                          n = FALSE,
                          boolean = FALSE,
                          condense = FALSE){

  if (isTRUE(condense)) {
    lifecycle::deprecate_warn("0.4", "ticked_table(condense)", "condense()")
  }

  if (missing(group)) {
    total <- FALSE
  }

  if(total){
    df <- df %>%
      totals({{group}})
  }

  if (!boolean) {
    df <- df %>%
      dplyr::mutate(
        dplyr::across(c(...), function(x) {
          dplyr::case_when(
            x == "Ticked" ~ 1,
            TRUE ~ 0
          )
        })
      )
  }

  if(!missing(group)){
    new <- df %>%
      dplyr::select({{group}}, ...) %>%
      tidyr::pivot_longer(-{{group}}, names_to = "scoring",
                          values_to = "value") %>%
      dplyr::group_by({{group}}, scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = np(value, digits = digits, na_rm = F)
      ) %>%
      tidyr::pivot_longer(-c({{group}}, scoring), names_to = "stat",
                          values_to = "value") %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        scoring = dplyr::if_else(stat == "N", "N", scoring)
      ) %>%
      dplyr::select(-stat) %>%
      .[!duplicated(.),]
  } else {
    new <- df %>%
      dplyr::select(...) %>%
      tidyr::pivot_longer(dplyr::everything(), names_to = "scoring",
                          values_to = "value") %>%
      dplyr::group_by(scoring) %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = np(value, digits = digits, na_rm = F)
      ) %>%
      tidyr::pivot_longer(-scoring, names_to = "stat", values_to = "value") %>%
      dplyr::mutate(
        scoring = dplyr::if_else(stat == "N", "N", scoring)
      ) %>%
      dplyr::select(-stat) %>%
      .[!duplicated(.),]
  }

  order <- dplyr::select(df, ...) %>%
    colnames()

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

  if (total) {
    new <- dplyr::relocate(new, Total, .after = dplyr::last_col())
  }

  if (n) {
    if (!missing(sep)) {
      new <- new %>%
        tidyr::fill(variable, .direction = "up") %>%
        dplyr::mutate(
          scoring = tidyr::replace_na(scoring, "n"),
          dplyr::across(-c(variable, scoring),
                        ~ifelse(scoring == "n", readr::parse_number(.x), .x))
        )
    } else {
      new <- new %>%
        dplyr::mutate(
          scoring = tidyr::replace_na(scoring, "n"),
          dplyr::across(-scoring, ~ifelse(scoring == "n",
                                          readr::parse_number(.x), .x))
        )
    }
  }

  new

}
