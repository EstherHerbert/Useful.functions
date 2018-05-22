#' Wrap for print.xtable to add threeparttable functionality
#'
#' @description This function wraps \code{print.xtable} with the threeparttable
#'              environment from latex.
#'
#' @param df Data frame to be passed to \code{print(xtable())}
#' @param align Character string specifying the column alighnment. See
#'              code{?xtable} for more information.
#' @param include.rownames Logical indicating whether the row names of
#'                         \code{df} are to be included in the table
#' @param include.colnames Logical indicating whether the column names of
#'                         \code{df} are to be included in the table
#' @param table.pos Character string indicating the position to pass to the
#'                  floating environment which is \code{table}
#' @param footnotes A list containing two components. The first should be
#'                  called "i" and should contain a character vector with the
#'                  names of the footnotes in the table (e.g.
#'                  \code{c("\\\\dag")}). The second component should be called
#'                  "text" and should be a character vector of equal length to
#'                  "i". "text" should contain the footnote text to be
#'                  displayed below the table.
#' @param caption Optional character string giving the caption for the table
#' @param label Optional character string giving the label for the table
#' @param ... Further arguments to be passed to \code{print.xtable}
#'
#' @examples
#' df <- BOD
#' df[1,1] <- paste(df[1,1], "\\tnote{1}")
#' df[4,2] <- paste(df[4,2], "\\tnote{2}")
#' table_with_footnotes(df,
#'                      align = "lrr",
#'                      footnotes = list(i = c(1,2), text = c("a", "b"),
#'                      hline.after = c(1,2),
#'                      caption = "Yes",
#'                      label = "tab:yes")
#'
#' @note The package threeparttable is required to run the produced code in
#'       latex
#'
#' @export
table_with_footnotes <- function(df,
                                 align,
                                 include.rownames = FALSE,
                                 include.colnames = FALSE,
                                 table.pos = "h!",
                                 footnotes = list(i, text),
                                 caption,
                                 label,
                                 ...) {
  require(xtable)

  cat(paste0(
    "\\begin{table}[", table.pos, "]\n",
    "\\begin{threeparttable}\n"
  ))
  if (!missing(caption)) {
    cat(paste0("\\caption{", caption, "}\n"))
  }
  if (!missing(label)) {
    cat(paste0("\\label{", label, "}\n"))
  }
  xtable(df,
    align = align, ...
  ) %>%
    print(
      floating = F,
      include.rownames = include.rownames,
      include.colnames = include.colnames,
      sanitize.text.function = sanitise_percent,
      ...
    )
  cat(paste0(
    "\\begin{tablenotes}\n",
    paste0("\\item[", footnotes$i, "] ", footnotes$text, collapse = "\n"),
    "\n\\end{tablenotes}\n",
    "\\end{threeparttable}\n",
    "\\end{table}"
  ))
}
