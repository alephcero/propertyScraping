#Zona prop

rm(list=ls())

source("urlToDataset.R")
source("emptyProperties.R")

operaciones = c("venta","alquiler")
tipoPropiedades = c("departamento","casa","ph")

base = data.frame(direccion = NA,
                  barrio = NA,
                  metraje = NA,
                  moneda = NA,
                  precio = NA,
                  operacion = NA,
                  tipoPropiedad = NA,
                  fecha = as.Date(Sys.Date()))

for (operacion in operaciones) {
  for (tipoPropiedad in tipoPropiedades){
    for (k in 1:10000000) {
      #debuging
      #k = 11  
      #operacion = operaciones[1]
      #tipoPropiedad = tipoPropiedades[1]
        
      print(paste(operacion,tipoPropiedad,k,sep="-"))
      url = paste("http://propiedades.zonaprop.com.ar/",
                  operacion,
                  "-",
                  tipoPropiedad,
                  "-capital-federal/ncZ1_opZtipo-operacion-",
                  operacion,
                  "_lnZ3642_pnZ",
                  k,
                  sep="")
      
      if (empty.properties(url)) {break}
      base2 = url.to.dataset(url)
      base2$operacion = operacion
      base2$tipoPropiedad = tipoPropiedad
      base2$fecha = as.Date(Sys.Date())
      base = rbind(base,base2)
    }  
  }
}

base = base[-1,]

write.csv(base,"base.csv",row.names = FALSE)