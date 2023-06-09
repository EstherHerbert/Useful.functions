end_box <- function(width = getOptions("width", 80)){

  context <- rstudioapi::getActiveDocumentContext()

  current_col <- context$selection[[1]]$range[[1]][[2]]

  num_spaces <- width - current_col - 1

  rstudioapi::insertText(location = context$selection[[1]]$range[[1]],
                         text = paste0(strrep(" ", num_spaces), "##"))

}
