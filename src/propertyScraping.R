#Zona prop

source("src/urlToDataset.R")
source("src/emptyProperties.R")

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

#Cleaning "moneda" variable, removing unknown prizes 
rm(base2)

base$moneda[grepl("pesos",base$moneda)] = "pesos"
base$moneda[grepl("dolares",base$moneda)] = "dolares"
base$moneda[grepl("consultar",base$moneda)] = NA


base = base %>%
  mutate(moneda = factor(as.character(base$moneda))) %>%
  mutate(metraje = as.integer(as.character(base$metraje))) %>%
  mutate(precio = as.integer(as.character(base$precio)))

#This needs to be tested
duplicados = duplicated(base[,c("direccion","metraje","moneda","precio")])
base = base[!duplicados,]

base = base[-1,]

write.csv(base,"data/base.csv",row.names = FALSE)