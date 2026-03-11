# stack
# sist rife

b2 <- im.import("sentinel.dolomites.b2.tif") # blue
b3 <- im.import("sentinel.dolomites.b3.tif") # green
b4 <- im.import("sentinel.dolomites.b4.tif") # red
b8 <- im.import("sentinel.dolomites.b8.tif") #NIR

sentinel <- c(b2, b3, b4, b8)

sentinel

#
im.ggplot(b8)

# RGB pllotting
sentinel <- c(b2, b3, b4, b8)

#Plotting by RGB schemes

# 1 = b2 blue
# 2 = b3 green
# 3 = b4 red
# 4 = b8 NIR

im.plotRGB(sentinel, r=3, g=2, b=1)
im.plotRGB(sentinel, r=4, g=3, b=2)
im.plotRGB(sentinel, r=3, g=4, b=2)
im.plotRGB(sentinel, r=2, g=4, b=3)

im.multiframe(1,2)
im.plotRGB(sentinel, r=3, g=4, b=2)
im.plotRGB(sentinel, r=2, g=4, b=3)

12 * 11 /2

# correlations
pairs(sentinel)
im.plotRGB(sentinel, r=2, g=4, b=3)
im.plotRGB(sentinel, r=2, g=3, b=4)
im.plotRGB(sentinel, r=2, g=4, b=1)

# Plotting in RGB via terra
plotRGB(sentinel, r=4, g=3, b=2, stretch="lin")
plotRGB(sentinel, r=4, g=3, b=2, stretch="hist")

# RGB plotting based on the ggplot package
im.ggplotRGB(sentinel, r=4, g=3, b=2)   (NON VA PER ADESSO)

# Simplify ypu code
im.plotRGB(sentinel, 3, 4, 2)












