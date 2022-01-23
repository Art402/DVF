library(ggmap)
library(ggplot2)
library(dplyr)
library(rjson)
library(jsonlite)
library(RCurl)
library(sjmisc)

options(scipen = 999) # pour ne pas avoir l'ecriture scientifique pour la valeur


# Code pour déterminer les IRIS des ventes à partir de la DVF pour les lier à la base mutations_d14
# en estimant que la date, le prix et le code communale suffisent à la jointure.
# On se limite à la ville de Caen pour l'étude en IRIS pour des raisons de temps d'éxécution.


## Attention ne pas executer, c'est trop long ##

# Code basé sur : https://pyris.datajazz.io/ (Utilisation API)
# et https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/API-data-access-r/

#Création de la fonction
IRISCaen = function(fichier,nomsortie){

  ptmall = proc.time() #Point de départ d'un timer
  
  w=read.table(fichier, sep="|",dec = ",",quote="", header=TRUE, fill = TRUE)
  nrow(w)
  head(w)
  w = w[,c(9,11,12,14,16,18,19,20)] #on garde les données qui nous intéressent.

  x = w[w$Commune=="CAEN",] #limitation à Caen
  head(x)
  tail(x)
  nrow(x)
  
  # Remove duplicate rows of the dataframe
  # Afin d'unifier les ventes comme la base mutation
  x = distinct(x)
  nrow(x)

  x[9,]
  # On utilse un site pour trouver l'IRIS à partir d'une adresse
  # On effectue donc une requête pour accéder au site
  # Puis on récupère le contenu de la page qui est au format Json

  # Base URL path
  base_url = "https://pyris.datajazz.io/api/search/?"

  iris=c()
  iriscomplet=c()
  type =c()
  citycode=c()
  for (i in 1:length(x[,1])){
    print(i)
    
    if (x[i,5] ==""){
      adresse=""
      iris[i] = 0
      iriscomplet[i]=0
      type[i]="ND"
      citycode[i]=paste(x[i,7],x[i,8],sep="")
    } else {
      nvoie = x[i,3]
      typevoie = x[i,4]
      if (is.na(nvoie)) {
        nvoie=""
      }
      if (nvoie==""){
        if (typevoie==""){
          adresse = x[i,5]
        } else {
          adresse  = paste(typevoie,x[i,5],sep=" ")
        }
      } else {
        adresse  = paste(nvoie,typevoie,x[i,5],sep=" ")
      }
      adresse
    }
  

    # full url
    full_url = paste0(base_url, paste("q=",adresse,"&citycode=",x[i,7],x[i,8],sep=""))
    full_url <- URLencode(full_url) # remplace les espaces par %20
    full_url
    # Convert JSON to data frame
    df <- fromJSON(getURL(full_url))
    df
    length(df)
    if(length(df)==1 | length(df)==0 ) {
      iris[i] = 0
      iriscomplet[i]=0
      type[i]="ND"
      citycode[i]=paste(x[i,7],x[i,8],sep="")
    } else {
      iris[i] = df$iris
      iriscomplet[i]=df$complete_code
      type[i]=df$type
      citycode[i]=df$citycode
    }
    
  }

  baseiris = data.frame(iris,iriscomplet,type)
  baseiris
  base = cbind(x,baseiris)
  base

  
  temp = paste(deparse(substitute(nomsortie)),".csv",sep="")
  write.csv(base,file=temp,quote = FALSE, row.names = FALSE)
  
  print(proc.time() - ptmall ) # Pour voir le temps d'éxécution 
}


IRISCaen("valeursfoncieres-2020.txt",IRISCaen2020)
IRISCaen("valeursfoncieres-2019.txt",IRISCaen2019)
IRISCaen("valeursfoncieres-2018.txt",IRISCaen2018)
IRISCaen("valeursfoncieres-2017.txt",IRISCaen2017)
IRISCaen("valeursfoncieres-2016.txt",IRISCaen2016)
