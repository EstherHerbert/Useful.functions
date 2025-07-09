#' Condense two or three columns into one
#'
#' Useful for saving space with summary tables created by [continuous_table()],
#' [discrete_table()], [ticked_table()] or [ae_table()].
#'
#' @param df a data frame containing at least one column with repeated values.
#' @param first_col variable name of the column to collapse into - should contain
#'   repeated values. Default is `variable` for quick use with the summary table
#'   functions.
#' @param second_col variable name of the column to be collapsed into
#'   `first_col`. Default is `scoring` for quick use with the summary table
#'   functions.
#' @param third_col Optionally, a third column to be collapsed into `second_col`.
#' @param hline Logical indicating whether `"\\hline\n"` should be added at the
#'   start of each unique value in `first_col`. For use with [xtable::xtable()].
#'   Default is `TRUE`.
#' @param double.header Logical indicating whether `df` has a double header.
#'   Default is `TRUE`.
#' @param indent Character indicating the type of indent to use (the default is
#'   `"quad"`):
#'   - `"quad"` uses \eqn{\LaTeX}'s `\\quad` to indent the second column (and
#'     `\\qquad \\quad` to indent the third column if given)
#'   - `"hang"` uses \eqn{\LaTeX}'s `\\hangindent2em\\hangafter0` to indent the
#'     second column (and `\\hangindent4em\\hangafter0` to indent the third
#'     column if given)
#'   - `"space"` uses `"    "` to indent the second column (and `"        "` to
#'     indent the third column if given)
#'
#' @examples
#'   continuous_table(df = iris, Petal.Length, Petal.Width, group = Species) %>%
#'        condense()
#'
#' @export
condense <- function(df, first_col = variable, second_col = scoring, third_col,
                     hline = TRUE, double.header = TRUE, indent = "quad") {

  if (hline) {
    h <- "\\hline\n"
  } else {
    h <- ""
  }

  if (is.factor(dplyr::pull(df, {{first_col}}))) {
    df <- df %>%
      dplyr::mutate(
        {{first_col}} := as.character({{first_col}})
      )
  }

  indent <- switch(
    indent,
    quad = c("\\quad", "\\qquad\\quad"),
    hang = c("\\hangindent2em\\hangafter0", "\\hangindent4em\\hangafter0"),
    space = c("    ", "        "),
    stop("indent must be one of `quad`, `hang` or `space`")
  )

  if (!missing(third_col)) {
    out <- df %>%
      dplyr::mutate({{first_col}} := readr::parse_factor({{first_col}})) %>%
      dplyr::group_by({{first_col}}, {{second_col}}) %>%
      dplyr::group_modify(~dplyr::add_row(.x, .before = 1)) %>%
      dplyr::group_by({{first_col}}) %>%
      dplyr::group_modify(~dplyr::add_row(.x, .before = 1)) %>%
      dplyr::filter(is.na(dplyr::lead({{third_col}})) | !dplyr::
                      lead({{third_col}}) %in% c("n", "")) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        {{first_col}} := forcats::fct_na_level_to_value({{first_col}}),
        {{first_col}} := dplyr::case_when(
          is.na({{first_col}}) ~ NA,
          is.na({{second_col}}) ~ paste(h, {{first_col}}),
          is.na({{third_col}}) | {{third_col}} %in% c("n", "") ~
            paste(indent[1], {{second_col}}),
          .default = paste(indent[2], {{third_col}})
        )
      ) %>%
      dplyr::select(-{{second_col}}, -{{third_col}})
  } else if (missing(third_col)) {
    out <- df %>%
      dplyr::mutate({{first_col}} := readr::parse_factor({{first_col}})) %>%
      dplyr::group_by({{first_col}}) %>%
      dplyr::group_modify(~dplyr::add_row(.x, .before = 1)) %>%
      dplyr::filter(is.na(dplyr::lead({{second_col}})) |
               !dplyr::lead({{second_col}}) %in% c("n", "")) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        {{first_col}} := forcats::fct_na_level_to_value({{first_col}}),
        {{first_col}} := dplyr::case_when(
          is.na({{first_col}}) ~ NA,
          is.na({{second_col}}) | {{second_col}} %in% c("n", "") ~
            paste(h, {{first_col}}),
          .default = paste(indent[1], {{second_col}})
        )
      ) %>%
      dplyr::select(-{{second_col}})
  }

  if (double.header) {
    out <- out[-1,]
  }

  out

}
