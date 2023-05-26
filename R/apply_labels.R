#' Apply labels from a dataspec to a column
#'
#' @param df Data frame
#' @param col Variable to be labeled
#' @param dataspec where to find the labels
#' @param ticked logical - is the variable a ticked variable?
#'
#' @export
apply_labels <- function(df, col, dataspec = dataspec, ticked = FALSE){

  col <- rlang::enquo(col)

  vars <- dplyr::filter(df, !is.na(!!col))  %>%
    dplyr::pull(!!col) %>%
    unique() %>%
    paste0(collapse = "|")

  if(ticked){
    labs <- dataspec %>%
      dplyr::filter(stringr::str_detect(code, vars)) %>%
      dplyr::select(field = code, field_label = label)
  } else {
    labs <- dataspec %>%
      dplyr::filter(stringr::str_detect(field, vars)) %>%
      dplyr::mutate(field = stringr::str_remove_all(field, "\\[calculated\\] ")) %>%
      dplyr::select(field, field_label)
  }

  df %>%
    dplyr::mutate(
      !!col := dplyr::recode(!!col, !!!setNames(labs$field_label, labs$field))
    )

}
