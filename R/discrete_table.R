#' Produce a data frame to summarise discrete variables
#'
#' @description Takes a data frame and produces the number and percentage for
#'              discrete variables.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param time Optional variable for repeated measures (currently must me used
#'   with group)
#' @param total Logical indicating whether a total column should be created
#' @param n Logical indicating whether percentages should be out of n
#'          (`n = TRUE`) or N (`n = FALSE`)
#' @param missing String determining what missing data will be called
#'                (if `n = TRUE`). Default is "Missing".
#' @param accuracy see details of [scales::label_percent()]
#' @param drop.levels logical indicating whether unused levels in the factors
#'                    should be dropped. Default is `FALSE`.
#' @param condense `r lifecycle::badge("deprecated")` `condense = TRUE` is
#'   deprecated, use [condense()] instead.
#'
#' @examples
#'     discrete_table(outcome, sex, group = group)
#'     discrete_table(outcome, sex, drop.levels = TRUE)
#'     discrete_table(outcome, sex, group = group, time = event_name, n = TRUE,
#'                    total = FALSE)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
discrete_table <- function(df = .,
                           ...,
                           group,
                           time,
                           total = TRUE,
                           n = FALSE,
                           missing = "Missing",
                           accuracy = 0.1,
                           drop.levels = FALSE,
                           condense = FALSE) {

  rlang::check_dots_unnamed()

  variable = lapply(rlang::quos(...), rlang::as_name)

  if (rlang::is_empty(variable)) {
    stop("No variables were specified in `...`")
  }

  if (isTRUE(condense)) {
    lifecycle::deprecate_warn("0.4", "discrete_table(condense)",
                              "condense()")
  }

  if(!missing(time) & missing(group)) {
    stop("Time can currenlty only be used with a group variable")
  }

  if(!missing(missing) && n) {
    warning("You have specified a string for `missing` when `n = TRUE`, `missing` will be ignored")
  }

  if (!missing(total) && missing(group)) {
    warning(paste0("You have specified `total=", total, "` without `group`, `total` will be ignored"))
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
        dplyr::across(c(...), ~forcats::fct_na_value_to_level(.x, level = missing))
      )
  }

  if (drop.levels) {
    df <- df %>%
      dplyr::mutate(
        dplyr::across(c(...), ~forcats::fct_drop(.x))
      )
  }

  percent <- scales::label_percent(accuracy = accuracy)

  if (!missing(group) & missing(time)) {
    new <- purrr::map(
      variable, \(x) {
        dplyr::count(df, {{group}}, !!rlang::sym(x), .drop = F) %>%
          dplyr::group_by({{group}}) %>%
          dplyr::mutate(
            N = paste("N =", sum(n)),
          ) %>%
          dplyr::filter(!is.na(!!rlang::sym(x))) %>%
          dplyr::mutate(
            {{group}},
            variable = x,
            scoring = !!rlang::sym(x),
            N,
            p = paste0(n, " (", percent(n/sum(n)), ")"),
            n = sum(n),
            .keep = 'none'
          ) %>%
          dplyr::ungroup()
      }
    ) %>%
      dplyr::bind_rows() %>%
      tidyr::pivot_longer(-c({{group}}, variable, scoring), names_to = "stat",
                          values_to = "value",
                          values_transform = as.character) %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        variable = dplyr::if_else(stat == "N", stat, as.character(variable)),
        scoring = ifelse(stat %in% c("N", "n"), stat, as.character(scoring))
      ) %>%
      .[!duplicated(.),] %>%
      dplyr::select(-stat)
  } else if(missing(group) & missing(time)) {
    new <-  purrr::map(
      variable, \(x) {
        dplyr::count(df, !!rlang::sym(x), .drop = F) %>%
          dplyr::mutate(
            N = paste("N =", sum(n)),
          ) %>%
          dplyr::filter(!is.na(!!rlang::sym(x))) %>%
          dplyr::mutate(
            variable = x,
            scoring = !!rlang::sym(x),
            N,
            p = paste0(n, " (", percent(n/sum(n)), ")"),
            n = sum(n),
            .keep = 'none'
          ) %>%
          dplyr::ungroup()
      }
    ) %>%
      dplyr::bind_rows() %>%
      tidyr::pivot_longer(-c(variable, scoring), names_to = "stat",
                          values_to = "value",
                          values_transform = as.character) %>%
      dplyr::mutate(
        variable = dplyr::if_else(stat == "N", stat, as.character(variable)),
        scoring = dplyr::if_else(stat %in% c("N", "n"), stat,
                                 as.character(scoring))
      ) %>%
      .[!duplicated(.), ] %>%
      dplyr::select(-stat)
  } else {
    new <-  purrr::map(
      variable, \(x) {
        dplyr::count(df, {{time}}, {{group}}, !!rlang::sym(x), .drop = F) %>%
          dplyr::group_by({{time}}, {{group}}) %>%
          dplyr::mutate(
            N = paste("N =", sum(n)),
          ) %>%
          dplyr::filter(!is.na(!!rlang::sym(x))) %>%
          dplyr::mutate(
            {{time}}, {{group}},
            variable = x,
            scoring = !!rlang::sym(x),
            N,
            p = paste0(n, " (", percent(n/sum(n)), ")"),
            n = sum(n),
            .keep = 'none'
          ) %>%
          dplyr::ungroup()
      }
    ) %>%
      dplyr::bind_rows() %>%
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

  if(!n){
    new <- new %>%
      dplyr::filter(scoring != "n" | is.na(scoring))
  }

  if(missing(time)){
      new <- new %>%
        dplyr::mutate(
          dplyr::across(c(variable, scoring),
                        ~dplyr::if_else(scoring == "N", NA_character_,
                                        as.character(.x)))
        ) %>%
        dplyr::arrange(!is.na(variable))
  } else {
    order3 <- df %>%
      dplyr::mutate({{time}} := as.factor({{time}})) %>%
      dplyr::select({{time}}) %>%
      purrr::map(levels) %>%
      .[[1]]

      new <- new %>%
        dplyr::mutate(
          {{time}} := readr::parse_factor({{time}}, c("N", order3)),
        ) %>%
        dplyr::arrange({{time}}) %>%
        dplyr::mutate(
          dplyr::across(c({{time}}, variable, scoring),
                        ~dplyr::if_else(scoring == "N", NA_character_,
                                        as.character(.x)))
        )
  }

  if(condense & !n){
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

    if(!missing(time)) {
      new <- dplyr::relocate(new, {{time}}, .before = variable)
    }
  } else if(condense) {
    new <- new %>%
      dplyr::mutate(
        variable = dplyr::if_else(scoring == "n", as.character(variable),
                           paste("  ", scoring))
      ) %>%
      dplyr::select(-scoring)
  }

  return(new)

}
