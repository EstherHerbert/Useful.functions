#' Creates forest plots
#'
#' @description Forest plots are often used when comparing different analyses.
#'              This function uses ggplot2 to create a forest plot.
#'
#' @param df A data frame containing the names of each analysis as well as the
#'           point estimages and confience interval levels.
#' @param names The name of the variable containing the analises names.
#' @param estimate The name of the variable containing the point estimates
#' @param lower The name of the variable containing the lower limits of the
#'              confidence intervals.
#' @param xlab String of text for the x-axis label.
#' @param ylab String of text for the y-axis label.
#' @param title String of text for the title.
#' @param theme ggplot theme. If \code{theme = NULL} then the default ggplot
#'              theme is used.
#' @param zeroline Logical. Should a line be added to indicate zero effect?
#'
#' @examples
#' df <- data.frame(x = c("A", "B", "C"), y = 1:3, ymin = 0:2, ymax = 2:4)
#' forest_plot(df)
#' forest_plot(df, theme = NULL, zeroline = FALSE)
#'
#' @export
forest_plot <- function(df = .,
                        names = x,
                        estimate = y,
                        lower = ymin,
                        upper = ymax,
                        xlab = "",
                        ylab = "",
                        title = "",
                        theme = theme_bw(),
                        zeroline = TRUE,
                        ...){
  names <- quo_name(enquo(names))
  estimate <- quo_name(enquo(estimate))
  lower <- quo_name(enquo(lower))
  upper <- quo_name(enquo(upper))
  p <- ggplot(df, aes_string(x = names, y = estimate, ymin = lower, ymax = upper)) +
    geom_pointrange() +
    coord_flip() +
    theme +
    labs(x = ylab,
         y = xlab,
         title = title)

  if(zeroline) p <- p + geom_hline(yintercept = 0, lty = 3)

  p
}
