library(tidyverse)
library(leaflet)

dados1<-readr::read_csv("MODIS_C6_South_America_24h.csv")
dados2<-readr::read_csv("fire_nrt_J1V-C2_157510.csv")
dados3<-readr::read_csv("fire_nrt_M6_157509.csv")
dados4<-readr::read_csv("fire_nrt_V1_157511.csv")

# nao consegui o emoji
#fog <- makeIcon("foguin.png", 18,18)

# para ver os dados:

  dados2 %>% View

  # lugares com maior certeza de fogo
  dados_mapa <- dados3 %>% filter(confidence > 85)
  
  # gera o mapa
  dados_mapa %>% 
  leaflet() %>%
  addTiles() %>%  
  setView(lng =  -47.9292, lat = -15.7801, zoom = 5) %>% 
  addCircles(~longitude, ~latitude,radius=0.5,fillOpacity=0.4, color="red")
  
