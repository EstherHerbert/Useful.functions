#' Checks imported form lengths against the export note produced by prospect.
#'
#' For use with CTRU studies using prospect. This function checks the read in
#' csv file lengths against he export note produced by prospect.
#'
#' @param export_notes file path to the export note (usually in the same folder
#'   as the exported csv files and called export_note.txt)
#' @param data a list containing the read in data
#' @param file file path to which the log should be saved (e.g.
#'   "export-check.log"). If left as `file = ""` (the default) then the log will
#'   not be saved.
#'
#' @returns nothing is returned but a message is printed to the console (or
#'   saved to a log) stating whether the check was successful.
#'
#' @export
export_check <- function (export_notes, data, file = "") {

  export <- utils::read.delim(export_notes, header = F, strip.white = T)

  export <- export %>%
    dplyr::mutate(
      temp = dplyr::if_else(V1 == "Forms and subforms", 1, 0),
      temp = cumsum(temp)
    ) %>%
    dplyr::filter(temp == 1) %>%
    dplyr::mutate(
      br1 = regexpr("\\([^\\(]*$", V1),
      br2 = regexpr("\\)[^\\)]*$", V1)
    ) %>%
    dplyr::filter(br1 > 0) %>%
    dplyr::mutate(
      n.rows = as.numeric(substr(V1, br1 + 1, br2 - 1)),
      form = substr(V1, 1, br1 - 2),
      subform = grepl("^- ", V1),
      n = 1:dplyr::n(),
      n = n - cumsum(subform)
    ) %>%
    dplyr::group_by(n) %>%
    dplyr::mutate(
      form1 = dplyr::if_else(subform, form[1], NA),
      form = dplyr::if_else(subform, paste(form1, form), form),
      form = gsub("( - )| ", "_", form) %>%
        gsub("\\(|\\)|-|\\/", "", .) %>%
        tolower()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(form, n.rows)

  log <- c()

  for (i in seq_along(data)) {

    temp <- dplyr::filter(export, form == names(data)[i])

    if (nrow(temp) > 0) {
      if (temp$n.rows != nrow(data[[i]]))
        log <- c(log, paste("Form", names(data)[i],
                            "has differing number of rows, should be",
                            temp$n.rows))
    }
  }

  for (i in export$form) {
    if(!i %in% names(data)) {
      log <- c(log, paste("Form", i, "missing"))
    }
  }

  if (length(log) > 0) {
    log <- paste(log, collapse = "\n")
    cat(log, file = file)
    if(file != "") {
      cat("Errors found, check log:", file)
    }
  }
  else {
    if(file != "") {
      cat("Check complete: All forms correct\n")
    }
    cat("Check complete: All forms correct\n", file = file)
  }
}
