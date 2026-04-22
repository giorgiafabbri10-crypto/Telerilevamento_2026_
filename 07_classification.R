# R code to for classifying images

library(terra)
library(imageRy)

setwd("tilde") -> in caso abbia salvato la foto nei download

detwd()
im.list()

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# classification

sun <- im.classify(sun, num_cluster=3)

?im.classify

sun <- im.classify(sun, num_cluster=3, seed=19)

# Grand Canyon classification

can <- im.import("dolansprings_oli_2013088_canyon_lrg.jpg")         

canc <- im.classify(can, num_cluster=4, seed=19)

# Classifying an image from internet
list.files()
rast() -> serve ad importare i files 

dji <- rast("https://zenodo.org/records/19660762")
dji <- flip(dji)

plot(dji)
djic <- im.classify(dji, num_cluster=3)

# Classifying Mato Grosso data
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")

im.multiframe(1,2)
plot(m1992)
plot(m2006)

m1992c <- im.classify(m1992, num_cluster=2, seed=19)
m2006 <- im.classify(m2006, num_cluster=2, seed=19)

levels(m1992c) <- data.frame(
  value = c(1,2),
  label = c("forest", "human")
)
m1992c 
  
levels(m2006c) <- data.frame(
  value = c(1,2),
  label = c("forest", "human")
)
m2006c 

# percentages
freq1992 <- freq(m1992c)
freq1992

freq1992 <- freq(m1992c)

prop1992 <- freq1992$count *100 / ncell(m1992c)

freq2006 <- freq(m2006c)
freq2006

freq2006 <- freq(m2006c)

prop2006 <- freq2006$count *100 / ncell(m2006c)

# creating table
tabout <- data.frame(
  class=c"Forest", "Human"
  perc1992=c(83,17),
  perc2006=c(45,55)
)  









  







