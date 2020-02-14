
library(plumber)
library(quantmod)
source("/app/algorithm.R")
#* @apiTitle Plumber Example API
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}
#* Retreive stock price
#* @param symbol stock name
#* @get /getPrice
function(symbol) {
  package <- retreive_high_low(symbol)
  return(package)
}
#* test
#* @get /echo
function() {
    return("API working")
}




