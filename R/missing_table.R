#' Produce a dataframe to summarise data completeness for variables
#'
#' @description Takes a dataframe and calculates the proportions present/missing
#'              for given variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param format Should the propotion missing or present be given?
#' @param total Logical indicating whether a total column should be created
#'
#' @return A tibble data frame summarising the data completeness
#'
#' @export
missing_table <- function (df = .,
                           ...,
                           group = .,
                           format = "Missing",
                           total = TRUE){

  variables <- rlang::quos(...)

  if (!missing(group)) {
    group <- rlang::enquo(group)
  }
  else {
    total <- FALSE
  }

  if (total) {
    df <- df %>% totals(!!group)
  }

  if (!missing(group)) {
    new <- df %>%
      dplyr::select(!!group, !!!variables) %>%
      tidyr::pivot_longer(-!!group, names_to = "variable",
                          values_to = "value") %>%
      dplyr::count(!!group, variable, is.na(value)) %>%
      tidyr::complete(!!group, variable, `is.na(value)`, fill = list(n = 0)) %>%
      dplyr::group_by(!!group, variable) %>%
      dplyr::mutate(
        N = sum(n),
        n = paste0(n, " (", scales::percent(n/N, accuracy = 0.1), ")"),
        Missing = dplyr::if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      dplyr::select(-`is.na(value)`) %>%
      dplyr::ungroup %>%
      tidyr::pivot_longer(c(n, N), names_to = "stat", values_to = "value") %>%
      tidyr::pivot_wider(names_from = !!group, values_from = value) %>%
      dplyr::mutate(
        dplyr::across(c(variable, Missing),
                      ~dplyr::if_else(stat == "N", "N", .x))
      ) %>%
      .[!duplicated(.),] %>%
      dplyr::select(-stat) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -Missing),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x))
      )
  }
  else {
    new <- df %>%
      dplyr::select(!!!variables) %>%
      tidyr::pivot_longer(dplyr::everything(), names_to = "variable",
                          values_to = "value") %>%
      dplyr::count(variable, is.na(value)) %>%
      tidyr::complete(variable, `is.na(value)`, fill = list(n = 0)) %>%
      dplyr::group_by(variable) %>%
      dplyr::mutate(
        N = sum(n),
        n = paste0(n, " (", scales::percent(n/N, accuracy = 0.1), ")"),
        Missing = dplyr::if_else(`is.na(value)`, "Missing", "Present")
      ) %>%
      dplyr::select(-`is.na(value)`) %>%
      dplyr::ungroup %>%
      tidyr::pivot_longer(c(n, N), names_to = "stat", values_to = "value") %>%
      dplyr::mutate(
        dplyr::across(c(variable, Missing),
                      ~dplyr::if_else(stat == "N", "N", .x))
      ) %>%
      .[!duplicated(.),] %>%
      dplyr::select(-stat) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -Missing),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x))
      )
  }

  order <- sapply(variables, FUN = rlang::quo_name)

  new <- new %>%
    dplyr::mutate(
      variable = readr::parse_factor(variable, c("N", order))
    ) %>%
    dplyr::arrange(variable) %>%
    dplyr::filter(Missing %in% c(format, "N")) %>%
    dplyr::select(-Missing)

  return(new)
}
