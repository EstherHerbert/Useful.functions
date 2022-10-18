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
continuous_table <- function(df = .,
                             ...,
                             group = .,
                             time = .,
                             total = TRUE,
                             digits = 2) {
  require(qwraps2)

  if(!missing(time) & missing(group)) {
    stop("Time can currenlty only be used with a group variable")
  }

  formals(mean_sd)$show_n <- "never"
  formals(median_iqr)$show_n <- "never"

  if (missing(group)) {
    total <- FALSE
  }

  if (total) {
    df <- df %>%
      totals({{group}})
  }

  if (!missing(group) & missing(time)) {
    new <- df %>%
      select({{group}}, ...) %>%
      pivot_longer(-{{group}}, names_to = "variable", values_to = "value") %>%
      group_by({{group}}, variable) %>%
      summarise(
        N = n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = mean_sd(value, na_rm = T, denote_sd = "paren",
                              digits = digits),
        `Median (IQR)` = median_iqr(value, na_rm = T, digits = digits),
        `Min, Max` = paste0(
          min = round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      mutate_at(
        vars(`Mean (SD)`:`Min, Max`),
        ~ifelse(n == 0, "-", .)
      ) %>%
      mutate(
        `Mean (SD)` = ifelse(n == 1, str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(n == 1, str_replace(`Median (IQR)`, "0.00",
                                                    " - "),
                                `Median (IQR)`),
        `Min, Max` = ifelse(n == 1, str_remove(`Min, Max`, ",.*"), `Min, Max`)
      ) %>%
      ungroup() %>%
      pivot_longer(cols = c(-{{group}}, -variable), names_to = "scoring",
                   values_to = "value",
                   values_transform = list(value = as.character)) %>%
      pivot_wider(names_from = {{group}}, values_from = value) %>%
      mutate(
        variable = if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  } else if (missing(group) & missing(time)) {
    new <- df %>%
      select(...) %>%
      pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
      group_by(variable) %>%
      summarise(
        N = n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = mean_sd(value, na_rm = T, denote_sd = "paren",
                              digits = digits),
        `Median (IQR)` = median_iqr(value, na_rm = T, digits = digits),
        `Min, Max` = paste0(
          round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      mutate_at(
        vars(`Mean (SD)`:`Min, Max`),
        ~ifelse(n == 0, "-", .)
      ) %>%
      mutate(
        `Mean (SD)` = ifelse(n == 1, str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(n == 1,
                                str_replace(`Median (IQR)`, "0.00", " - "),
                                `Median (IQR)`),
        `Min, Max` = ifelse(n == 1, str_remove(`Min, Max`, ",.*"), `Min, Max`)
      ) %>%
      ungroup() %>%
      pivot_longer(-variable, names_to = "scoring", values_to = "value",
                   values_transform = list(value = as.character)) %>%
      mutate(
        variable = if_else(scoring == "N", "N", as.character(variable))
      ) %>%
      .[!duplicated(.), ]
  } else {
    new <- df %>%
      select({{group}}, {{time}}, ...) %>%
      pivot_longer(cols = c(-{{group}}, -{{time}}), names_to = "variable",
                   values_to = "value") %>%
      group_by({{group}}, variable, {{time}}) %>%
      summarise(
        N = n(),
        n = sum(!is.na(value)),
        `Mean (SD)` = mean_sd(value, na_rm = T, denote_sd = "paren",
                              digits = digits),
        `Median (IQR)` = median_iqr(value, na_rm = T, digits = digits),
        `Min, Max` = paste0(
          min = round(min(value, na.rm = T), digits), ", ",
          round(max(value, na.rm = T), digits)
        ),
        .groups = "drop"
      ) %>%
      mutate_at(
        vars(`Mean (SD)`:`Min, Max`),
        ~ifelse(n == 0, "-", .)
      ) %>%
      mutate(
        `Mean (SD)` = ifelse(n == 1, str_replace(`Mean (SD)`, " NA", " - "),
                             `Mean (SD)`),
        `Median (IQR)` = ifelse(n == 1,
                                str_replace(`Median (IQR)`, "0.00", " - "),
                                `Median (IQR)`),
        `Min, Max` = ifelse(n == 1, str_remove(`Min, Max`, ",.*"), `Min, Max`)
      ) %>%
      ungroup() %>%
      pivot_longer(cols = c(-{{group}}, -{{time}}, -variable), names_to = "scoring",
                   values_to = "value",
                   values_transform = list(value = as.character)) %>%
      pivot_wider(names_from = {{group}}, values_from = value) %>%
      mutate_at(
        vars({{time}}, variable),
        ~if_else(scoring == "N", "N", as.character(.))
      ) %>%
      .[!duplicated(.), ]
  }

  order <- select(df, ...) %>%
    colnames()

  if(!missing(time)){

    order2 <- df %>%
      mutate({{time}} := as.factor({{time}})) %>%
      select({{time}}) %>%
      map(levels) %>%
      .[[1]]

    new <- new %>%
      mutate(
        {{time}} := parse_factor({{time}}, c("N", order2)),
        variable = parse_factor(variable, c("N", order)),
        scoring = as.factor(scoring),
        scoring = relevel(scoring, "n")
      ) %>%
      arrange(variable, {{time}}, scoring) %>%
      mutate_at(
        vars(-variable, -scoring, -{{time}}),
        ~if_else(variable == "N", paste("N =", .), .)
      ) %>%
      mutate_at(
        vars(variable, scoring, {{time}}),
        ~if_else(variable == "N", NA_character_, as.character(.))
      )

  } else {
    new <- new %>%
      mutate(
        variable = parse_factor(variable, c("N", order)),
        scoring = as.factor(scoring),
        scoring = relevel(scoring, "n")
      ) %>%
      arrange(variable, scoring) %>%
      mutate_at(
        vars(-variable, -scoring),
        ~if_else(variable == "N", paste("N =", .), .)
      ) %>%
      mutate_at(
        vars(variable, scoring),
        ~if_else(variable == "N", NA_character_, as.character(.))
      )
  }

  return(new)
}
