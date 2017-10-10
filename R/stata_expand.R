#' Function to recreate the expand function in Stata
#'
#' @description Takes a dataframe and duplicates it n times, then creates a
#'              variable (default name is Duplicate) which has a value of 0 if
#'              the observation originally appeared int he dataset and
#'              i = 1,..,n for each duplicate.
#'
#' @param df Data frame
#' @param n Number of times to duplicate (i.e. to end up with 2 copies of
#'          everything then n = 1)
#' @param name Character string indicating the name of the variable indicating
#'             which rows are duplicates
#'
#' @return A data frame
#'
#' @examples
#' df <- data.frame(x = 1:5, y = c("a","b","c","d", "e"))
#' stata_expand(df, 1)
#'
#' @export
stata_expand <- function(df,
                         n,
                         name = "Duplicate"){

  old <- cbind(df, data.frame(temp = 0))
  copy <- list()
  for(i in 1:n){
    copy[[i]] <- cbind(df, data.frame(temp = i))
  }
  copy <- do.call("rbind", copy)
  new <- rbind(old, copy)

  colnames(new)[ncol(new)] <- name

  return(new)

}
