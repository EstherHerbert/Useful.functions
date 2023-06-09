insert_section <- function(width = getOption("width", 80)){

  context <- rstudioapi::getActiveDocumentContext()

  current_col <- context$selection[[1]]$range[[1]][[2]]

  num_dashes <- width - current_col + 1

  rstudioapi::insertText(location = context$selection[[1]]$range[[1]],
                         text = strrep("-", num_dashes))
}
