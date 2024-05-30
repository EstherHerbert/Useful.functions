## code to prepare `DATASET` dataset goes here

unicol <- read.csv("data-raw/UniColours.csv") %>%
  dplyr::mutate(
    Hex = paste0("#", Hex)
  )

usethis::use_data(unicol, overwrite = TRUE)
