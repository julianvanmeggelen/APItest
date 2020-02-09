library(plumber)
port <- Sys.getenv('PORT')
r <- plumb("APItest.R")
r$run(host='0.0.0.0', port=strtoi(port))
