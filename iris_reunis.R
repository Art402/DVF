# Base des iris
# A partir des bases Iris de chaque année, on fait une réunion en gros

options(scipen = 999) # pour ne pas avoir l'ecriture scientifique pour la valeur


w1 =read.table("IRISCaen2016.csv", sep=",",quote="", header=TRUE, fill = TRUE)
w2 =read.table("IRISCaen2017.csv", sep=",",quote="", header=TRUE, fill = TRUE)
w3 =read.table("IRISCaen2018.csv", sep=",",quote="", header=TRUE, fill = TRUE)
w4 =read.table("IRISCaen2019.csv", sep=",",quote="", header=TRUE, fill = TRUE)
w5 =read.table("IRISCaen2020.csv", sep=",",quote="", header=TRUE, fill = TRUE)


x = rbind(w1,w2,w3,w4,w5)
x = x[,c(1,2,8,9)] # On garde seulement les colonnes intéressantes

nrow(x)
head(x)
summary(x)

x$Code.commune = as.factor(x$Code.commune)
x$iris = as.character(x$iris)


length(unique(x$iris))
summary(x$iris)

Iriscomplet=c()

for (i in 1:nrow(x)) {
  if (nchar(x$iris[i])==3){
    x$iris[i] = paste("0",x$iris[i],sep="")
  }
  Iriscomplet[i] = paste(paste("14",x$Code.commune[i],sep=""),x$iris[i],sep="_")
}

x$iris = as.factor(x$iris)

Iriscomplet = as.factor(Iriscomplet)
summary(Iriscomplet)

base = cbind(x[,c(1,2)],Iriscomplet)
head(base)
nrow(base)

# On change le format de la date pour correspondre à l'autre database et simplifier la jointure
for (i in 1:nrow(base)) {
  base$Date.mutation[i] = paste(substr(base$Date.mutation[i],7,10),substr(base$Date.mutation[i],4,5),substr(base$Date.mutation[i],1,2),sep="-")
}

head(base)

# On enleve les données sans IRIS ie iris = 0

i=1
c=0
while (c != 241) {
  if (base$Iriscomplet[i] == "14118_0") {
    c=c+1
    base=base[c(-i),]
  } else {
    i=i+1
  }
}


head(base)
nrow(base)



base[base$Iriscomplet=="14118_0",]

length(base[base$Iriscomplet=="14118_0",1])

base[c(415:455),]

length(base[c(415:455),1])



write.csv(base,file="iris_caen.csv",quote = FALSE, row.names = FALSE)
