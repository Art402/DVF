#Ajout variable jardin a la base "finale"
# issue de la jointure faite sur talend des bases mutation_caen.csv, iris_caen.csv et bpe_groupe_iris.csv
# produites en amont avec les autres codes R.

w=read.table("base.csv", sep=";",dec = ",",quote="", header=TRUE, fill = TRUE)
nrow(w)
head(w)

summary(w$typebien)
w$typebien = as.factor(w$typebien)

w$sbati = as.numeric(w$sbati)
w$surfaceterrain = as.numeric(w$surfaceterrain)
summary(w)

# Jardin si presence de batiment avec une surface terrain
# 1 = jardin, 0 = pas jardin.
jardin = c()
for (i in 1:nrow(w)) {
  if ( w$sbati[i] > 0 && w$surfaceterrain[i] >0) {
    jardin[i] = 1
  } else {
    jardin[i] = 0
  }
}


base = cbind(w,jardin)
head(base)

write.csv(base,file="projet_base.csv",quote = FALSE, row.names = FALSE)
