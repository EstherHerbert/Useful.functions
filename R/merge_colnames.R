merge_colnames <- function(xtab){
  header <- names(xtab)

  n <- rle(header)$lengths
  v <- rle(header)$values

  v <- sanitise_percent(v)

  names <- if_else(n == 1, v, paste0("\\multicolumn{", n, "}{c}{", v, "}"))

  colnames <- list()

  colnames$pos <- list(0)
  colnames$command <- makerow(names)

  return(colnames)
}

