prevent_linebreak <- function(pxtab, lines){

  tab <- str_split(pxtab, "\n")[[1]]

  if(lines == "multirow"){
    lines <- str_which(tab, regex("^\\\\multirow"))
  }

  tab[lines] <- str_remove(tab[lines], " $")

  tab[lines] <- paste0(tab[lines], "*")

  out <- paste(tab, collapse = "\n")

  cat(out)
  return(invisible(out))

}
