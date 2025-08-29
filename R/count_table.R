#' Produce a data frame to summarise counts of events
#'
#' @description Takes a data frame of events and produces the number of events
#'   and number and percentage of individuals with at least one event.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param ID Variable that defines the individual identifier (e.g. screening
#'           number)
#' @param N a data frame with the group counts (typically produced using
#'          [dplyr::count()])
#' @param group optional, variable that defines the grouping
#' @param accuracy see details of [scales::percent()]
#' @param total Logical indicating whether a total column should be created
#'
#' @examples
#'   N <- dplyr::count(outcome, group, name = "N")
#'   count_table(outcome_aes, serious, related, group = group, N = N, ID = screening)
#'
#' @export
count_table <- function (df, ..., ID, N, group, accuracy = 0.1, total = FALSE) {

  if (missing(group)) {
    total <- FALSE
  }

  if(total){
    df <- df %>%
      totals({{group}})
  }

  if(!missing(group)){
    new <- df %>%
      tidyr::pivot_longer(cols = c(...), names_to = "variable",
                          values_to = "scoring",
                          values_transform = list(scoring = as.character)) %>%
      dplyr::group_by({{group}}, variable, scoring) %>%
      dplyr::summarise(
        events = dplyr::n(),
        dplyr::across({{ID}}, .fns = dplyr::n_distinct, .names = "individuals"),
        .groups = "drop"
      ) %>%
      tidyr::complete({{group}}, tidyr::nesting(variable, scoring),
                      fill = list(events = 0, individuals = 0)
      ) %>%
      dplyr::left_join(N) %>%
      dplyr::mutate(
        individuals = paste0(individuals, " (",
                             scales::percent(individuals/N,
                                             accuracy = accuracy), ")"),
        N = paste("N =", N)
      ) %>%
      tidyr::pivot_longer(events:individuals, names_to = "stat",
                          values_to = "value",
                          values_transform = list(value = as.character)) %>%
      tidyr::unite(group, {{group}}, stat) %>%
      tidyr::pivot_longer(cols = c(N, value), names_to = "stat",
                          values_to = "value") %>%
      tidyr::pivot_wider(names_from = group, values_from = value) %>%
      dplyr::mutate(
        dplyr::across(c(variable, scoring),
                      ~dplyr::if_else(stat == "N", "N", .x))
      ) %>%
      {.[!duplicated(.), ]} %>%
      dplyr::select(-stat)
  } else {
    new <- df %>%
      tidyr::pivot_longer(cols = c(...), names_to = "variable",
                          values_to = "scoring",
                          values_transform = list(scoring = as.character)) %>%
      dplyr::group_by(variable, scoring) %>%
      dplyr::summarise(
        events = dplyr::n(),
        dplyr::across({{ID}}, dplyr::n_distinct, .names = "individuals"),
        .groups = "drop"
      ) %>%
      dplyr::bind_cols(N) %>%
      dplyr::mutate(
        individuals = paste0(individuals, " (",
                             scales::percent(individuals/N,
                                             accuracy = accuracy), ")"),
        N = paste("N =", N)
      ) %>%
      tidyr::pivot_longer(events:individuals, names_to = "group",
                          values_to = "value",
                          values_transform = list(value = as.character)) %>%
      tidyr::pivot_longer(cols = c(N, value), names_to = "stat",
                          values_to = "value") %>%
      tidyr::pivot_wider(names_from = group, values_from = value) %>%
      dplyr::mutate(
        dplyr::across(c(variable, scoring),
                      ~dplyr::if_else(stat == "N", "N", .x))
      ) %>%
      {.[!duplicated(.), ]} %>%
      dplyr::select(-stat)
  }

  order <- dplyr::select(df, ...) %>%
    colnames()

  order2 <- df %>%
    dplyr::select(...) %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), as.factor)) %>%
    as.list() %>%
    purrr::map(~levels(.)) %>%
    unlist(.) %>%
    unname() %>%
    {.[!duplicated(.)]}

  suppressWarnings(
    new <- new %>%
      dplyr::mutate(
        variable = readr::parse_factor(variable, c("N", order)),
        scoring = readr::parse_factor(scoring, c("N", order2) %>%
                                        .[!duplicated(.)]) %>%
          forcats::fct_relevel("Other", after = Inf) %>%
          forcats::fct_relevel("Missing", after = Inf)
      ) %>%
      dplyr::arrange(variable, scoring) %>%
      dplyr::mutate(
        dplyr::across(c(variable, scoring),
                      ~dplyr::if_else(scoring == "N", NA_character_,
                                      as.character(.x)))
      )
  )

  if (total) {
    new <- dplyr::relocate(new, Total, .after = dplyr::last_col())
  }

  new

}

#' Produce a data frame to summarise count data.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function has been renamed to [count_table()] to reflect the fact that
#' it can be used to summarise counts of any events.
#'
#' @keywords internal
#'
#' @export
ae_table <- function (...) {

  lifecycle::deprecate_warn("0.4", "ae_table()", "count_table()")
  count_table(...)

}
