#library(rdao)
f<-connectionFactory()
b<-f$dbFile("/Users/cnitz/Dev/R/rdao/db files external/test.db")
cnn<-b$build()

result<-cnn$createQuery(sql = "Select carat,color FROM diamonds LIMIT 10")$fetch()
result$countRows()
result$getColor()
m<-result$toMatrix()
d<-m(1,1:2)
d
result$setColor("xxx")
result$getColor()
result$update()

m<-result$toMatrix()

d<-m(1,1:2)
colnames(d)
d[1,]

m(2)
m(1,1:2)

result$getRecords()
result$setCarat(0.66)
result$row(1)$setCarat(0.99)
m(1:2,1:2)

result$getRecords()
result$delete(c(1,2))
result$countRows()
result$getRecords()


while (result$read()){
  
  i<-result$getRecords()
  print(i)
}