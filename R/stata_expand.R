#' Function to recreate the expand function in Stata
#'
#' @description Takes a dataframe and duplicates it n times, then creates a
#'              variable called Duplicate which has a value of 0 if the
#'              observation originally appeared int he dataset and 1 if the
#'              observation is one of the duplicates.
#'
#' @param df Data frame
#' @param n Number of times to duplicate (i.e. to end up with 2 copies of everything then n = 1)
#'
#' @examples
#' df <- data.frame(x = 1:5, y = c("a","b","c","d", "e"))
#' stata_expand(df, 1)
#'
#' @export
stata_expand <- function(df, n){
  old <- cbind(df, data.frame(Duplicate = 0))
  copy <- cbind(df, data.frame(Duplicate = 1))
  new <- rbind(old, copy[rep(seq_len(nrow(copy)), each=n),])
  return(new)
}

