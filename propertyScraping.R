#Zona prop

rm(list=ls())

source("urlToDataset.R")
source("emptyProperties.R")

basesPosibles = data.frame(operacion = c(rep("venta",3),rep("alquiler",3)),
                           tipoPropiedad = rep(c("departamento","casa","ph"),2),
                           url=c(
                             "http://propiedades.zonaprop.com.ar/venta-departamentos-capital-federal/ncZ1_opZtipo-operacion-venta_lnZ3642_pnZ",
                             "http://propiedades.zonaprop.com.ar/venta-casas-capital-federal/ncZ2_opZtipo-operacion-venta_lnZ3642_pnZ",
                             "http://propiedades.zonaprop.com.ar/venta-ph-capital-federal/ncZ3_opZtipo-operacion-venta_lnZ3642_pnZ",
                             "http://propiedades.zonaprop.com.ar/alquiler-departamentos-capital-federal/ncZ1_opZtipo-operacion-alquiler_lnZ3642_pnZ",
                             "http://propiedades.zonaprop.com.ar/alquiler-casas-capital-federal/ncZ2_opZtipo-operacion-alquiler_lnZ3642_pnZ",
                             "http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ"
                             )
                           )

operaciones = unique(basesPosibles$operacion)
tipoPropiedades = unique(basesPosibles$tipoPropiedad)
urls = basesPosibles$url

base = data.frame(direccion = NA,
                  barrio = NA,
                  metraje = NA,
                  moneda = NA,
                  precio = NA,
                  operacion = NA,
                  tipoPropiedad = NA,
                  fecha = NA)

for (i in operaciones) {
  for (j in tipoPropiedades){
    for (k in urls){
      for (l in 1:10) {
        #print(l)
        print(paste(i,j,l,sep="-"))
        url = paste(k,l,sep="")
        if (empty.properties(url)) {break}
        base2 = url.to.dataset(url)
        base2$operacion = i
        base2$tipoPropiedad = j
        base2$fecha = Sys.Date()
        base = rbind(base,base2)
        
      }  
    }
  }
}
base = base[-1,]

#Funcion original
for (i in 1:10000000) {
  print(i)
  #Alquiler PH
  url = paste("http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ",i,sep="")
  
  if (empty.properties(url)) {break}
  
  if (i==1){
    base = url.to.dataset(url)
  }
  base2 = url.to.dataset(url)
  base = rbind(base,base2)

  #Venta
  
  ##Departamento
  #http://propiedades.zonaprop.com.ar/venta-departamentos-capital-federal/ncZ1_opZtipo-operacion-venta_lnZ3642_pnZ1
  
  ##Casas
  #http://propiedades.zonaprop.com.ar/venta-casas-capital-federal/ncZ2_opZtipo-operacion-venta_lnZ3642_pnZ1
  
  ##Ph
  #http://propiedades.zonaprop.com.ar/venta-ph-capital-federal/ncZ3_opZtipo-operacion-venta_lnZ3642_pnZ2
  
  
  #Alquiler
  
  ##Departamento
  #http://propiedades.zonaprop.com.ar/alquiler-departamentos-capital-federal/ncZ1_opZtipo-operacion-alquiler_lnZ3642_pnZ2
  
  ##Casas
  #http://propiedades.zonaprop.com.ar/alquiler-departamentos-capital-federal/ncZ2_opZtipo-operacion-alquiler_lnZ3642_pnZ1
  
  ##Ph
  #http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ2
  
}


