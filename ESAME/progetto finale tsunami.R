# ============================================================
# PROGETTO DI TELERILEVAMENTO
# Analisi multitemporale di Ishinomaki
# Confronto Pre-Tsunami / Post-Tsunami
# Landsat 5 TM - 2010 vs 2011
# ============================================================


# ------------------------------------------------------------
# 1. CARICAMENTO DEI PACCHETTI
# ------------------------------------------------------------

library(terra)
library(viridis)
library(ggplot2)


# ------------------------------------------------------------
# 2. IMPOSTAZIONE DELLA CARTELLA DI LAVORO
# ------------------------------------------------------------


setwd("C:/Users/LEONOVO-I3/Documenti/progetto telerilevamento")
getwd()

list.files(pattern = "\\.TIF$", ignore.case = TRUE)


# ------------------------------------------------------------
# 3. CARICAMENTO DELLE BANDE LANDSAT 5
# PRE-TSUNAMI: 24/08/2010
# ------------------------------------------------------------

pre_b1 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B1.TIF")
pre_b2 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B2.TIF")
pre_b3 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B3.TIF")
pre_b4 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B4.TIF")

pre_stack <- c(pre_b1, pre_b2, pre_b3, pre_b4)

names(pre_stack) <- c("blue", "green", "red", "nir")


# ------------------------------------------------------------
# 4. CARICAMENTO DELLE BANDE LANDSAT 5
# POST-TSUNAMI: 05/04/2011
# ------------------------------------------------------------

post_b1 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B1.TIF")
post_b2 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B2.TIF")
post_b3 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B3.TIF")
post_b4 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B4.TIF")

post_stack <- c(post_b1, post_b2, post_b3, post_b4)

names(post_stack) <- c("blue", "green", "red", "nir")


# ------------------------------------------------------------
# 5. CONTROLLO DEL SISTEMA DI RIFERIMENTO
# ------------------------------------------------------------

crs(pre_stack)
crs(post_stack)


# ------------------------------------------------------------
# 6. VISUALIZZAZIONE DELLE IMMAGINI
# COMPOSIZIONE A FALSI COLORI 4-3-2
# ------------------------------------------------------------

par(mfrow = c(1, 2))

plotRGB(
  pre_stack,
  r = 4,
  g = 3,
  b = 2,
  stretch = "lin",
  main = "Pre-Tsunami (24/08/2010)"
)

plotRGB(
  post_stack,
  r = 4,
  g = 3,
  b = 2,
  stretch = "lin",
  main = "Post-Tsunami (05/04/2011)"
)


# ------------------------------------------------------------
# 7. DEFINIZIONE DELL'AREA DI STUDIO
# ISHINOMAKI
# CRS: EPSG:32654
# ------------------------------------------------------------

ext_ishi <- ext(
  515000,
  545000,
  4240000,
  4270000
)

pre_crop <- crop(pre_stack, ext_ishi)

post_crop <- crop(post_stack, ext_ishi)


# Controllo del crop

ext(pre_crop)

dim(pre_crop)

ncell(pre_crop)


# ------------------------------------------------------------
# 8. VISUALIZZAZIONE DELL'AREA DI STUDIO
# ------------------------------------------------------------

par(mfrow = c(1, 2))

plotRGB(
  pre_crop,
  r = 4,
  g = 3,
  b = 2,
  stretch = "lin",
  main = "Ishinomaki Pre-Tsunami"
)

plotRGB(
  post_crop,
  r = 4,
  g = 3,
  b = 2,
  stretch = "lin",
  main = "Ishinomaki Post-Tsunami"
)


# ------------------------------------------------------------
# 9. CALCOLO DELL'NDVI
#
# NDVI = (NIR - RED) / (NIR + RED)
#
# Landsat 5 TM:
# B3 = RED
# B4 = NIR
# ------------------------------------------------------------

ndvi_pre <- (
  pre_crop$nir - pre_crop$red
) / (
  pre_crop$nir + pre_crop$red
)

ndvi_post <- (
  post_crop$nir - post_crop$red
) / (
  post_crop$nir + post_crop$red
)


# ------------------------------------------------------------
# 10. VISUALIZZAZIONE DELL'NDVI
# ------------------------------------------------------------

par(mfrow = c(1, 2))

plot(
  ndvi_pre,
  col = viridis(100),
  main = "NDVI Pre-Tsunami (2010)"
)

plot(
  ndvi_post,
  col = viridis(100),
  main = "NDVI Post-Tsunami (2011)"
)


# ------------------------------------------------------------
# 11. STATISTICHE DELL'NDVI
# ------------------------------------------------------------

ndvi_stats_pre <- global(
  ndvi_pre,
  c("min", "max", "mean"),
  na.rm = TRUE
)

ndvi_stats_post <- global(
  ndvi_post,
  c("min", "max", "mean"),
  na.rm = TRUE
)

print(ndvi_stats_pre)

print(ndvi_stats_post)


# ------------------------------------------------------------
# 12. DIFFERENZA NDVI
# ΔNDVI = NDVI POST - NDVI PRE
# ------------------------------------------------------------

dndvi <- ndvi_post - ndvi_pre

dndvi_stats <- global(
  dndvi,
  c("min", "max", "mean"),
  na.rm = TRUE
)

print(dndvi_stats)


# Visualizzazione della differenza NDVI

par(mfrow = c(1, 1))

