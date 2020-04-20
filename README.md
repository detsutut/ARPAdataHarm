# ARPA Data Harmonization
This repository contains a R script which can be used to merge and harmonize weather/pollution data coming from multiple sources on the ARPA Lombardy portal.

[Here](https://raw.githubusercontent.com/detsutut/ARPAdataHarm/master/data/datiLombardia.csv) you can find the harmonized dataset, including major pollutants' concentrations over 2018, 2019 and 2020 (ongoing), as well as weather conditions. Daily values are obtained averaging the observations coming from sensors spread all over Lombardy. 

Please note that the included CSV files for air pollutants are just for demonstration purposes (first 10 rows), as the original files were too big to be uploaded on git. You can easily download them by yourself, though.

Air pollution data: [Regione Lombardia Open Data](https://www.dati.lombardia.it/stories/s/auv9-c2sj)
Weather data: [ARPA Data Request Page](https://www.arpalombardia.it/Pages/Meteorologia/Richiesta-dati-misurati.aspx)

*Important: due to the weird procedure requested to access ARPA's weather data, only 7 weather sensors have been included here. These sensors are: MILANO Lambrate, MILANO P.zza Zavattari, MILANO v. Brera, MILANO v. Feltre, MILANO v. Juvara, MILANO v. Marche, RHO. The daily values of air pollutants instead, are averaged across the whole region.*
