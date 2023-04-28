#' Produce a data frame to summaries continuous variables
#'
#' @description Takes a data frame and produces grouped or un-grouped summaries
#'              such as mean and standard deviation for continuous variables.
#'
#' @param df Data frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param time Optional variable for repeated measures
#'             (currently must me used with group)
#' @param total Logical indicating whether a total column should be created
#' @param digits Number of digits to the right of the decimal point
#'
#' @examples
#'     continuous_table(df = iris, Petal.Length, Petal.Width, group = Species)
#'     continuous_table(df = iris, Sepal.Length, Sepal.Width, group = Species,
#'                      total = FALSE)
#'     continuous_table(df = iris, Petal.Length, Sepal.Length, digits = 1)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
continuous_table <- function(df, ..., group, time, total = TRUE, digits = 2) {

  variable <- value <- scoring <- n <- `Mean (SD)` <-
    `Median (IQR)` <- `Min, Max` <- NULL

  if(!missing(time) & missing(group)) {
    stop("Time can currenlty only be used with a group variable")
  }

  if (missing(group)) {
    total <- FALSE
  }

  if (total) {
    df <- df %>%
      totals({{group}})
  }

  if (!missing(group) & missing(time)) {
    new <- df %>%
      dplyr::select({{group}}, ...) %>%
      tidyr::pivot_longer(-{{group}}, names_to = "variable",
                          values_to = "value") %>%
      dplyr::group_by({{group}}, variable) %>%
      dplyr::summarise(
        N = dplyr::n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = qwraps2::mean_sd(value, na_rm = T, denote_sd = "paren",
                                       digits = digits, show_n = "never"),
        `Median (IQR)` = qwraps2::median_iqr(value, na_rm = T, digits = digits,
                                             show_n = "never"),
        `Min, Max` = paste0(
          min = round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      dplyr::mutate(
        dplyr::across(`Mean (SD)`:`Min, Max`, ~ifelse(n == 0, "-", .x)),
        `Mean (SD)` = ifelse(n == 1,
                             stringr::str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(
          n == 1, stringr::str_replace(`Median (IQR)`, "0.00", " - "),
          `Median (IQR)`
        ),
        `Min, Max` = ifelse(n == 1, stringr::str_remove(`Min, Max`, ",.*"),
                            `Min, Max`)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(cols = c(-{{group}}, -variable), names_to = "scoring",
                          values_to = "value",
                          values_transform = list(value = as.character)) %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        variable = dplyr::if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  } else if (missing(group) & missing(time)) {
    new <- df %>%
      dplyr::select(...) %>%
      tidyr::pivot_longer(dplyr::everything(), names_to = "variable",
                          values_to = "value") %>%
      dplyr::group_by(variable) %>%
      dplyr::summarise(
        N = dplyr::n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = qwraps2::mean_sd(value, na_rm = T, denote_sd = "paren",
                                       digits = digits, show_n = "never"),
        `Median (IQR)` = qwraps2::median_iqr(value, na_rm = T, digits = digits,
                                             show_n = "never"),
        `Min, Max` = paste0(
          round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      dplyr::mutate(
        dplyr::across(`Mean (SD)`:`Min, Max`, ~ifelse(n == 0, "-", .x)),
        `Mean (SD)` = ifelse(n == 1,
                             stringr::str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(
          n == 1, stringr::str_replace(`Median (IQR)`, "0.00", " - "),
          `Median (IQR)`
        ),
        `Min, Max` = ifelse(n == 1, stringr::str_remove(`Min, Max`, ",.*"),
                            `Min, Max`)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(-variable, names_to = "scoring", values_to = "value",
                          values_transform = list(value = as.character)) %>%
      dplyr::mutate(
        variable = dplyr::if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  } else {
    new <- df %>%
      dplyr::select({{group}}, {{time}}, ...) %>%
      tidyr::pivot_longer(cols = c(-{{group}}, -{{time}}),
                          names_to = "variable", values_to = "value") %>%
      dplyr::group_by({{group}}, variable, {{time}}) %>%
      dplyr::summarise(
        N = dplyr::n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = qwraps2::mean_sd(value, na_rm = T, denote_sd = "paren",
                                       digits = digits, show_n = "never"),
        `Median (IQR)` = qwraps2::median_iqr(value, na_rm = T, digits = digits,
                                             show_n = "never"),
        `Min, Max` = paste0(
          min = round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      dplyr::mutate(
        dplyr::across(`Mean (SD)`:`Min, Max`, ~ifelse(n == 0, "-", .x)),
        `Mean (SD)` = ifelse(n == 1,
                             stringr::str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(
          n == 1, stringr::str_replace(`Median (IQR)`, "0.00", " - "),
          `Median (IQR)`
        ),
        `Min, Max` = ifelse(n == 1, stringr::str_remove(`Min, Max`, ",.*"),
                            `Min, Max`)
      ) %>%
      dplyr::ungroup() %>%
      tidyr::pivot_longer(cols = c(-{{group}}, -{{time}}, -variable),
                          names_to = "scoring", values_to = "value",
                          values_transform = list(value = as.character)) %>%
      tidyr::pivot_wider(names_from = {{group}}, values_from = value) %>%
      dplyr::mutate(
        dplyr::across(c({{time}}, variable),
                      ~dplyr::if_else(scoring == "N", "N", as.character(.x)))
      ) %>%
      .[!duplicated(.), ]
  }

  order <- dplyr::select(df, ...) %>%
    colnames()

  if(!missing(time)){

    order2 <- df %>%
      dplyr::mutate({{time}} := as.factor({{time}})) %>%
      dplyr::select({{time}}) %>%
      purrr::map(levels) %>%
      .[[1]]

    new <- new %>%
      dplyr::mutate(
        {{time}} := readr::parse_factor({{time}}, c("N", order2)),
        variable = readr::parse_factor(variable, c("N", order)),
        scoring = as.factor(scoring),
        scoring = stats::relevel(scoring, "n")
      ) %>%
      dplyr::arrange(variable, {{time}}, scoring) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -scoring, -{{time}}),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x)),
        dplyr::across(c(variable, scoring, {{time}}),
                      ~dplyr::if_else(variable == "N", NA_character_,
                                      as.character(.x)))
      )

  } else {
    new <- new %>%
      dplyr::mutate(
        variable = readr::parse_factor(variable, c("N", order)),
        scoring = as.factor(scoring),
        scoring = stats::relevel(scoring, "n")
      ) %>%
      dplyr::arrange(variable, scoring) %>%
      dplyr::mutate(
        dplyr::across(c(-variable, -scoring),
                      ~dplyr::if_else(variable == "N", paste("N =", .x), .x)),
        dplyr::across(c(variable, scoring),
                      ~dplyr::if_else(variable == "N", NA_character_,
                                      as.character(.x)))
      )
  }

  return(new)
}
