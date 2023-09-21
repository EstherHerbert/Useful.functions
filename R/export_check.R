#' Checks imported form lengths against the export note produced by prospect.
#'
#' For use with CTRU studies using prospect. This function checks the read in
#' csv file lengths against he export note produced by prospect.
#'
#' @param export_notes file path to the export note (usually in the same folder
#'                     as the exported csv files and called export_note.txt)
#' @param data a list containing the read in data
#' @param save.log logical, should a log of the check be saved?
#' @param file if `save.log = TRUE` then the file path to which the log should
#'   be saved (e.g. "export-check.log").
#'
#' @returns nothing is returned but a message is printed to the console (or
#'   saved to a log) stating whether the check was successful.
#'
#' @export
export_check <- function(export_notes, data, save.log = FALSE, file = "") {

  if(save.log & file == "") {
    warning(paste("You have asked to save the log but have not specified a",
                  "file location; the log has not been saved."), call. = FALSE)
  }

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
        gsub("\\(|\\)|-", "", .) %>%
        tolower()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(form, n.rows)

  log <- c()
  for(i in seq_along(data)) {
    temp <- dplyr::filter(export, form == names(data)[i])
    if(nrow(temp) > 0) {
      if(temp$n.rows != nrow(data[[i]]))
        log <- c(log, paste("Form", names(data)[i],
                            "has differing number of rows"))
    }
  }

  if(length(log) > 0) {
    log <- paste(log, collapse = "\n")
    cat(log, file = file)
  } else {
    cat("Check complete: All forms correct\n", file = file)
  }

}
