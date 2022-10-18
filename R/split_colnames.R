#' Tools for working with column names
#'
#' @description Splits column names into two rows. The first row are the new
#'              column names, the second are the first row of the data.
#'
#' @param df A data frame.
#' @param sep Separator between column names and first row.
#' @export
split_colnames <- function(df, sep = "_"){

  df_names <- names(df) %>%
    str_split(sep, simplify = T)

  df_names <- set_names(df_names[,2], df_names[,1])

  df <- set_colnames(df, names(df_names))

  out <- rbind(df_names, df)

  return(out)

}
