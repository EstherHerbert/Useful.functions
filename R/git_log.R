#' Generates a log of git commits
#'
#' @description This function uses a call to git on the command line to generate
#'  a csv file which logs all git commits within the working directory.
#'
#' @param filename a character string with the file name to be used, must end in
#'  ".csv". The default is "git_log_DATESTAMP.csv".
#'
#' @export
git_log <- function(filename = file_stamp("git_log", ".csv")) {

  if (suppressWarnings(shell("git rev-parse --is-inside-work-tree", shell = "cmd",
            intern = TRUE)) != "true") {
    stop("The working directory is not a git repository.")
  }

  if (Sys.info()[['sysname']] != "Windows") {
    stop("This function only works on Windows operating systems.")
  }

  call <- paste("git log --pretty=format:\"%h,%D,%an,%aI,%f\" >", filename)

  shell(call, shell = "cmd")

}
