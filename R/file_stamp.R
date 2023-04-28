#' Produce a file name string with date-time stamp
#'
#' @description Turns a character string into a file name with date-time stamp
#'
#' @param chr String detailing file name
#' @param format String giving file extension
#' @param time Logical - should time be included in the stamp?
#'
#' @return A character string with the new file name
#'
#' @export
file_stamp <- function(chr,
                       format = ".xlsx",
                       time = FALSE){

  if(time){
    paste0(chr, "_", format(Sys.time(), "%Y%m%d%H%M"), format)
  } else {
    paste0(chr, "_", format(Sys.time(), "%Y%m%d"), format)
  }
}
