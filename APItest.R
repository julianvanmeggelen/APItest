#* @filter cors
function(req, res) {
  
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
#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
    list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @png
#* @get /plot
function() {
    rand <- rnorm(100)
    hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
    as.numeric(a) + as.numeric(b)
}