plot(
  dndvi,
  col = viridis(100),
  main = "Differenza NDVI (Post - Pre)"
)


# ------------------------------------------------------------
# 13. CLASSIFICAZIONE IN 3 MACRO-CLASSI
# BASATA SULL'NDVI
#
# Classe 1 = Acqua
# NDVI < 0
#
# Classe 2 = Suolo / Urbano
# 0 <= NDVI < 0.3
#
# Classe 3 = Vegetazione
# NDVI >= 0.3
# ------------------------------------------------------------

rcl_ndvi <- matrix(
  c(
    -Inf, 0,   1,
    0,   0.3, 2,
    0.3, Inf, 3
  ),
  ncol = 3,
  byrow = TRUE
)

class_ndvi_pre <- classify(
  ndvi_pre,
  rcl = rcl_ndvi
)

class_ndvi_post <- classify(
  ndvi_post,
  rcl = rcl_ndvi
)

names(class_ndvi_pre) <- "Classe"

names(class_ndvi_post) <- "Classe"


# ------------------------------------------------------------
# 14. VISUALIZZAZIONE DELLA CLASSIFICAZIONE
# ------------------------------------------------------------

par(mfrow = c(1, 2))

plot(
  class_ndvi_pre,
  col = viridis(100),
  main = "Classificazione Pre-Tsunami"
)

plot(
  class_ndvi_post,
  col = viridis(100),
  main = "Classificazione Post-Tsunami"
)


# ------------------------------------------------------------
# 15. CALCOLO DELLE FREQUENZE
# ------------------------------------------------------------

freq_ndvi_pre <- freq(class_ndvi_pre)

freq_ndvi_post <- freq(class_ndvi_post)

print(freq_ndvi_pre)

print(freq_ndvi_post)


# ------------------------------------------------------------
# 16. CALCOLO DELLE PERCENTUALI
# ------------------------------------------------------------

perc_ndvi_pre <- (
  freq_ndvi_pre$count /
    sum(freq_ndvi_pre$count)
) * 100

perc_ndvi_post <- (
  freq_ndvi_post$count /
    sum(freq_ndvi_post$count)
) * 100


# ------------------------------------------------------------
# 17. TABELLA RIASSUNTIVA
# ------------------------------------------------------------

tab_ndvi <- data.frame(
  Classe = c(
    "Acqua",
    "Suolo/Urbano",
    "Vegetazione"
  ),
  
  Pre_Tsunami = round(
    perc_ndvi_pre,
    2
  ),
  
  Post_Tsunami = round(
    perc_ndvi_post,
    2
  )
)

print(tab_ndvi)


# ------------------------------------------------------------
# 18. CALCOLO DELLA VARIAZIONE
# IN PUNTI PERCENTUALI
# ------------------------------------------------------------

variazione_classi <- data.frame(
  Classe = c(
    "Acqua",
    "Suolo/Urbano",
    "Vegetazione"
  ),
  
  Variazione = round(
    perc_ndvi_post - perc_ndvi_pre,
    2
  )
)

print(variazione_classi)


# ------------------------------------------------------------
# 19. CREAZIONE DEL DATAFRAME PER IL GRAFICO
# ------------------------------------------------------------

dati_grafico <- data.frame(
  
  Copertura = factor(
    c(
      "Acqua",
      "Suolo/Urbano",
      "Vegetazione",
      "Acqua",
      "Suolo/Urbano",
      "Vegetazione"
    ),
    
    levels = c(
      "Acqua",
      "Suolo/Urbano",
      "Vegetazione"
    )
  ),
  
  Periodo = factor(
    c(
      "Pre-Tsunami (2010)",
      "Pre-Tsunami (2010)",
      "Pre-Tsunami (2010)",
      "Post-Tsunami (2011)",
      "Post-Tsunami (2011)",
      "Post-Tsunami (2011)"
    ),
    
    levels = c(
      "Pre-Tsunami (2010)",
      "Post-Tsunami (2011)"
    )
  ),
  
  Percentuale = c(
    perc_ndvi_pre,
    perc_ndvi_post
  )
)


# ------------------------------------------------------------
# 20. GRAFICO FINALE
# ------------------------------------------------------------

ggplot(
  dati_grafico,
  aes(
    x = Copertura,
    y = Percentuale,
    fill = Periodo
  )
) +
  
  geom_bar(
    stat = "identity",
    position = position_dodge(0.9),
    color = "black",
    width = 0.7
  ) +
  
  geom_text(
    aes(
      label = paste0(
        round(Percentuale, 2),
        "%"
      )
    ),
    
    position = position_dodge(0.9),
    
    vjust = -0.4,
    
    size = 3.8
  ) +
  
  scale_fill_manual(
    values = c(
      "Pre-Tsunami (2010)" = "purple",
      "Post-Tsunami (2011)" = "yellow"
    )
  ) +
  
  ylim(0, 65) +
  
  theme_bw() +
  
  labs(
    title = "Variazione della Copertura del Suolo a Ishinomaki",
    subtitle = "Confronto multitemporale Landsat 5 TM (2010 vs 2011)",
    x = "Tipologia di Copertura",
    y = "Copertura (%)",
    fill = "Periodo"
  ) +
  
  theme(
    plot.title = element_text(
      face = "bold",
      size = 14
    ),
    
    axis.text = element_text(
      size = 10
    ),
    
    legend.position = "top"
  )


# ============================================================
# FINE DEL CODICE


