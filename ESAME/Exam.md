# Analisi dell'Impatto dello Tsunami del 2011 a Ishinomaki (Giappone) tramite Dati Satellitari Landsat 5 TM

**Candidato:** Giorgia Fabbri  
**Corso:** Telerilevamento Geo-Ecologico  
**Anno Accademico:** 2025/2026

---

## 1. Introduzione e Area di Studio

L'11 marzo 2011 un terremoto sottomarino di magnitudo 9.0 ha colpito la costa nord-orientale del Giappone (regione del Tōhoku), innescando un violento tsunami. La città costiera di **Ishinomaki** (Prefettura di Miyagi), attraversata dalla foce del fiume Kitakami, è stata una delle aree più devastate dall'inondazione marina.

L'obiettivo di questo progetto è monitorare e quantificare le variazioni della copertura del suolo e lo stato della vegetazione pre e post-evento tramite tecniche di telerilevamento multispettrale.

### Dati Satellitari Utilizzati
I dati sono stati acquisiti dal sensore **Thematic Mapper (TM)** a bordo del satellite **Landsat 5** (risoluzione spaziale a terra di 30 metri per le bande ottiche):
* **Immagine Pre-evento:** 24 Agosto 2010 (Path: 107, Row: 033)
* **Immagine Post-evento:** 5 Aprile 2011 (Path: 107, Row: 033)

---

## 2. Configurazione dell'Ambiente di Lavoro

Per l'analisi sono stati utilizzati i pacchetti `terra` (gestione dei dati spaziali raster), `imageRy` (funzioni avanzate di telerilevamento e classificazione), `viridis` (palette cromatiche scientifiche) e `ggplot2` (statistica e visualizzazione dati).

