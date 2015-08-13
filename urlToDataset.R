#this function takes a url, reads it and returns a clean data set with address, neighborhood, squared meters, currency and price

#xpathSApply
library(XML)
library(httr)
library(reshape2)

url.to.dataset = function(url){
  #Usando XML
  html = htmlTreeParse(url,useInternalNodes = T)
  
  #Incluir una forma de detectar avisos PREMIUM
  premium = xpathSApply(html,"//table[@class='unidades']",xmlValue)
  esPremium = length(premium)>0
  
  if(esPremium){
    #source("ToDatasetPremium.R")
    #Esto me da todas las direcciones
    direcciones = xpathSApply(html,"//div[@class='direccion-precio']",xmlValue)
    Encoding(direcciones)<-"UTF-8"
    direcciones = gsub(" - Palermo\t"," - Capital Federal",direcciones,fixed = TRUE)
    direcciones = lapply(direcciones,function(x) {strsplit(x," - Capital Federal")[[1]][1]})
    direcciones = unlist(direcciones)
    direcciones = gsub("\r\n\t\t","",direcciones,fixed = TRUE)
    
    premium = gsub("Â.","",premium)
    premium = gsub("\r",";",premium)
    premium = gsub("\n","",premium)
    premium = gsub("\t","",premium)
    premium = gsub("[0-9] amb.;","",premium)
    premium = gsub("5 o mÃ¡s amb.;","",premium)
    
    premium = gsub("desde","",premium,fixed = TRUE)
    premium = gsub("hasta.U\\$S [0-9]+.[0-9]+;","",premium)
    premium = gsub("hasta;\\$ [0-9]+.[0-9]+.[0-9]+;","",premium)
    premium = gsub("U$S ","dolares;",premium,fixed = TRUE)
    premium = gsub("$ ","pesos;",premium,fixed = TRUE)
    premium = gsub(",[0-9][0-9] m2","",premium)
    premium = gsub(".","",premium,fixed = TRUE)
    premium = gsub('([;])\\1+', '\\1',premium)
    if(operacion=="venta"){
      premium = strsplit(premium,"Departamentos;Venta;")
    } else {
      premium = strsplit(premium,"Departamentos;Alquiler;")
    }
    
    for (i in 1:length(premium)) {
      premium[[i]] = premium[[i]][-1]
    }
    
    premium = sapply(premium,function(x){
      x = substr(x,1,(nchar(x)-1))
      gsub(";","separador",x,fixed=TRUE)
      }
    )
    
    premium = lapply(premium,function(x){
      x = unlist(x)  
      x = as.data.frame(x)
      x = colsplit(x$x,"separador",names = c("metraje","moneda","precio"))
      }
    )
    
    #Base final es direccion barrio metraje moneda precio
    base = data.frame(direccion = NA,
                      barrio = NA,
                      metraje = NA,
                      moneda = NA,
                      precio = NA
    )
    
    for (i in 1:length(premium)) {
      baseTemp = premium[[i]]
      baseDirecciones = data.frame(direcciones = rep(direcciones[i],nrow(baseTemp)))
      baseDirecciones = colsplit(baseDirecciones$direcciones," - ",c("direccion","barrio"))
      baseTemp = cbind(baseDirecciones,baseTemp)
      base = rbind(base,baseTemp)
    }
    base = base[-1,]
  } else {
    #source("ToDatasetRegular.R") 
    
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
    
  }
  duplicados = duplicated(base[,c("direccion","metraje","moneda","precio")])
  base = base[!duplicados,]

  base

}
