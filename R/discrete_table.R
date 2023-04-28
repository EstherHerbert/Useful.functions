#' Produce a dataframe to summarise discrete variables
#'
#' @description Takes a dataframe and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param time Optional variable for repeated measures
#'             (currenlty must me used with group)
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether percentages should be out of n
#'          (`n = TRUE`) or N (`n = FALSE`)
#' @param missing String determining what missing data will be called
#'                (if `n = TRUE`). Default is "Missing".
#' @param accuracy see details of `scales::percent`
#' @param condense should the `variable` and `scoring` columns in the output be
#'                 condensed to one column?
#'
#' @examples
#'     library(ggplot2) # for the data
#'     discrete_table(df = mpg, drv, group = manufacturer)
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
                           condense = FALSE) {

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
      dplyr::mutate(
        dplyr::across(c(...), ~forcats::fct_explicit_na(.x, na_level = missing))
      )
  }

  if (!missing(group) & missing(time)) {
    new <- df %>%
      dplyr::select({{group}}, ...) %>%
      tidyr::pivot_longer(-{{group}}, names_to = "variable",
                          values_to = "scoring") %>%
      dplyr::count({{group}}, variable, scoring) %>%
      tidyr::complete({{group}}, tidyr::nesting(variable, scoring),
                      fill = list(n = 0)) %>%
      dplyr::group_by({{group}}, variable) %>%
      dplyr::mutate(
        N = sum(n)
      ) %>%
      dplyr::filter(!is.na(scoring)) %>%
      dplyr::mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(-c({{group}}, variable, scoring), names_to = "stat",
                          values_to = "value",
                          values_transform = as.character) %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        variable = dplyr::if_else(stat == "N", stat, as.character(variable)),
        scoring = ifelse(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.),] %>%
      dplyr::select(-stat) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -scoring),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x))
      )
  } else if(missing(group) & missing(time)) {
    new <- df %>%
      dplyr::select(...) %>%
      tidyr::pivot_longer(dplyr::everything(), names_to = "variable",
                          values_to = "scoring") %>%
      dplyr::count(variable, scoring) %>%
      dplyr::group_by(variable) %>%
      dplyr::mutate(
        N = sum(n)
      ) %>%
      dplyr::filter(!is.na(scoring)) %>%
      dplyr::mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(-c(variable, scoring), names_to = "stat",
                          values_to = "value",
                          values_transform = as.character) %>%
      dplyr::mutate(
        variable = dplyr::if_else(stat == "N", stat, as.character(variable)),
        scoring = dplyr::if_else(stat %in% c("N", "n"), stat,
                                 as.character(scoring))
      ) %>%
      .[!duplicated(.), ] %>%
      dplyr::select(-stat) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -scoring),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x))
      )
  } else {
    new <- df %>%
      dplyr::select({{group}}, {{time}}, ...) %>%
      tidyr::pivot_longer(-c({{group}}, {{time}}), names_to = "variable",
                          values_to = "scoring") %>%
      dplyr::count({{group}}, {{time}}, variable, scoring) %>%
      tidyr::complete({{group}}, {{time}}, tidyr::nesting(variable, scoring),
                      fill = list(n = 0)) %>%
      dplyr::group_by({{group}}, {{time}}, variable) %>%
      dplyr::mutate(
        N = paste("N =", sum(n))
      ) %>%
      dplyr::filter(!is.na(scoring)) %>%
      dplyr::mutate(
        p = paste0(n, " (", scales::percent(n/sum(n), accuracy), ")"),
        n = sum(n)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(-c({{group}}, {{time}}, variable, scoring),
                          names_to = "stat", values_to = "value",
                          values_transform = as.character) %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        {{time}} := dplyr::if_else(stat == "N", stat, as.character({{time}})),
        variable = dplyr::if_else(stat == "N", stat, as.character(variable)),
        scoring = ifelse(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.),] %>%
      dplyr::select(-stat)
  }

  order <- dplyr::select(df, ...) %>%
    colnames()

  order2 <- df %>%
    dplyr::select(...) %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), as.factor)) %>%
    as.list() %>%
    purrr::map(~ levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    .[!duplicated(.)]

  if(!n){
    new <- new %>%
      dplyr::filter(scoring != "n" | is.na(scoring))
  }

  if(missing(time)){
    suppressWarnings(
      new <- new %>%
        dplyr::mutate(
          variable = readr::parse_factor(variable, c("N", order)),
          scoring = readr::parse_factor(scoring, c("N", "n", order2) %>%
                                          .[!duplicated(.)]) %>%
            forcats::fct_relevel("Other", after = Inf) %>%
            forcats::fct_relevel(missing, after = Inf)
        ) %>%
        dplyr::arrange(variable, scoring) %>%
        dplyr::mutate(
          dplyr::across(c(variable, scoring),
                        ~dplyr::if_else(scoring == "N", NA_character_,
                                        as.character(.x)))
        )
    )
  } else {
    order3 <- df %>%
      dplyr::mutate({{time}} := as.factor({{time}})) %>%
      dplyr::select({{time}}) %>%
      purrr::map(levels) %>%
      .[[1]]

    suppressWarnings(
      new <- new %>%
        dplyr::mutate(
          {{time}} := readr::parse_factor({{time}}, c("N", order3)),
          variable = readr::parse_factor(variable, c("N", order)),
          scoring = readr::parse_factor(scoring, c("N", "n", order2) %>%
                                          .[!duplicated(.)]) %>%
            forcats::fct_relevel("Other", after = Inf) %>%
            forcats::fct_relevel("Missing", after = Inf)
        ) %>%
        dplyr::arrange({{time}}, variable, scoring) %>%
        dplyr::mutate(
          dplyr::across(c({{time}}, variable, scoring),
                        ~dplyr::if_else(scoring == "N", NA_character_,
                                        as.character(.x)))
        )
    )
  }

  if(condense & !n){
    new <- new %>%
      mutate(variable = readr::parse_factor(variable)) %>%
      group_by(variable) %>%
      group_modify(~add_row(.x, .before = 1)) %>%
      mutate(
        variable = if_else(is.na(scoring), as.character(variable),
                           paste("  ", scoring))
      ) %>%
      select(-scoring) %>%
      .[-1,]
  } else if(condense) {
    new <- new %>%
      mutate(
        variable = if_else(scoring == "n", as.character(variable),
                           paste("  ", scoring))
      ) %>%
      select(-scoring)
  }

  return(new)

}
