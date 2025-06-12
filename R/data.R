#' University of Sheffield Colour Palette
#'
#' A data frame of the colours in the official Univerisity of Sheffield colour
#' palette.
#'
#' @format ## `unicol`
#' A data frame with 48 rows and 3 columns:
#' \describe{
#'   \item{Colour.name}{Colour name}
#'   \item{Tint}{Where, applicable the tint of the colour.}
#'   \item{Hex}{Hex colour code}
#' }
#' @source <https://www.sheffield.ac.uk/brand-toolkit/colour>
"unicol"

#' Simulated outcome data.
#'
#' A simulated data frame used in examples.
#'
#' @format ## `outcome`
#' A data frame with 600 rows and 6 columns:
#' \describe{
#'    \item{site}{character, site code}
#'    \item{screening}{character, individual id number}
#'    \item{group}{factor, treatment group A/B}
#'    \item{sex}{factor with three levels: Male, Female, Prefer not to specify}
#'    \item{event_name}{factor with 3 levels: Baseline, 6 Weeks, 12 Weeks}
#'    \item{score}{double, randomly generated "score"}
#' }
"outcome"
