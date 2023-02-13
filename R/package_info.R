#' package_info
#'
#' @return A tibble of loaded packages and versions.
#' @export
package_info <- function(){

  sessionInfo()$otherPkgs %>%
    purrr::map_df(with, data.frame(Package, Version)) %>%
    dplyr::arrange(Package)

}
