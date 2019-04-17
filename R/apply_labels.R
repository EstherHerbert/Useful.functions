#' Apply labels from a dataspec to a column
#'
#' @param df Data frame
#' @param col Variable to be labeled
#' @param dataspec where to find the labels
#'
#' @export
apply_labels <- function(df, col, dataspec = dataspec){

  col_q <- enquo(col)
  quo_name(col_q)
  vars <- filter(df, !is.na(!!col_q))  %>%
    extract2(quo_name(col_q)) %>%
    unique() %>%
    paste0(collapse = "|")

  labs <- dataspec %>%
    filter(str_detect(Identifier, vars)) %>%
    mutate(Identifier = str_remove_all(Identifier, "\\[calculated\\] ")) %>%
    select(Identifier, Label)

  df %>%
    mutate(
      !!col_q := factor(!!col_q, levels = labs$Identifier, labels = labs$Label)
    )

}
