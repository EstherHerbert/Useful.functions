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
    Baseline = rnorm(n(), mean = 4, sd = 2),
    `6 Weeks` = if_else(group == "A",
                               Baseline + rnorm(n(), mean = 0, sd = 1),
                               Baseline + rnorm(n(), mean = 3, sd = 1)),
    `12 Weeks` = if_else(group == "A",
                                `6 Weeks` + rnorm(n(), mean = 0, sd = 1),
                                `6 Weeks` + rnorm(n(), mean = 2, sd = 1)),
    sex = sample(c("Male", "Female"), n(), replace = T),
    sex = fct_expand(sex, "Prefer not to specify"),
    r = sample(0:1, n(), replace = T, prob = c(0.01, 0.99)),
    sex = if_else(r == 0, NA, sex),
    pet_dog = sample(c("Ticked", NA), n(), replace = T, prob = c(36, 64)),
    pet_cat = sample(c("Ticked", NA), n(), replace = T, prob = c(26, 74)),
    pet_fish = sample(c("Ticked", NA), n(), replace = T, prob = c(15, 85))
  ) %>%
  pivot_longer(Baseline:`12 Weeks`, names_to = "event_name", values_to = "score") %>%
  mutate(
    event_name = fct_relevel(event_name, c("Baseline", "6 Weeks", "12 Weeks")),
    r = sample(0:1, n(), replace = T, prob = c(0.1, 0.9)),
    score = if_else(r == 0, NA, score),
    pain = case_when(
      group == "A" ~ sample(c("Low", "Medium"), n(), replace = T),
      group == "B" ~ sample(c("Low", "Medium", "High"), n(), replace = T)
    ),
    pain = factor(pain, levels = c("Low", "Medium", "High")),
    r = sample(0:1, n(), replace = T, prob = c(1,99)),
    pain = if_else(r == 0, NA, pain)
  ) %>%
  select(-r)

usethis::use_data(outcome, overwrite = TRUE)
