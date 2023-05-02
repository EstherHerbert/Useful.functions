# perc_n function from qwraps2 doesn't perform as expected, have written my own
# function instead.

pn <- function(x, accuracy = 0.1, show_denom = F){

  d <- sum(!is.na(x))
  n <- sum(x, na.rm = T)
  p <- scales::percent(n/d, accuracy = accuracy)

  if(show_denom){
    out <- paste0(p, " (", scales::comma(n), "/", scales::comma(d), ")")
  } else {
    out <- paste0(p, " (", scales::comma(n), ")")
  }

  return(out)

}
