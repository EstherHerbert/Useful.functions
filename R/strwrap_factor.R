#' String wrapping for factor variables
#'
#' @param x a factor vector
#' @param width Positive integer giving target line width (in number of
#'              characters). A width less than or equal to 1 will put each word
#'              on its own line.
#' @param ... arguments passed to `stringr::str_wrap`
#'
#' @returns a factor vector the same length as `x` with factor levels wrapped
#'
#' @examples
#'
#' nt_yorks <- factor(c("Beningbrough Hall (Historic House)",
#'                      "Braithwaite Hall (Historic Property)",
#'                      "Brimham Rocks (Countryside)",
#'                      "East Riddlesden Hall (Historic House)",
#'                      "Fountains Abbey (Abbey)",
#'                      "Gibson's Mill (Historic Property)",
#'                      "Goddards House & Garden (Historic House)",
#'                      "Hardcastle Crags (Countryside)",
#'                      "Hudswell Woods (Countryside)",
#'                      "Maister House (Historic Property)",
#'                      "Moulton Hall (Historic Property)",
#'                      "Nostell Priory (Historic House)",
#'                      "Nunnington Hall (Historic Property)",
#'                      "Rievaulx Terrace and Temples (Garden)",
#'                      "Roseberry Topping (Countryside)",
#'                      "Studley Royal Water Garden (Garden)",
#'                      "The Bridestones (Countryside)",
#'                      "Treasurers House (Historic Property)"))
#'
#' strwrap_factor(nt_yorks, width = 10)
#'
#' @export
strwrap_factor <- function(x, width, ...) {

  factor(stringr::str_wrap(x, width = width, ...),
         levels = stringr::str_wrap(levels(x), width = width, ...))

}
