#Zona prop
#el conteo de paginas se acaba cuando aparece class="sin-resultado-msj"
#<div class="sin-resultado-msj">
#  <p class="titulo">
#    Lo sentimos, no hemos encontrado propiedades con l…


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

#Alquiler ph 251 propiedaes

rm(list=ls())

source("urlToDataset.R")
source("emptyProperties.R")

for (i in 1:10) {
  print(i)
  alquiler.ph = paste("http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ",i,sep="")
  
  if (empty.properties(alquiler.ph)) {break}
  
  if (i==1){
    base = url.to.dataset(alquiler.ph)
  }
  base2 = url.to.dataset(alquiler.ph)
  base = rbind(base,base2)

}


