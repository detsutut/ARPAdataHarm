library(data.table)
library(dplyr)
library(purrr)

homedir = "E:/Google Drive (Lavoro)/3. TowardsDataScience/lombardyPollution/git/data"
setwd(file.path(homedir,'aria'))

# Sensors
sensors  = read.csv("Stazioni_qualit__dell_aria.csv",stringsAsFactors = FALSE)

# Meteo
aria2018  = read.csv("Dati_sensori_aria_2018.csv",stringsAsFactors = FALSE) %>% 
  filter(Stato=="VA") %>% select(IdSensore,Data,Valore)
aria2019  = read.csv("Dati_sensori_aria_2019.csv",stringsAsFactors = FALSE) %>% 
  filter(Stato=="VA") %>% select(IdSensore,Data,Valore)
aria2020  = read.csv("Dati_sensori_aria_2020.csv",stringsAsFactors = FALSE) %>% 
  filter(Stato=="VA") %>% select(IdSensore,Data,Valore)

# Rain
setwd(file.path(homedir,'meteo','precip18'))
precip2018 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Cumulata Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','precip19'))
precip2019 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Cumulata Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','precip20'))
precip2020 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Cumulata Giornaliero` >= 0)

precip2018_daily = aggregate(list(precip2018$`Valore Cumulata Giornaliero`), list(precip2018$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
precip2019_daily = aggregate(list(precip2019$`Valore Cumulata Giornaliero`), list(precip2019$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
precip2020_daily = aggregate(list(precip2020$`Valore Cumulata Giornaliero`), list(precip2020$`Data-Ora`), mean) %>% rename_at(2, ~"value" )

# Wind
setwd(file.path(homedir,'meteo','vento18'))
vento2018 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','vento19'))
vento2019 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','vento20'))
vento2020 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)

vento2018_daily = aggregate(list(vento2018$`Valore Medio Giornaliero`), list(vento2018$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
vento2019_daily = aggregate(list(vento2019$`Valore Medio Giornaliero`), list(vento2019$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
vento2020_daily = aggregate(list(vento2020$`Valore Medio Giornaliero`), list(vento2020$`Data-Ora`), mean) %>% rename_at(2, ~"value" )

# Temp
setwd(file.path(homedir,'meteo','temp18'))
temp2018 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','temp19'))
temp2019 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)
setwd(file.path(homedir,'meteo','temp20'))
temp2020 <- list.files(pattern="*.csv") %>% map_df(~fread(.)) %>% select(1:3) %>% filter(`Valore Medio Giornaliero` >= 0)

temp2018_daily = aggregate(list(temp2018$`Valore Medio Giornaliero`), list(temp2018$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
temp2019_daily = aggregate(list(temp2019$`Valore Medio Giornaliero`), list(temp2019$`Data-Ora`), mean) %>% rename_at(2, ~"value" )
temp2020_daily = aggregate(list(temp2020$`Valore Medio Giornaliero`), list(temp2020$`Data-Ora`), mean) %>% rename_at(2, ~"value" )


# Functions

getDatiPrecip = function(){
  return(data.frame(day = c(rep(1:365,3)), 
                    value = c(precip2018_daily$value[1:365],
                              precip2019_daily$value[1:365],
                              c(precip2020_daily$value,rep(NA,365-nrow(precip2020_daily)))),
                    year = as.factor(c(rep(2018,365),rep(2019,365),rep(2020,365)))))
}

getDatiVento = function(){
  return(data.frame(day = c(rep(1:365,3)), 
                    value = c(vento2018_daily$value[1:365],
                              vento2019_daily$value[1:365],
                              c(vento2020_daily$value,rep(NA,365-nrow(vento2020_daily)))),
                    year = as.factor(c(rep(2018,365),rep(2019,365),rep(2020,365)))))
}

getDatiTemp = function(){
  return(data.frame(day = c(rep(1:365,3)),
                    value = c(temp2018_daily$value[1:365],
                              temp2019_daily$value[1:365],
                              c(temp2020_daily$value,rep(NA,365-nrow(temp2020_daily)))),
                    year = as.factor(c(rep(2018,365),rep(2019,365),rep(2020,365)))))
}

#for idTipoSensore check unique(sensors$NomeTipoSensore) indices
#for idProvincia unique(sensors$Provincia) indices 
getDatiAria = function(idTipoSensore=2,idProvincia=0){
  x = unique(sensors$NomeTipoSensore)[idTipoSensore]
  p = unique(sensors$Provincia)[idProvincia]
  if(idProvincia == 0) sensors_x = sensors[which(sensors$NomeTipoSensore==x),]
  else sensors_x = sensors[which((sensors$NomeTipoSensore==x) & (sensors$Provincia==p)),]

  aria2018_x = data.table(aria2018[which(aria2018$IdSensore %in% sensors_x$IdSensore),])
  aria2018_x$Data = matrix(unlist(strsplit(aria2018_x$Data, " ")),ncol = 3, byrow = TRUE)[,1]
  aria2018_x_daily = aria2018_x[, mean(Valore), by = Data]
  
  aria2019_x = data.table(aria2019[which(aria2019$IdSensore %in% sensors_x$IdSensore),])
  aria2019_x$Data = matrix(unlist(strsplit(aria2019_x$Data, " ")),ncol = 3, byrow = TRUE)[,1]
  aria2019_x_daily = aria2019_x[, mean(Valore), by = Data]
  
  aria2020_x = data.table(aria2020[which(aria2020$IdSensore %in% sensors_x$IdSensore),])
  aria2020_x$Data = matrix(unlist(strsplit(aria2020_x$Data, " ")),ncol = 3, byrow = TRUE)[,1]
  aria2020_x_daily = aria2020_x[, mean(Valore), by = Data]

  return(data.frame(day = c(rep(1:365,3)), 
                      value = c(aria2018_x_daily$V1,
                                aria2019_x_daily$V1,
                                c(aria2020_x_daily$V1,rep(NA,365-nrow(aria2020_x_daily)))),
                      year = as.factor(c(rep(2018,365),rep(2019,365),rep(2020,365)))))
}

#DF COMPLETO
lockDownDay = 68
df_completo = data.frame(day = getDatiAria(idTipoSensore = 6)$day, 
                         year = getDatiAria(idTipoSensore = 6)$year, 
                         no2 = getDatiAria(idTipoSensore = 6)$value,
                         co = getDatiAria(idTipoSensore = 2)$value,
                         o3 = getDatiAria(idTipoSensore = 1)$value,
                         benz = getDatiAria(idTipoSensore = 12)$value,
                         nh3 = getDatiAria(idTipoSensore = 13)$value,
                         so2 = getDatiAria(idTipoSensore = 8)$value,
                         pm10 = getDatiAria(idTipoSensore = 5)$value,
                         pm2.5 = getDatiAria(idTipoSensore = 9)$value,
                         wind = getDatiVento()$value,
                         rain = getDatiPrecip()$value,
                         temp = getDatiTemp()$value,
                         lockdown = FALSE)
df_completo$lockdown[which((df_completo$year == "2020") & (df_completo$day>=lockDownDay) & (df_completo$day<=95))] = TRUE

setwd(file.path(homedir))
write.csv(df_completo,"datiLombardia.csv",row.names = FALSE)
