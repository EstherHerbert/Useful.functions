#' Extend broom's tidy.emmGrid function to provide confidence intervals
#'
#' @description
#'
#' @param x "emmGrid" object
#' @param conf.int Logical indicating whether or not to include a confidence
#'                 interval in the tidied output. Defaults to FALSE.
#' @param conf.level The confidence level to use for the confidence interval if
#'                   conf.int = TRUE. Must be strictly greater than 0 and less
#'                   than 1. Defaults to 0.95, which corresponds to a 95 percent
#'                   confidence interval.
#'
#' @examples
#' library(emmeans)
#' data("oranges")
#'
#' oranges.lm <- lm(sales1 ~ price1*day, data = oranges)
#' oranges.em <- emmeans(oranges.lm, pairwise ~ day)
#'
#' my_tidy.emmGrid(oranges.em$contrasts, conf.int = T)
#'
#' @export
my_tidy.emmGrid <- function(x,
                            conf.int = F,
                            conf.level = 0.95){

  if(class(x)[1] != "emmGrid") stop("x must be an object of class 'emmGrid'.")

  if(conf.int & (conf.level <= 0 | conf.level >= 1)){
    stop("conf.level must be strictly greater than 0 and less than 1.")
  }

  if(conf.int){
    out <- suppressMessages(left_join(
      as_tibble(x),
      as_tibble(confint(x, level = conf.level))
    ))
    if(attr(x@dffun, "mesg") == "asymptotic"){
      out <- out %>%
        rename(std.error = SE, conf.low = asymp.LCL, conf.high = asymp.UCL)
    } else {
      out <- out %>%
        rename(std.error = SE, conf.low = lower.CL, conf.high = upper.CL)
    }

  } else {
    out <- as_tibble(x) %>%
      rename(std.error = SE)
  }

  return(out)

}
