#' Produce a dataframe to summaries continuous variables
#'
#' @description Takes a dataframe and produces grouped or ungrouped summaries
#'              such as mean and standard deviation for continuous variables.
#'
#' @param df Data frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param total Logical indicating wether a total column should be created
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
continuous_table <- function(df = .,
                             ...,
                             group = .,
                             total = TRUE,
                             digits = 2) {

  require(tidyverse)
  require(qwraps2)

  formals(mean_sd)$show_n <- "never"
  formals(median_iqr)$show_n <- "never"

  variables <- quos(...)
  if (!missing(group)) {
    group <- enquo(group)
  } else {
    total <- FALSE
  }

  if (total) {
    df %<>%
      stata_expand(1) %>%
      mutate(
        !!quo_name(group) := if_else(Duplicate == 1,
          "Total",
          as.character(!!group)
        )
      )
  }

  if (!missing(group)) {
    new <- df %>%
      select(!!group, !!!variables) %>%
      gather(variable, value, -!!group) %>%
      group_by(!!group, variable) %>%
      summarise(
        N = n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = mean_sd(value, na_rm = T, denote_sd = "paren", digits = digits),
        `Median (IQR)` = median_iqr(value, na_rm = T, digits = digits),
        `Min, Max` = paste0(min = min(value, na.rm = T), ", ", max(value, na.rm = T))
      ) %>%
      mutate_at(
        vars(`Mean (SD)`:`Min, Max`),
        funs(ifelse(n == 0, "-", .))
      ) %>%
      mutate(
        `Mean (SD)` = ifelse(n == 1, str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(n == 1, str_replace(`Median (IQR)`, "0.00", " - "),
                                `Median (IQR)`),
        `Min, Max` = ifelse(n == 1, str_remove(`Min, Max`, ",.*"), `Min, Max`)
      ) %>%
      ungroup() %>%
      gather(scoring, value, -!!group, -variable) %>%
      spread(!!group, value) %>%
      mutate(
        variable = if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  } else {
    new <- df %>%
      select(!!!variables) %>%
      gather(variable, value) %>%
      group_by(variable) %>%
      summarise(
        N = n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = mean_sd(value, na_rm = T, denote_sd = "paren", digits = digits),
        `Median (IQR)` = median_iqr(value, na_rm = T, digits = digits),
        `Min, Max` = paste0(min(value, na.rm = T), ", ", max(value, na.rm = T))
      ) %>%
      mutate_at(
        vars(`Mean (SD)`:`Min, Max`),
        funs(ifelse(n == 0, "-", .))
      ) %>%
      mutate(
        `Mean (SD)` = ifelse(n == 1, str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(n == 1, str_replace(`Median (IQR)`, "0.00", " - "),
                                `Median (IQR)`),
        `Min, Max` = ifelse(n == 1, str_remove(`Min, Max`, ",.*"), `Min, Max`)
      ) %>%
      ungroup() %>%
      gather(scoring, value, -variable) %>%
      mutate(
        variable = if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  }

  order <- sapply(variables, FUN = quo_name)

  new %<>%
    mutate(
      variable = parse_factor(variable, c("N", order)),
      scoring = as.factor(scoring),
      scoring = relevel(scoring, "n")
    ) %>%
    arrange(variable, scoring) %>%
    mutate_at(
      vars(-variable, -scoring),
      funs(if_else(variable == "N", paste("N =", .), .))
    ) %>%
    mutate_at(
      vars(variable, scoring),
      funs(if_else(variable == "N", NA_character_, as.character(.)))
    )

  return(new)
}
