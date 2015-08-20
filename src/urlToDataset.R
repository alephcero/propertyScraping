#This function takes a url from Zonaprop realestate site, reads it and returns a clean data set with address, neighborhood, squared meters, currency and price

#Load necessary libraries
library(XML)
library(httr)
library(reshape2)

url.to.dataset = function(url){
  #Parse the hmlt coded given as input
  html = htmlTreeParse(url,useInternalNodes = T)
  
  #Detects whether there is a PREMIUM add with different html classes
  premium = xpathSApply(html,"//table[@class='unidades']",xmlValue)
  esPremium = length(premium)>0
  
  if(esPremium){
    # originally source("src/ToDatasetPremium.R") but I must found a way in R to source and execute whithin a function a subrutine in other file
    # the Premium add subrutine
    
    #Get the adresses with neighbourhood
    direcciones = xpathSApply(html,"//div[@class='direccion-precio']",xmlValue)
    Encoding(direcciones)<-"UTF-8"
    
    #Deal with the special case of Palermo neighbourhood
    direcciones = gsub(" - Palermo\t"," - Capital Federal",direcciones,fixed = TRUE)
    
    #Remove the city name from addresses,
    direcciones = lapply(direcciones,function(x) {strsplit(x," - Capital Federal")[[1]][1]})
    direcciones = unlist(direcciones)
    
    #Remove unmanted strings
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
    
    #Splits the srting depending on the type of operation given by the url, 
    if(operacion=="venta"){
      premium = strsplit(premium,"Departamentos;Venta;")
    } else {
      premium = strsplit(premium,"Departamentos;Alquiler;")
    }
    
    # It is possible that within the address, two neighbourhoods are mentioned. This keeps the first, until the neighbourhood 
    # it's given by the addres it self
    
    for (i in 1:length(premium)) {
      premium[[i]] = premium[[i]][-1]
    }
    
    # remove the last character (";") and replaces with a unique separator for the latter column split 
    premium = sapply(premium,function(x){
      x = substr(x,1,(nchar(x)-1))
      gsub(";","separador",x,fixed=TRUE)
      }
    )
    
    # for every item creates a data.frame and splits the information into different elements
    premium = lapply(premium,function(x){
      x = unlist(x)  
      x = as.data.frame(x)
      x = colsplit(x$x,"separador",names = c("metraje","moneda","precio"))
      }
    )
    
    #Final structure of the dataset. The rest ar to be merged with this one
    base = data.frame(direccion = NA,
                      barrio = NA,
                      metraje = NA,
                      moneda = NA,
                      precio = NA
    )
    #For the address list:
    # Loops through the length of the premium adds, creates a dataframe for the addreses 
    # (repeated for each of the department whithin an under construction building) and splits the address in the proper address and the neighbourhood
    # binds the address set with the original premium set
    
    for (i in 1:length(premium)) {
      baseTemp = premium[[i]]
      baseDirecciones = data.frame(direcciones = rep(direcciones[i],nrow(baseTemp)))
      baseDirecciones = colsplit(baseDirecciones$direcciones," - ",c("direccion","barrio"))
      baseTemp = cbind(baseDirecciones,baseTemp)
      base = rbind(base,baseTemp)
    }
    
    #Binding produces a first row full of NAs
    base = base[-1,]

        #End of PREMIUM subrutine
    
  } else {
    # originally source("src/ToDatasetRegular.R.R") but I must found a way in R to source and execute whithin a function a subrutine in other file
    # the REGULAR add subrutine

    #Get the adresses with neighbourhood
    direcciones= xpathSApply(html,"//h2",xmlValue)
    Encoding(direcciones)<-"UTF-8"
    
    #Get the prices for every add
    precios = xpathSApply(html,"//div[@class='pricesContainer listing']",xmlValue)
    
    #Get the add info 
    data = xpathSApply(html,"//p[@class='items']",xmlValue)
    Encoding(data)<-"UTF-8"
    
    #For formating reasons the lists have different lengths. The one with the prices has the right amount of elements
    largoValido = length(precios)
    if (!(
      identical(length(precios),length(data)))
    ){data = data[1:largoValido]}
    
    if (!(
      identical(length(precios),length(direcciones)))
    ){direcciones = direcciones[1:largoValido]}
    
    
    
    
    #Remove unmanted strings
    precios = gsub("Â","",precios)
    precios = gsub(" ","",precios)
    
    #Some strange undetermined character whitin price list, detected and removed
    x = substr(precios[1],1,1)
    precios = gsub(paste(x),"",precios)
    
    precios = gsub("U$S","dolares;",precios,fixed = T)
    precios = gsub("$","pesos;",precios,fixed = T)
    precios = gsub(".","",precios,fixed = T)
    

    data = unlist(strsplit(data, "\r\n"))
    data = gsub(".","",data,fixed = T)
    
    #limpieza direcciones
    direcciones = gsub("- -","-",direcciones)
    direcciones = gsub(" - Capital Federal","",direcciones)
    
    #Creating prices data.frame
    precios = data.frame(precios)
    precios = colsplit(precios$precios,";",c("moneda","precio"))
    
    #Creating data.frame with the add info
    dataConMetraje = grepl(",00",data)
    data[!dataConMetraje] = "NA,"
    data = data.frame(data)
    data = colsplit(data$data,",",c("metraje","residuos"))
    
    data = data.frame(metraje = data$metraje)
    
    #Creating data.frame with the addresses
    direcciones = data.frame(direcciones)
    direcciones = colsplit(direcciones$direcciones," - ",c("direccion","barrio"))
    
    #final data set
    base=cbind(direcciones,data,precios)
    
  }

  base

}
