#' Produce a data frame to summarise discrete variables coded as Yes/No
#'
#' @description
#' Takes a data frame and produces the number and percentage for yes/no
#' variables. Note that the denominator currently always excludes missing
#' values.
#'
#' @param df Data Frame
#' @param ... Variables to be summarised
#' @param group Optional variable that defines the grouping
#' @param digits Number of digits to display percentages to, default is 1
#' @param total Logical indicating whether a total column should be created
#' @param show_denom Logical, should the denominator for each variable be shown.
#'   Default is `TRUE`.
#'
#' @return A tibble data frame summarising the data
#'
#' @examples
#' yn_table(outcome, limp_yn, group = group)
#' yn_table(outcome, limp_yn, group = group, total = FALSE)
#' yn_table(outcome, limp_yn, show_denom = FALSE)
#'
#'
#' @export
yn_table <- function (df = .,
                      ...,
                      group,
                      digits = 1,
                      total = TRUE,
                      show_denom = TRUE){

  rlang::check_dots_unnamed()

  if (missing(group)) {
    total <- FALSE
  }

  if(total){
    df <- df %>%
      totals({{group}})
  }

  if(!missing(group)){
    new <- df %>%
      dplyr::select({{group}}, ...) %>%
      tidyr::pivot_longer(-{{group}}, names_to = "scoring",
                          values_to = "value") %>%
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = np(value == "Yes", digits = digits, na_rm = T,
                show_denom = show_denom),
        .by = c({{group}}, scoring)
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
      dplyr::summarise(
        N = paste("N =", dplyr::n()),
        np = np(value == "Yes", digits = digits, na_rm = T,
                show_denom = show_denom),
        .by = scoring
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

  new <- new %>%
    dplyr::mutate(
      variable = scoring,
      scoring = dplyr::case_match(scoring, NA ~ NA, .default = "")) %>%
    dplyr::relocate(variable, .before = 1)

  return(new)

}
