# Base des équipements
# Regroupement par type pour chaque IRIS sur Caen.

w=read.table("bpe19_ensemble.csv", sep=";",dec = ",",quote="", header=TRUE, fill = TRUE)
nrow(w)
head(w)

x = w[w$DEPCOM=="14118",] # On se limite à Caen
nrow(x)
head(x)
x = x[,c(4,6,7)] # On garde seulement les colonnes intéressantes
summary(x)
head(x)

length(unique(x$DCIRIS)) # 52 IRIS distincts

iris=unique(x$DCIRIS)
A=rep(0,52) # On regroupe les équipements par type.
B=rep(0,52)
C=rep(0,52)
D=rep(0,52)
E=rep(0,52)
F=rep(0,52)
G=rep(0,52)
Total=rep(0,52)



for (i in 1:nrow(x)){

  for (j in 1:52){
    
    if (x$DCIRIS[i] == iris[j]){
      
      if( substr(x$TYPEQU[i],1,1) == "A" ){
        A[j] = A[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "B" ){
        B[j] = B[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "C" ){
        C[j] = C[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "D" ){
        D[j] = D[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "E" ){
        E[j] = E[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "F" ){
        F[j] = F[j] + x$NB_EQUIP[i]
      }
      
      if( substr(x$TYPEQU[i],1,1) == "G" ){
        G[j] = G[j] + x$NB_EQUIP[i]
      }
      
      Total[j] = Total[j] + x$NB_EQUIP[i]
    }
    
  }
  
}  

base = data.frame(iris,A,B,C,D,E,F,G,Total)  
base  
  
sum(Total)
sum(x$NB_EQUIP)  


write.csv(base,file="bpe_groupe_iris.csv",quote = FALSE, row.names = FALSE)
