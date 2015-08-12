#this function takes a url, reads it and returns a clean data set with address, neighborhood, squared meters, currency and price

#xpathSApply
library(XML)
library(httr)
library(reshape2)

#premium url = "http://propiedades.zonaprop.com.ar/venta-departamentos-capital-federal/ncZ1_opZtipo-operacion-venta_lnZ3642_pnZ1"
#regular url = "http://propiedades.zonaprop.com.ar/venta-departamentos-capital-federal/ncZ1_opZtipo-operacion-venta_lnZ3642_pnZ200"
url.to.dataset = function(url){
  #Usando XML
  html = htmlTreeParse(url,useInternalNodes = T)
  
  #Incluir una forma de detectar avisos PREMIUM
  premium = xpathSApply(html,"//table[@class='unidades']",xmlValue)
  esPremium = length(premium)>0
  
  if(esPremium){
    source("ToDatasetPremium.R")  
  } else {
    source("ToDatasetRegular.R") 
  }
  
  base
}
