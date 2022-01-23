# Base des mutations
# Nettoyage de la base simplifiée dvf ( celle trouvée par Benjamin )

w=read.table("mutations_d14.csv", sep=";",dec = ",",quote="", header=TRUE, fill = TRUE)
nrow(w)
head(w)


x = w[,c(7,12,13,17,25,29,30,31,32,43,58)] # On garde seulement les colonnes intéressantes



x = x[x$l_codinsee=="['14118']",] # On se limite à Caen
x = x[x$vefa=="False",] # On ecarte les ventes en etat futur d'achevement car pas de surface donnee
x = x[,c(-2)]
nrow(x)
head(x)
summary(x)

x$valeurfonc = as.integer(x$valeurfonc)
x$sterr = as.integer(x$sterr)
x$sbati = as.integer(x$sbati)


# reecriture du code commune
for (i in 1:nrow(x)) {
  x$l_codinsee[i] = substr(x$l_codinsee[i],3,7)
}

head(x)
write.csv(x,file="mutation_caen.csv",quote = FALSE, row.names = FALSE)
