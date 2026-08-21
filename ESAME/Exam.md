> #### Giorgia Fabbri
>> ##### Esame di Telerilevamento Geo-Ecologico in R - 2025/2026

# Analisi dell'Impatto dello Tsunami del 2011 a Ishinomaki (Giappone) 🌊🛰️

---

# 📌 Introduzione

L'11 marzo 2011 un sisma sottomarino di magnitudo 9.0 (Great East Japan Earthquake) ha innescato una serie di devastanti onde di tsunami lungo la costa nord-orientale del Giappone (regione del Tōhoku). La città costiera di **Ishinomaki** (Prefettura di Miyagi), situata sulla piana alluvionale alla foce del fiume Kitakami, è stata una delle aree maggiormente distrutte e sommerse dall'inondazione marina.

L'area di studio è caratterizzata da:
- una pianura costiera a forte vocazione urbana, residenziale e agricola;
- il delta e l'asta fluviale del fiume Kitakami;
- rilievi collinari e montuosi retrostanti ricoperti da dense foreste sempreverdi e decidue;
- un'elevata vulnerabilità all'inondazione e alla subsidenza cosismica del suolo.

---

# 🛰️ Obiettivo del Progetto in R

L'obiettivo dell'elaborazione telerilevata in R è **valutare e quantificare l'impatto spaziale ed ecologico dello tsunami** a Ishinomaki, confrontando immagini satellitari multispettrali **Landsat 5 TM** prima (2010) e dopo l'evento (2011) tramite:

- **False Color Composite (FCC):** per evidenziare il contrasto tra vegetazione viva, suolo e acqua.
- **NDVI (Normalized Difference Vegetation Index):** per analizzare lo stato di salute della vegetazione.
- **ΔNDVI:** per mappare la distribuzione geografica del danno e della perdita di biomassa fotosintetica.
- **Classificazione non supervisionata (k-means):** per quantificare statisticamente le variazioni delle classi di copertura del suolo.

---

# 🧪 Data gathering e Metodologia

## Raccolta delle immagini
Le immagini satellitari provengono dal portale dell'[**USGS EarthExplorer**](https://earthexplorer.usgs.gov/) selezionando il sensore **Landsat 5 TM (Collection 2 - Level 1)** con traccia orbitale **WRS-2: Path 107, Row 033**.

> [!NOTE]
> Le due scene acquisite sono prive di copertura nuvolosa sull'area di studio e corrispondono alle date del **24 Agosto 2010** (Pre-Tsunami) e del **05 Aprile 2011** (Post-Tsunami).

## Impostazione della working directory
```r
setwd("C:/Users/LEONOVO-I3/Desktop/progetto telerilevamento")

## Caricamento pacchetti
R
library(terra)      # Per la gestione di raster e dati spaziali
library(imageRy)    # Funzioni di telerilevamento e classificazione
library(viridis)    # Palette cromatiche scientifiche
library(ggplot2)    # Creazione di grafici statistici

Importazione delle bande e creazione degli stack
Per ciascuna data vengono importate le prime 4 bande ottiche di Landsat 5 TM e concatenate in uno stack multispettrale:

B1: Blu (0.45 – 0.52 µm)

B2: Verde (0.52 – 0.60 µm)

B3: Rosso (0.63 – 0.69 µm)

B4: Vicino Infrarosso / NIR (0.76 – 0.90 µm)

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

par(mfrow = c(1, 2))
plotRGB(pre_stack, r = 4, g = 3, b = 2, stretch = "lin", main = "Pre-Tsunami (24/08/2010)")
plotRGB(post_stack, r = 4, g = 3, b = 2, stretch = "lin", main = "Post-Tsunami (05/04/2011)")
dev.off()
