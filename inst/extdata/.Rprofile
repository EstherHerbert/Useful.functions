setHook("rstudio.sessionInit", function(newSession) {
  if (newSession)
    rstudioapi::navigateToFile('Programs/Master.R', line = -1L, column = -1L)
}, action = "append")
