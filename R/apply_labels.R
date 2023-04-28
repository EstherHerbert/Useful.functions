#' Apply labels from a dataspec to a column
#'
#' @param df Data frame
#' @param col Variable to be labeled
#' @param dataspec where to find the labels
#'
#' @export
apply_labels <- function(df, col, dataspec = dataspec){

  col_q <- rlang::enquo(col)
  rlang::quo_name(col_q)
  vars <- dplyr::filter(df, !is.na(!!col_q)) %>%
    magrittr::extract2(rlang::quo_name(col_q)) %>%
    unique() %>%
    paste0(collapse = "|")

  labs <- dataspec %>%
    dplyr::filter(stringr::str_detect(Identifier, vars)) %>%
    dplyr::mutate(Identifier = stringr::str_remove_all(Identifier,
                                                       "\\[calculated\\] ")) %>%
    dplyr::select(Identifier, Label)

  df %>%
    dplyr::mutate(
      !!col_q := factor(!!col_q, levels = labs$Identifier, labels = labs$Label)
    )

}
