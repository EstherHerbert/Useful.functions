clean_label <- function(string, locale = "en") {

  I <- purrr::map(stringr::str_split(string, " "),
                  \(x) stringr::str_extract(x, "[:upper:]{2,}"))

  s <- stringr::str_split(stringr::str_to_sentence(string), " ")

  purrr::map2_chr(I, s, function(x, y) {
    stringr::str_flatten(dplyr::coalesce(x, y), collapse = " ")
  })

}
