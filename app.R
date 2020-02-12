library(plumber)
port <- Sys.getenv('PORT')
r <- plumb("/app/APItest.R")
r$run()
