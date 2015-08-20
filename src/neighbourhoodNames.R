#noralize neighbourhood's names according to the "official" BA's government 


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


