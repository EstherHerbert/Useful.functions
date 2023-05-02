english <- function(x){
  english::english(x, UK = T)
}

English <- function(x){
  str_to_sentence(english::english(x, UK = T))
}
