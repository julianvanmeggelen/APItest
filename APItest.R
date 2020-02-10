
library(plumber)
library(quantmod)
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
  data <- getSymbols(symbol,auto.assign=FALSE, from="2020-01-01", src='yahoo')
  price <- as.numeric(data[nrow(data),4])
  return(price)
}
#* test
#* @get /echo
function() {
    return("API working")
}




