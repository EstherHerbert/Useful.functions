## code to prepare `outcome` dataset goes here

library(tidyverse)

set.seed(1212)

outcome <- expand_grid(
  site = paste0("S", formatC(1:10, width = 2, format = "d", flag = "0")),
  screening = formatC(1:20, width = 2, format = "d", flag = "0")
) %>%
  mutate(
    screening = paste0(site, "/", screening),
    group = factor(sample(LETTERS[1:2], nrow(.), replace = T),
                   levels = LETTERS[1:2]),
    Baseline = rnorm(dplyr::n(), mean = 4, sd = 2),
    `6 Weeks` = dplyr::if_else(group == "A",
                               Baseline + rnorm(dplyr::n(), mean = 0, sd = 1),
                               Baseline + rnorm(dplyr::n(), mean = 3, sd = 1)),
    `12 Weeks` = dplyr::if_else(group == "A",
                                `6 Weeks` + rnorm(dplyr::n(), mean = 0, sd = 1),
                                `6 Weeks` + rnorm(dplyr::n(), mean = 2, sd = 1)),
    sex = sample(c("Male", "Female"), dplyr::n(), replace = T),
    sex = forcats::fct_expand(sex, "Prefer not to specify"),
    r = sample(0:1, n(), replace = T, prob = c(0.01, 0.99)),
    sex = if_else(r == 0, NA, sex)
  ) %>%
  pivot_longer(Baseline:`12 Weeks`, names_to = "event_name", values_to = "score") %>%
  mutate(
    event_name = fct_relevel(event_name, c("Baseline", "6 Weeks", "12 Weeks")),
    r = sample(0:1, n(), replace = T, prob = c(0.1, 0.9)),
    score = if_else(r == 0, NA, score)
  ) %>%
  select(-r)

usethis::use_data(outcome, overwrite = TRUE)
