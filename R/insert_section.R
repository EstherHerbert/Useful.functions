insert_section <- function(){

  context <- rstudioapi::getActiveDocumentContext()

  current_col <- context$selection[[1]]$range[[1]][[2]]

  num_dashes <- 80 - current_col + 1

  rstudioapi::insertText(location = context$selection[[1]]$range[[1]],
                         text = strrep("-", num_dashes))
}
