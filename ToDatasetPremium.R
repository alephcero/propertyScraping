#url ToDataset Premium




#Esto me da todas las direcciones
direcciones = xpathSApply(html,"//div[@class='direccion-precio']",xmlValue)
Encoding(direcciones)<-"UTF-8"


#Adapto el largo de las direcciones al largo de premium que es el correcto
largoValido = length(premium)
if (!(
  identical(length(direcciones),length(premium)))
){direcciones = direcciones[1:largoValido]}

#tratamiento de direcciones
#Si la direccion tiene "desde" es que adentro del anuncio hay mas de una vivienda
direcciones = gsub("\r",";",direcciones)
direcciones = gsub("\n","",direcciones)
direcciones = gsub("\t","",direcciones)
direcciones = gsub('([;])\\1+', '\\1',direcciones)
direcciones = gsub(" - Capital Federal","",direcciones)


#tratamiento de precios y data premium
premium = gsub("\r",";",premium)
premium = gsub("\n","",premium)
premium = gsub("\t","",premium)
premium = gsub('([;])\\1+', '\\1',premium)
#Cada item puede tener uno o mas departamentos
caca = strsplit(premium,"Departamentos;Venta")
#Esto me divide varios subitems de una lista, el primero siempre es ""

#Si tiene dos departamentos se replica la informacion 
