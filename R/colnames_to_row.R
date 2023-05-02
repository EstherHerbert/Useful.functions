colnames_to_row <- function(df, row = 1) {

  colnames <- names(df)
  colnames <- set_names(colnames, colnames)

  new <- add_row(df, !!!colnames, .before = row)

  return(new)

}
