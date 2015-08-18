#noralize neighbourhood's names

#download data


library(maptools)
library(rgdal)
library(sp)
library(tmap)
library(dplyr)

if (!file.exists("maps/barrios.shp")){
  download.file("https://recursos-data.buenosaires.gob.ar/ckan2/barrios/barrios.zip","maps/barrios.zip",method = "wget")
  unzip(zipfile = "maps/barrios.zip",exdir="maps")  
}

base = read.csv("base.csv")
base$moneda[grepl("pesos",base$moneda)] = "pesos"
base$moneda[grepl("dolares",base$moneda)] = "dolares"

cabaMap = readOGR(dsn = "maps/", layer = "barrios")

#Normalize Palermo in one 


barrios = levels(cabaMap@data$BARRIO)
barrios = barrios[!(grepl("Dique|ESCOLLERA EXTERIOR",barrios))]



barriosInput = base$barrio#[1:1000]
barriosInput = toupper(barriosInput)



barriosNormalizados = barriosInput

#barriosNormalizados[grepl(barrios[22],barriosInput)] = barrios[22]



for (i in 1:length(barrios)) {
  barriosNormalizados[grepl(barrios[i],barriosInput)] = barrios[i]
}

#Barrios "no oficiales"
#BARRIO NORTE
barriosNormalizados[grepl("BARRIO NORTE",barriosNormalizados)] = "RECOLETA"

#MICROCENTRO
barriosNormalizados[grepl("CENTRO|MICROCENTRO",barriosNormalizados)] = "SAN NICOLAS"

#LAS CAÑITAS 
barriosNormalizados[grepl("CAÑITAS",barriosNormalizados)] = "PALERMO"

#SAN CRISTÓBAL con tilde
barriosNormalizados[grepl("CRISTÓBAL",barriosNormalizados)] = "SAN CRISTOBAL"

#AGRONOMÍA con tilde
barriosNormalizados[grepl("AGRONOMÍA",barriosNormalizados)] = "AGRONOMIA"


#CATALINAS aca mezcla la boca con retiro
barriosNormalizados[grepl("CATALINAS",barriosNormalizados)] = "RETIRO"


#ABASTO aca mezcla la boca con retiro
barriosNormalizados[grepl("ABASTO",barriosNormalizados)] = "BALVANERA"


#ONCE aca mezcla la boca con retiro
barriosNormalizados[grepl("ONCE",barriosNormalizados)] = "BALVANERA"


#PARQUE CENTENARIO
barriosNormalizados[grepl("PARQUE CENTENARIO",barriosNormalizados)] = "CABALLITO"

#POMPEYA
barriosNormalizados[grepl("POMPEYA",barriosNormalizados)] = "NUEVA POMPEYA"


#VILLA GENERAL MITRE
barriosNormalizados[grepl("GENERAL MITRE|GRAL MITRE",barriosNormalizados)] = "VILLA GRAL. MITRE"



base$barriosNorm = barriosNormalizados


#definir outliers como el que pasa el p90 y eliminar

#falta dividir por operacion y moneda
precioMetros = base %>%
  mutate(metraje = as.integer(as.character(base$metraje))) %>%
  mutate(precio = as.integer(as.character(base$precio))) %>%
  filter(!is.na(metraje) & !is.na(precio)) %>%
  filter(moneda=="pesos" & operacion=="alquiler")%>%
  mutate(precioMetro2 = precio/metraje) %>%
  group_by(barriosNorm) %>%
  summarize(mean=mean(precioMetro2))



plot(cabaMap)

head(cabaMap@data)









#METODO LISTA
barriosNormalizados = lapply(barriosInput, 
                             function(x){
                               barrios[grep(x,barrios,fixed = TRUE)]
                             }
)

for (i in 1:length(barriosNormalizados)) {
  barriosNormalizados[[i]]=barriosNormalizados[[i]][1]
}

barriosNormalizados = unlist(barriosNormalizados)