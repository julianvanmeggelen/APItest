my_packages <- c("plumber","quantmod")
 install_if_missing <- function(p) {
 if(p %in% rownames(installed.packages())==FALSE){
 install.packages(p)}
 }
