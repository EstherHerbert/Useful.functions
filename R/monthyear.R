monthyear <- function(){
  context <- rstudioapi::getActiveDocumentContext()

  rstudioapi::insertText(location = context$selection[[1]]$range[[1]],
                         text = format(Sys.time(), "%B %Y"))
}
