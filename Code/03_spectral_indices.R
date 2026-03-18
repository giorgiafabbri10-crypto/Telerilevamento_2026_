library(terra)
library(imageRy)
library(viridis)

#listing files
im.list()

#importing data
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 <- flip(mato1992)
# l1=NIR, l2=red, l3=green
im.plotRGB(mato1992, r=1, g=2, b=3)

per aumentare la visualizzazione della vegetazione 
im.plotRGB(mato1992, r=2, g=1, b=3)

per aumentare la percezione del suolo nudo
im.plotRGB(mato1992, r=2, g=3, b=1)

mato2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 <- flip(mato2006)
im.plotRGB(mato2006, r=1, g=2, b=3)

#Exercise: plot the two images one beside the other using im.multiframe()
im.multiframe(1, 2)
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato2006, r=1, g=2, b=3)

im.multiframe(1, 2)
im.plotRGB(mato1992, r=3, g=2, b=1)
im.plotRGB(mato2006, r=3, g=2, b=1)

come si misura la biomassa? (riflettanza)
# DVI
# 0-100
# NIR=100 red=0
# dvi_t0 = NIR - red = 100 - 0 = 100
# dvi_t1 = NIR - red = 40 - 10 = 30

# DVI
dvi1992
# l1=NIR, l2=red, l3=green
# DVI = NIR - red
dvi1992 = mato1992[[1]] - mato1992[[2]]
dvi2006 = mato2006[[1]] - mato2006[[2]]

plot(dvi1992)
plot(dvi2006)

plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

dev.off() calcella 

bit = informazione singola. come può essere questa informazione? o 0 o 1. 

# DVI with different radiometric resolution
cosa sappiamo noi? risoluzione spaziale (pixel), spettrale (n° di bande) e radiometrica(n° di bit)

# 8 bit - 0 - 255
# DVI = NIR-red = 255 - 0 = 255 #min DVI
# DVI = NIR-red = 0 - 255 =-255 # max DVI

# 2 bit -> 0 - 3
# DVI = NIR-red = 3 - 0 = 3 #min DVI
# DVI = NIR-red = 0 - 3 =-3 # max DVI

NDVI = 

# 8 bit - 0 - 255
# DVI = (NIR-red) / (NIR+red)= (255 - 0) / (255+0) = 1 #min DVI
# DVI = (NIR-red) / (NIR+red) = (0 - 255) / (0 + 255) =-1 # max DVI

# 2 bit -> 0 - 3
# DVI = (NIR-red) / (NIR+red) = (3 - 0) / (3+0) = 3 #min DVI
# DVI = (NIR-red) / (NIR+red) = (0 - 3) / (0+3) =-3 # max DVI

# NDVI 1992
ndvi1992 = dvi1992 / (mato1992[[1]] + mato1992[[2]]
                      
# NDVI 2006
ndvi2006 = dvi2006 / (mato2006[[1]] + mato2006[[2]]

im.multiframe(2,2)
plot(dvi1992)
plot(dvi2006)
ndiv(ndvi1992)                      
ndvi(ndvi2006)

# DVI with imageRy
# l1=NIR, L2=red, l3=green
dvi1992 = im.dvi(mato1992, 1, 2)
dvi2006 = im.dvi(mato2006, 1, 2)
plot(dvi1992)
plot(dvi2006)
                      
# NDVI with imageRy
# l1=NIR, L2=red, l3=green
ndvi1992 = im.ndvi(mato1992, 1, 2)
ndvi2006 = im.ndvi(mato2006, 1, 2)
plot(ndvi1992)
plot(ndvi2006)                      
