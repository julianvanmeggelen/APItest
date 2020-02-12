library(plumber)
port <- Sys.getenv('PORT')
plumber::plumb("/app/APItest.R")$run()

