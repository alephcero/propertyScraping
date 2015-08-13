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