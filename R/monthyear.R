monthyear <- function(){
  rstudioapi::insertText(format(Sys.time(), "%B %Y"))
}
