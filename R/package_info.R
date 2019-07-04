#' package_info
#'
#' @return A tibble of loaded packages and versions.
#' @export
package_info <- function(){

  sessionInfo()$otherPkgs %>%
    map_df(with, data.frame(Package, Version)) %>% arrange(Package)

}
