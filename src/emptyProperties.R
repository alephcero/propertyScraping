#this script sets if the web page has no more properties on it
#example: "http://propiedades.zonaprop.com.ar/alquiler-ph-capital-federal/ncZ3_opZtipo-operacion-alquiler_lnZ3642_pnZ7"

empty.properties = function(url){
  html = htmlTreeParse(url,useInternalNodes = T)
  mensaje = xpathSApply(html,"//p[@class='titulo']",xmlValue)
  
  if(length(mensaje)==0){
    paginaVacia = FALSE
  }else{
    Encoding(mensaje)<-"UTF-8"
    paginaVacia = mensaje == "Lo sentimos, no hemos encontrado propiedades con los filtros de tu búsqueda."
    }
  paginaVacia
}

