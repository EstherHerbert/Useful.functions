#' Produce a data frame to summarise adverse event data.
#'
#' @description Takes a data frame of adverse events and produces the number of
#'              events and number and percentage of individuals with an adverse
#'              event.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Variable that defines the grouping
#' @param ID Variable that defines the individual identifier (e.g. screening
#'           number)
#' @param N a data frame with the group counts (typically produced using
#'          `dplyr::count`)
#' @param accuracy see details of `scales::percent`
#' @param total Logical indicating whether a total column should be created
#'
#' @export
ae_table <- function (df, ..., group, ID, N, accuracy = 0.1, total = FALSE) {

  variables <- rlang::quos(...)
  ID <- rlang::enquo(ID)

  if(!missing(group)) group <- rlang::enquo(group) else total <- FALSE

  if(total){
    df <- df %>%
      totals(!!group)
  }

  if(!missing(group)){
    new <- df %>%
      tidyr::pivot_longer(cols = c(!!!variables), names_to = "variable",
                          values_to = "scoring",
                          values_transform = list(scoring = as.character)) %>%
      dplyr::group_by(!!group, variable, scoring) %>%
      dplyr::summarise(
        events = dplyr::n(),
        dplyr::across(!!ID, .fns = dplyr::n_distinct, .names = "individuals"),
        .groups = "drop"
      ) %>%
      tidyr::complete(!!group, tidyr::nesting(variable, scoring),
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
      tidyr::unite(group, !!group, stat) %>%
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
      tidyr::pivot_longer(cols = c(!!!variables), names_to = "variable",
                          values_to = "scoring",
                          values_transform = list(scoring = as.character)) %>%
      dplyr::group_by(variable, scoring) %>%
      dplyr::summarise(
        events = dplyr::n(),
        dplyr::across(!!ID, dplyr::n_distinct, .names = "individuals"),
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

  order <- sapply(variables, FUN = dplyr::quo_name)

  order2 <- df %>%
    dplyr::select(!!!variables) %>%
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

  return(new)

}
