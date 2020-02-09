#* @filter cors
function(req, res) {
  print(""Launched Api)
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } 
  plumber::forward()
  
  
}

library(plumber)
library(quantmod)
#* @apiTitle Plumber Example API


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




