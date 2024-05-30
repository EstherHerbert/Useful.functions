#' Use the University of Sheffield Colour Palette
#'
#' @description
#'   `display_unicol()` displays the colour palette in a graphics window.
#'
#'   `get_unicol()` returns the hex colour code for specified colour names and
#' tints.
#'
#' @export
display_unicol <- function() {
  col <- as.character(unicol$Hex)
  names(col) <- as.character(unicol$Hex)

  ggplot2::ggplot(unicol, ggplot2::aes(x = factor(Tint), y = Colour.name, fill = Hex)) +
    ggplot2::geom_point(shape = 22, size = 10, col = "black") +
    ggplot2::scale_fill_manual(values = col, guide = 'none') +
    ggplot2::scale_x_discrete(limits = rev) +
    ggplot2::labs(x = "", y = "") +
    ggplot2::theme_minimal() +
    ggplot2::theme(text = ggplot2::element_text(size = 16))
}

#' @rdname display_unicol
#'
#' @param names a character vector of colour names
#' @param tints a real vector of tints, default is 1
#'
#' @export
get_unicol <- function(names, tints = 1) {
  options <- expand.grid(Colour.name = names, Tint = tints)

  out <- dplyr::semi_join(unicol, options, by = c("Colour.name", "Tint"))$Hex

  missing <- dplyr::anti_join(options, unicol, by = c("Colour.name", "Tint"))

  if(nrow(missing) > 0) {

    warning("Not all colours were available in the tints given. Missing ",
            "colours are: ", paste(apply(missing, 1, paste, collapse = ": "),
                                   collapse = "; "), call. = FALSE)
  }

  return(out)
}
