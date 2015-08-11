#this function takes a url, reads it and returns a clean data set with address, neighborhood, squared meters, currency and price

#xpathSApply
library(XML)
library(httr)
library(reshape2)

#url = "http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ1"
url.to.dataset = function(url){
  #Usando XML
  html = htmlTreeParse(url,useInternalNodes = T)
  
  #Esto me da todas las direcciones
  direcciones= xpathSApply(html,"//h2",xmlValue)
  Encoding(direcciones)<-"UTF-8"
  
  #Esto me da los detalles
  precios = xpathSApply(html,"//div[@class='pricesContainer listing']",xmlValue)
  
  #Info
  data = xpathSApply(html,"//p[@class='items']",xmlValue)
  Encoding(data)<-"UTF-8"
  

  largoValido = length(precios)
  if (!(
    identical(length(precios),length(data)))
  ){data = data[1:largoValido]}
  
  if (!(
    identical(length(precios),length(direcciones)))
  ){direcciones = direcciones[1:largoValido]}
  
  
  
  
  #Limpieza precios
  precios = gsub("Â","",precios)
  precios = gsub(" ","",precios)
  #eliminar el caracter raro del principio que no es espacio
  x = substr(precios[1],1,1)
  precios = gsub(paste(x),"",precios)
  
  precios = gsub("U$S","dolares;",precios,fixed = T)
  precios = gsub("$","pesos;",precios,fixed = T)
  precios = gsub(".","",precios,fixed = T)
  
  #Metraje y dormitorios de las propiedades
  #Hay propiedades sin metraje
  data = unlist(strsplit(data, "\r\n"))
  #data = data[grep("|",data,fixed = T)]
  data = gsub(".","",data,fixed = T)
  
  #limpieza direcciones
  direcciones = gsub("- -","-",direcciones)
  direcciones = gsub(" - Capital Federal","",direcciones)
  
  #armado de precios en dataframe
  precios = data.frame(precios)
  precios = colsplit(precios$precios,";",c("moneda","precio"))
  
  #armado de data en dataframe
  
  dataConMetraje = grepl(",00",data)
  data[!dataConMetraje] = "NA,"
  data = data.frame(data)
  data = colsplit(data$data,",",c("metraje","residuos"))
  
  data = data.frame(metraje = data$metraje)
  
  #armado de direcciones en dataframe
  direcciones = data.frame(direcciones)
  direcciones = colsplit(direcciones$direcciones," - ",c("direccion","barrio"))
  
  #armado de base final
  base=cbind(direcciones,data,precios)
  duplicados = duplicated(base[,c("direccion","metraje","moneda","precio")])
  base = base[!duplicados,]
  base
  
}