```R
library(terra)
library(imageRy)
library(viridis)
library(ggplot2)

setwd("C:/Users/LEONOVO-I3/Desktop/progetto telerilevamento")

# Pre-Tsunami (24/08/2010)
pre_b1 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B1.TIF")
pre_b2 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B2.TIF")
pre_b3 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B3.TIF")
pre_b4 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B4.TIF")
pre_stack <- c(pre_b1, pre_b2, pre_b3, pre_b4)
names(pre_stack) <- c("blue", "green", "red", "nir")

# Post-Tsunami (05/04/2011)
post_b1 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B1.TIF")
post_b2 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B2.TIF")
post_b3 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B3.TIF")
post_b4 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B4.TIF")
post_stack <- c(post_b1, post_b2, post_b3, post_b4)
names(post_stack) <- c("blue", "green", "red", "nir")

ext_ishi <- ext(515000, 545000, 4240000, 4270000)
pre_crop  <- crop(pre_stack, ext_ishi)
post_crop <- crop(post_stack, ext_ishi)

# Confronto in Falso Colore (RGB 4-3-2)
par(mfrow = c(1, 2))
plotRGB(pre_crop, r = 4, g = 3, b = 2, stretch = "lin", main = "Ishinomaki Pre-Tsunami")
plotRGB(post_crop, r = 4, g = 3, b = 2, stretch = "lin", main = "Ishinomaki Post-Tsunami")

# Calcolo NDVI
ndvi_pre  <- (pre_crop$nir - pre_crop$red) / (pre_crop$nir + pre_crop$red)
ndvi_post <- (post_crop$nir - post_crop$red) / (post_crop$nir + post_crop$red)

# Visualizzazione
cl_ndvi <- colorRampPalette(c("brown", "yellow", "darkgreen"))(100)
par(mfrow = c(1, 2))
plot(ndvi_pre, col = cl_ndvi, main = "NDVI Pre-Tsunami (2010)")
plot(ndvi_post, col = cl_ndvi, main = "NDVI Post-Tsunami (2011)")

dndvi <- ndvi_post - ndvi_pre
par(mfrow = c(1, 1))
plot(dndvi, col = viridis(100), main = "Differenza NDVI (Post - Pre)")

set.seed(42)
class_pre  <- im.classify(pre_crop, num_clusters = 3)
class_post <- im.classify(post_crop, num_clusters = 3)

par(mfrow = c(1, 2))
plot(class_pre, main = "Classificazione Pre-Tsunami")
plot(class_post, main = "Classificazione Post-Tsunami")

freq_pre  <- freq(class_pre)
freq_post <- freq(class_post)

perc_pre  <- (freq_pre$count / sum(freq_pre$count)) * 100
perc_post <- (freq_post$count / sum(freq_post$count)) * 100

tab_confronto <- data.frame(
  Classe = 1:3,
  Perc_Pre = round(perc_pre, 2),
  Perc_Post = round(perc_post, 2)
)
print(tab_confronto)

copertura <- c("Vegetazione", "Acqua", "Urbano/Suolo", 
               "Vegetazione", "Acqua", "Urbano/Suolo")
periodo   <- c("Pre", "Pre", "Pre", 
               "Post", "Post", "Post")
percentuali <- c(37.70, 36.31, 26.00, 
                 35.37, 64.63, 0.00)

dati_grafico <- data.frame(copertura, periodo, percentuali)

ggplot(dati_grafico, aes(x = copertura, y = percentuali, fill = periodo)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Pre" = "darkgreen", "Post" = "red")) +
  labs(
    title = "Confronto Copertura Ishinomaki",
    x = "Copertura del suolo",
    y = "Percentuale (%)"
  )






















library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
setwd("C:/Users/LEONOVO-I3/Desktop/progetto telerilevamento")
list.files(pattern="\\.TIF$", ignore.case=TRUE)
getwd()
list.files()
list.files(pattern="tif", ignore.case=TRUE)
pre_b1 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B1.TIF")
pre_b2 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B2.TIF")
pre_b3 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B3.TIF")
pre_b4 <- rast("LT05_L1TP_107033_20100824_20200823_02_T1_B4.TIF")
pre_stack <- c(pre_b1, pre_b2, pre_b3, pre_b4)
names(pre_stack) <- c("blue", "green", "red", "nir")
post_b1 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B1.TIF")
post_b2 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B2.TIF")
post_b3 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B3.TIF")
post_b4 <- rast("LT05_L1TP_107033_20110405_20200823_02_T1_B4.TIF")
post_stack <- c(post_b1, post_b2, post_b3, post_b4)
names(post_stack) <- c("blue", "green", "red", "nir")
par(mfrow = c(1, 2))
plotRGB(pre_stack, r = 4, g = 3, b = 2, stretch = "lin", main = "Pre-Tsunami (24/08/2010)")
plotRGB(post_stack, r = 4, g = 3, b = 2, stretch = "lin", main = "Post-Tsunami (05/04/2011)")
ext_ishi <- ext(515000, 545000, 4240000, 4270000)
pre_crop  <- crop(pre_stack, ext_ishi)
post_crop <- crop(post_stack, ext_ishi)
par(mfrow = c(1, 2))
plotRGB(pre_crop, r = 4, g = 3, b = 2, stretch = "lin", main = "Ishinomaki Pre-Tsunami")
plotRGB(post_crop, r = 4, g = 3, b = 2, stretch = "lin", main = "Ishinomaki Post-Tsunami")
ndvi_pre  <- (pre_crop$nir - pre_crop$red) / (pre_crop$nir + pre_crop$red)
ndvi_post <- (post_crop$nir - post_crop$red) / (post_crop$nir + post_crop$red)
cl_ndvi <- colorRampPalette(c("brown", "yellow", "darkgreen"))(100)

par(mfrow = c(1, 2))
plot(ndvi_pre, col = cl_ndvi, main = "NDVI Pre-Tsunami (2010)")
plot(ndvi_post, col = cl_ndvi, main = "NDVI Post-Tsunami (2011)")

CALCOLO E CONFRONTO ndvi

dndvi <- ndvi_post - ndvi_pre
par(mfrow = c(1, 1))
plot(dndvi, col = viridis(100), main = "Differenza NDVI (Post - Pre)")
set.seed(42)
class_pre  <- im.classify(pre_crop, num_clusters = 3)
class_post <- im.classify(post_crop, num_clusters = 3)

par(mfrow = c(1, 2))
plot(class_pre, main = "Classificazione Pre-Tsunami")
plot(class_post, main = "Classificazione Post-Tsunami")
freq_pre  <- freq(class_pre)
freq_post <- freq(class_post)

# Calcolo delle percentuali
perc_pre  <- (freq_pre$count / sum(freq_pre$count)) * 100
perc_post <- (freq_post$count / sum(freq_post$count)) * 100

# Tabella riassuntiva
tab_confronto <- data.frame(
  Classe = 1:3,
  Perc_Pre = round(perc_pre, 2),
  Perc_Post = round(perc_post, 2)
)
print(tab_confronto)
library(ggplot2)

# Creazione del dataframe per il grafico
dati_grafico <- data.frame(
  Copertura = c("Vegetazione", "Mare", "Suolo/Urbano", 
                "Vegetazione", "Aree Allagate", "Mare"),
  Periodo = c("Pre-Tsunami", "Pre-Tsunami", "Pre-Tsunami", 
              "Post-Tsunami", "Post-Tsunami", "Post-Tsunami"),
  Percentuale = c(37.70, 36.31, 26.00, 35.37, 26.36, 38.27)
)

# Plot a barre affiancate
ggplot(dati_grafico, aes(x = Copertura, y = Percentuale, fill = Periodo)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  scale_fill_manual(values = c("Pre-Tsunami" = "forestgreen", "Post-Tsunami" = "firebrick")) +
  labs(
    title = "Impatto dello Tsunami su Ishinomaki",
    x = "Copertura del Suolo",
    y = "Percentuale sull'Area di Studio (%)"
  )


forse..
# Dataframe coerente con le 3 macro-classi per entrambi i periodi
dati_grafico_v2 <- data.frame(
  Copertura = factor(
    c("Vegetazione", "Acqua / Allagato", "Suolo / Urbano",
      "Vegetazione", "Acqua / Allagato", "Suolo / Urbano"),
    levels = c("Vegetazione", "Acqua / Allagato", "Suolo / Urbano")
  ),
  Periodo = factor(
    c("Pre-Tsunami (2010)", "Pre-Tsunami (2010)", "Pre-Tsunami (2010)",
      "Post-Tsunami (2011)", "Post-Tsunami (2011)", "Post-Tsunami (2011)"),
    levels = c("Pre-Tsunami (2010)", "Post-Tsunami (2011)")
  ),
  Percentuale = c(37.70, 36.31, 26.00,
                  35.37, 64.63, 0.00)
)

# Plot a barre affiancate con etichette percentuali
ggplot(dati_grafico_v2, aes(x = Copertura, y = Percentuale, fill = Periodo)) +
  geom_bar(stat = "identity", position = position_dodge(0.9), color = "black", width = 0.7) +
  geom_text(aes(label = paste0(Percentuale, "%")), 
            position = position_dodge(0.9), vjust = -0.4, size = 3.8, fontface = "bold") +
  scale_fill_manual(values = c("Pre-Tsunami (2010)" = "#2ca25f", "Post-Tsunami (2011)" = "#de2d26")) +
  ylim(0, 75) +
  theme_bw() +
  labs(
    title = "Variazione di Copertura del Suolo a Ishinomaki",
    subtitle = "Confronto multitemporale Landsat 5 TM (2010 vs 2011)",
    x = "Tipologia di Copertura",
    y = "Copertura (%)",
    fill = "Periodo"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 10, face = "bold"),
    legend.position = "top"
  )
