str_wrap_factor <- function(x, ...) {

  factor(str_wrap(x, ...), levels = str_wrap(levels(x), ...))

}
