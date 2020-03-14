library("quantmod")
library("QuantTools")
sumx<-0
minvec<-0
maxvec<-0
normalizedataframe <- function(x){
  minvec <<- sapply(x,min)
  maxvec <<- sapply(x,max)
  return ((x - min(x)) / (max(x) - min(x)))
}
normalize_special <- function(x,y){
  return ((x - min(y)) / (max(y) - min(y)))
}
denormalizedataframe <- function(normalized,original) {
  return((normalized)*(max(original)-min(original))+min(original))
}

calculater2 <- function(real, predict){
  residuals <- real- predict
  sse <- sum(residuals^2)
  sst <- sum((real - mean(real))^2)
  r_squared <- 1 - sse/sst
  print(r_squared)
}

dataframe <- function(symbol){
  rawdata <- getSymbols(symbol,auto.assign=FALSE, from="2010-01-01", src='yahoo')
  rawdata$lastday.open <- c(0)
  rawdata$lastday.high<- c(0)
  rawdata$lastday.low<- c(0)
  rawdata$lastday.close<- c(0)
  rawdata$lastday.volume<- c(0)
  for (i in 2:nrow(rawdata)) {
    print(i)
    rawdata$lastday.open[i] <- rawdata[i-1,1]
    rawdata$lastday.close[i] <- rawdata[i-1,4]
    rawdata$lastday.high[i]  <- rawdata[i-1,2]
    rawdata$lastday.low[i] <- rawdata[i-1,3]
    rawdata$lastday.volume[i] <- rawdata[i-1,5]
  }
  print("1")
  rawdata$fivedayema <- ema(rawdata[,4], 5)
  rawdata$tendayema <- ema(rawdata[,4], 10)
  rawdata$twentydayema <- ema(rawdata[,4], 20)
  rawdata$thirtydayema <- ema(rawdata[,4], 30)
  print("1") 
  print("1")
  rawdata$fiftydayema <- ema(rawdata$lastday.close, 50)
  print("1")
  rawdata$growrate1 <- rawdata$tendayema/rawdata$fivedayema 
  rawdata$growrate2 <- rawdata$lastday.close/rawdata$fivedayema
  print("1")
  colnames(rawdata)[1] <- "open"
  colnames(rawdata)[2] <- "high"
  colnames(rawdata)[3] <- "low"
  colnames(rawdata)[4] <- "close"
  colnames(rawdata)[5] <- "volume"
  print("1")
  rawdata$volat <- rawdata$high - rawdata$low
  rawdata$openratio <- rawdata$lastday.close/rawdata$lastday.open
  return(rawdata)
}

train_models <- function(symbol,data){
  traindata <- data
  traindatanormalized <- as.data.frame(lapply(traindata[56:nrow(traindata),], normalizedataframe))
  prediction_data <- traindatanormalized[nrow(traindatanormalized),]
  regression_model_high <- lm(formula = high ~ open + lastday.volume + lastday.close + lastday.high +lastday.low +fivedayema+thirtydayema + openratio, data = traindatanormalized)
  regression_model_low <- lm(formula = low ~ open + lastday.close + lastday.high +lastday.volume + lastday.low +fivedayema+thirtydayema + openratio, data = traindatanormalized)
  regression_model_volat <- lm(formula = volat ~ open + lastday.volume + lastday.close + lastday.high +lastday.low +fivedayema+thirtydayema + openratio, data = traindatanormalized)
  models <- list(regression_model_high,regression_model_low,regression_model_volat)
  average_volat <- sum(data$volat)/nrow(data)
  return(list(models,prediction_data,average_volat))
}


retreive_high_low <- function(symbol){
  data <- dataframe(symbol)
  print("1")
  regression_models <- train_models(symbol,data)
  print("2")
  regression_model_high <- regression_models[[1]][[1]]
  regression_model_low <- regression_models[[1]][[2]]
  regression_model_volat <- regression_models[[1]][[3]]
  lastrow <- regression_models[2]
  av.volat <- regression_models[[3]]
  print("3")
  print(regression_models[4])
  prediction_frame <- lastrow[[1]]
  prediction_frame$lastday.vol <- prediction_frame$vol
  prediction_frame$lastday.close <- prediction_frame$close
  prediction_frame$lastday.high <- prediction_frame$high
  prediction_frame$lastday.low <- prediction_frame$low
  print(prediction_frame)
  prediction_frame$open <- getQuote(symbol, src = "yahoo")$Open
  prediction_frame$open <- normalize_special(prediction_frame$open,data$open)
  prediction_frame <- prediction_frame[,c(1,7:18,19,20)]
  print(prediction_frame)
  
  predicted_high <- predict(regression_model_high,prediction_frame)
  predicted_low <- predict(regression_model_low,prediction_frame)
  predicted_volat <- predict(regression_model_volat,prediction_frame)
  
  result.high.norm <- predicted_high[1]
  result.low.norm <- predicted_low[1]
  result.volat.norm <- predicted_volat[1]
  
  result.high <- denormalizedataframe(result.high.norm, data$high)
  result.low<- denormalizedataframe(result.low.norm, data$low)
  result.volat<- denormalizedataframe(result.volat.norm, data$volat)
  
   result.high <- round(result.high, digits=0)
  result.low<- round(result.low, digits=0)
  result.volat<- round(result.volat, digits=0)
 
  print(predicted_high)
  print(result.high)
  print(result.low)
  print(result.volat)
  package <- list(result.high,result.low,result.volat,av.volat)
  return(package)
}
