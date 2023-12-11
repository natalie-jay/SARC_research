#######################################################################################
# Date: October 2023
# Author: Natalie J. Reyes

## Note: geospatial data obtained from 
#https://www.google.com/maps/d/u/0/viewer?mid=1bsQWa3crd5tm3FPgmjZTWZEV1J8&hl=en&femb=1&ll=53.15665296160101%2C-2.4588499999999813&z=6

rm(list=ls())
setwd("C:/Users/natal/Desktop/GitHub/SARC_research")

library(sf)
library(xml2)
library(ggplot2)

SARC_map <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/SARC_map_2014.kml")

# Read the SARC KML file
#SARC_map <- st_read(kml_file_path)

#Extract ZIP archive to a temporary directory
#unzip("C:/Users/natal/Desktop/Smriti/SARC_research/GBR_adm.zip", 
 #     exdir = "C:/Users/natal/Desktop/Smriti/SARC_research/")

#UK_path <- "C:/Users/natal/Desktop/Smriti/SARC_research/GBR_adm.zip"
UK_shape_data1 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/GBR_adm0.shp")
UK_shape_data2 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/GBR_adm1.shp")
UK_shape_data3 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/GBR_adm2.shp")

#plotting onto one map
UK_map <- ggplot() +
  geom_sf(data = UK_shape_data1, fill = 'blue', color = 'black') +
  geom_sf(data = UK_shape_data2, fill = 'green', color = 'black') +
  geom_sf(data = UK_shape_data3, fill = 'yellow', color = 'black') +
  theme_minimal()

#Overlay the SARC coordinates
map_with_SARCs <- UK_map +
  geom_sf(data = SARC_map, fill = 'red', color = 'red', alpha = 0.5)

print(map_with_SARCs)

ggsave("C:/Users/natal/Desktop/GitHub/SARC_research/SARCmap.png", map_with_SARCs, width = 10, height = 8, units = "in", dpi = 300)

