#' Produce a dataframe to summaries continuous variables
#'
#' @description Takes a dataframe and produces grouped or ungrouped summaries
#'              such as mean and standard deviation for continuous variables.
#'
#' @param df Data frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param total Logical indicating wether a total column should be created
#'
#' @examples
#'     continuous_table(df = iris, Petal.Length, Petal.Width, group = Species)
#'     continuous_table(df = iris, Sepal.Length, Sepal.Width, group = Species,
#'                      total = FALSE)
#'     continuous_table(df = iris, Petal.Length, Sepal.Length)
#'
#' @return A tibble data frame summarising the data
#'
#' @export
continuous_table <- function(df = .,
                             ...,
                             group = .,
                             total = TRUE) {
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
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        iqr = round0(IQR(value, na.rm = T), 2),
        min = min(value, na.rm = T),
        max = max(value, na.rm = T),
      ) %>%
      mutate(
        `Mean(SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", iqr, ")"),
        `Min to Max` = paste(min, "to", max)
      ) %>%
      ungroup() %>%
      select(-c(m, sd, med, iqr, min, max)) %>%
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
        m = round0(mean(value, na.rm = T), 1),
        sd = round0(sd(value, na.rm = T), 2),
        med = round0(median(value, na.rm = T), 1),
        iqr = round0(IQR(value, na.rm = T), 2),
        min = min(value, na.rm = T),
        max = max(value, na.rm = T)
      ) %>%
      mutate(
        `Mean(SD)` = paste0(m, " (", sd, ")"),
        `Median (IQR)` = paste0(med, " (", iqr, ")"),
        `Min to Max` = paste(min, "to", max)
      ) %>%
      ungroup() %>%
      select(-c(m, sd, med, iqr, min, max)) %>%
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
