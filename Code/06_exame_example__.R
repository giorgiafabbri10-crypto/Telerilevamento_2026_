library(terra)
setw("-/Desktop/")
# c://blablabla/lknlknlkn

getwd()
list.files()

rast("")

richat <- rast("richatstructure_oli_20260306.jpg")
richat <- flip(richat)
plot(richat)

png(figura.png")
plot(richat)
dev.off()

png("bande.png")
im.multiframe(2,1)
plot(richat[[1]])
plot([[2]])
dev.off()

