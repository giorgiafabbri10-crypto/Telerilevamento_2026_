# Questo sarà il titolo del mio progetto di esame 

L'area di studio 

Ho scelto la Mauritania ...

<p align="center">
<img width="532" height="355" alt="100121_mauritania" src="https://github.com/user-attachments/assets/cdc1ed21-dfa8-4dba-bc03-586c06f03795" />
</p>

## Pacchetti utilizzati

Per questo esame pacchetti:...

```
libraty(terra) # pacchetto per...
linrary(imageRy) per multiframe e altro
```

## Importazine dei dati
i dati sono stati scaricati da Earth Observatory: <img width="1440" height="960" alt="richatstructure_oli_20260306" src="https://github.com/user-attachments/assets/9b7fc34c-43d2-4674-a396-d0c1706764b6" />

Oppure posso scrivere così :[https://assets.science.nasa.gov/dynamicimage/assets/science/esd/eo/images/iotd/2026/eyeing-the-richat-structure/richatstructure_oli_20260306.jpg?w=1440&h=960&fit=clip&crop=faces%2Cfocalpoint]

Il codice utilizzato è il seguente: prima di tutto selezionamo la working directory

```
setw("-/Desktop/")
# c://blablabla/lknlknlkn

getwd()
list.files()
```

per importare i dati è stata utilizzata la funzione `rast()` del pacchetto `terra`:

```r
richat <- rast("richatstructure_oli_20260306.jpg")
richat <- flip(richat)
plot(richat)
```

<https://assets.science.nasa.gov/dynamicimage/assets/science/esd/eo/images/iotd/2026/eyeing-the-richat-structure/richatstructure_oli_20260306.jpg?w=1440&h=960&fit=clip&crop=faces%2Cfocalpoint>

Prima di tutto blabla singole bande 

```

Siccome sono pigro ho usato un ciclo for:

``` r
copio il codice 
```




