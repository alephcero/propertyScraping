#rentMap


#Libreries
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
if (!file.exists("data/base.csv")){
  source("src/propertyScraping.R")
}
base = read.csv("data/base.csv")

source("src/neighbourhoodNames.R")


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
