#noralize neighbourhood's names

#download data


library(maptools)
library(rgdal)
library(sp)
library(tmap)
library(dplyr)

#Loading shapes 
if (!file.exists("maps/barrios.shp")){
  download.file("https://recursos-data.buenosaires.gob.ar/ckan2/barrios/barrios.zip","maps/barrios.zip",method = "wget")
  unzip(zipfile = "maps/barrios.zip",exdir="maps")  
}
cabaMap = readOGR(dsn = "maps/", layer = "barrios")

#Loading data scrapped from realestate site Zonaprop 
if (!file.exists("base.csv")){
source("propertyScraping.R")
}
base = read.csv("base.csv")


#Loading neighbourhoods according to shapes dataset  
barrios = levels(cabaMap@data$BARRIO)
barrios = barrios[!(grepl("Dique|ESCOLLERA EXTERIOR",barrios))]


#Create a list of neighbourhoods to be replaced with the clean neighbourhoods and then to be added to the dataset. 
barriosInput = base$barrio#[1:1000]
barriosInput = toupper(barriosInput)

barriosNormalizados = barriosInput

#Replace neighbourhoods in the realestate dataset, with the "offical" neighbourhoods from the BA government's shapes 
# Loop through the offical neighbourhoods list and replace in the realestate dataset neighbourhood column with the offical neighbourhood, 
# whenever it's found in the original string

for (i in 1:length(barrios)) {
  barriosNormalizados[grepl(barrios[i],barriosInput)] = barrios[i]
}

rm(barriosInput)

#Addressing "non offical" neighbourhoods, and replacing them with the correct "offical" neighbourhood

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

#SAN NICOLAS con tilde
barriosNormalizados[grepl("SAN NICOLÁS",barriosNormalizados)] = "SAN NICOLAS"

#CATALINAS aca mezcla la boca con retiro
barriosNormalizados[grepl("CATALINAS",barriosNormalizados)] = "RETIRO"

#ABASTO 
barriosNormalizados[grepl("ABASTO",barriosNormalizados)] = "BALVANERA"

#ONCE 
barriosNormalizados[grepl("ONCE",barriosNormalizados)] = "BALVANERA"

#PARQUE CENTENARIO
barriosNormalizados[grepl("PARQUE CENTENARIO",barriosNormalizados)] = "CABALLITO"

#POMPEYA
barriosNormalizados[grepl("POMPEYA",barriosNormalizados)] = "NUEVA POMPEYA"

#VILLA GENERAL MITRE
barriosNormalizados[grepl("GENERAL MITRE|GRAL MITRE",barriosNormalizados)] = "VILLA GRAL. MITRE"


#add the clean neighbourghood list to the dataset
base$barriosNorm = barriosNormalizados

#detectar repetidos
#generate a data set for rent with the average cost for square meter
precioMetrosAlquiler = base %>%
  filter(!is.na(metraje) & !is.na(precio)) %>%
  filter(moneda=="pesos" & operacion=="alquiler") %>%
  mutate(precioNorm = (precio - mean(precio)) / sd(precio)) %>%
  mutate(metrajeNorm = (metraje - mean(metraje)) / sd(metraje)) %>%
  filter(metrajeNorm < 10 & precioNorm < 10 & metraje > 10 ) %>%
  mutate(precioMetro2 = precio/metraje) %>%
  group_by(barriosNorm) %>%
  summarize(mean=mean(precioMetro2))

names(precioMetrosAlquiler) = c("BARRIO","precioM2Alquiler")



cabaMap@data = left_join(cabaMap@data,precioMetrosAlquiler)

qtm(cabaMap,"precioM2Alquiler",fill.palette="Greens")

