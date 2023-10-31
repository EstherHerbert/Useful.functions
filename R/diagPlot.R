#' Diagnostic plots
#'
#' `diagPlot` is a generic function used to produce diagnostic plots for the
#' results of various model fitting functions. The function invokes particular
#' [methods()] which depend on the [class()] of the model.
#'
#' @param model a model object for which diagnostic plots are required
#' @param ... arguments to pass to methods
#'
#' @returns returns a `gtable`
#'
#' @export
diagPlot <- function(model, ...){
  UseMethod("diagPlot", model)
}

#' @export
diagPlot.default <- function(model, ...){
  cat("no method exists for this object")
}

#' @export
diagPlot.lm <- function(model, plot = FALSE, ...) {

  p1 <- ggplot2::ggplot(model, ggplot2::aes(.fitted, .resid)) +
    ggplot2::geom_point() +
    ggplot2::stat_smooth(method = "loess") +
    ggplot2::geom_hline(yintercept = 0, col = "red", linetype = "dashed") +
    ggplot2::labs(x = "Fitted values", y = "Residuals",
                  title = "Residual vs Fitted Plot") +
    ggplot2::theme_bw()

  p2 <- ggplot2::ggplot(model, ggplot2::aes(sample = .stdresid)) +
    ggplot2::geom_qq() +
    ggplot2::geom_qq_line(lty = "dashed") +
    ggplot2::labs(x = "Theoretical Quantiles", y = "Standardized Residuals",
                  title = "Normal Q-Q") +
    ggplot2::theme_bw()

  p3 <- ggplot2::ggplot(model, ggplot2::aes(.fitted, sqrt(abs(.stdresid)))) +
    ggplot2::geom_point(na.rm = TRUE) +
    ggplot2::stat_smooth(method = "loess", na.rm = TRUE) +
    ggplot2::labs(x = "Fitted Value", y = expression(sqrt("|Standardized residuals|")),
                  title = "Scale-Location") +
    ggplot2::theme_bw()

  p4 <- ggplot2::ggplot(model, ggplot2::aes(.hat, .stdresid)) +
    ggplot2::geom_point(na.rm = TRUE) +
    ggplot2::stat_smooth(method = "loess", na.rm = TRUE) +
    ggplot2::labs(x = "Leverage", y = "Standardized Residuals",
                  title = "Residual vs Leverage Plot") +
    ggplot2::theme_bw()

  plots <- gridExtra::arrangeGrob(grobs = list(p1, p2, p3, p4),
                       layout_matrix = matrix(c(1,3,2,4), nrow = 2))

  if(plot) plot(plots)

  return(plots)

}

#' @export
diagPlot.lme <- function(model, plot = FALSE, ...) {

  aug <- broom.mixed::augment(model) %>%
    dplyr::mutate(
      .residfixed = score - .fixed
    )
  tid <- broom.mixed::tidy(model, effects = "ran_vars")

  p1 <- ggplot2::ggplot(aug, ggplot2::aes(.fixed, .residfixed)) +
    ggplot2::geom_point() +
    ggplot2::labs(x = "Fitted values", y = "Population level residuals") +
    ggplot2::theme_bw()

  p2 <- ggplot2::ggplot(tid, ggplot2::aes(sample = estimate)) +
    ggplot2::geom_qq() +
    ggplot2::geom_qq_line(lty = "dashed") +
    ggplot2::labs(x = "Quantiles of standard normal", y = "Random effects") +
    ggplot2::theme_bw()

  if(length(unique(tid$group)) > 1) {
    p2 <- p2 +
      ggplot2::facet_grid(cols = vars(group))
  }

  p3 <- ggplot2::ggplot(aug, ggplot2::aes(.fitted, .resid)) +
    ggplot2::geom_point() +
    ggplot2::labs(x = "Fitted values", y = "Subject level residuals") +
    ggplot2::theme_bw()

  p4 <- ggplot2::ggplot(aug, ggplot2::aes(sample = .resid)) +
    ggplot2::geom_qq() +
    ggplot2::geom_qq_line(lty = "dashed") +
    ggplot2::labs(x = "Quantiles of standard normal", y = "Subject level residuals") +
    ggplot2::theme_bw()

  plots <- gridExtra::arrangeGrob(grobs = list(p1, p2, p3, p4),
                       layout_matrix = matrix(c(1,2,3,4), nrow = 2))

  if(plot) plot(plots)

  return(plots)

}

#' @export
diagPlot.merMod <- function(model, ...) {

  diagPlot.lme(model, ...)

}
