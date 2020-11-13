end_box <- function(){
  context <- rstudioapi::getActiveDocumentContext()

  current_col <- context$selection[[1]]$range[[1]][[2]]

  num_spaces <- 80 - current_col - 1

  rstudioapi::insertText(location = context$selection[[1]]$range[[1]],
                         text = paste0(strrep(" ", num_spaces), "##"))

}
