library(plumber)
port <- Sys.getenv('PORT')
r <- plumb("APItest.R")
r$run(port=strtoi(port))
