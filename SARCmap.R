#######################################################################################
# Date: October 2023
# Author: Natalie J. Reyes

## Note: geospatial data obtained from 
# https://www.google.com/maps/d/u/0/viewer?mid=1bsQWa3crd5tm3FPgmjZTWZEV1J8&hl=en&femb=1&ll=53.15665296160101%2C-2.4588499999999813&z=6
# https://www.data.gov.uk/dataset/9a4d1e71-e342-42b5-bbbf-e2b202982c02/police-force-areas-dec-2019-ew-buc

rm(list=ls())

# Working directory
setwd("C:/Users/natal/Desktop/GitHub/SARC_research")

# Load necessary libraries
library(sf)
library(xml2)
library(ggplot2)

# Main SARC KML file
SARC_map <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/SARC_map_2014.kml")

# Read UK shape data 
UK_shape_data1 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm0.shp")
UK_shape_data2 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm1.shp")
UK_shape_data3 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm2.shp")

# Read the additional shapefile (e.g., police force areas)
police_force_areas <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/police_force_areas/Police_Force_Areas__December_2019__Ultra_Generalised_Clipped_Boundaries_EW.shp")

# TEST AREA
summary(police_force_areas)
plot(police_force_areas)

police_force_areas_simplified <- st_simplify(police_force_areas, dTolerance = 0.01)

ggplot() + geom_sf(data = police_force_areas_simplified)

st_is_valid(police_force_areas)

###

#plotting onto one map
UK_map <- ggplot() +
  geom_sf(data = UK_shape_data1, fill = 'blue', color = 'black') +
  geom_sf(data = UK_shape_data2, fill = 'green', color = 'black') +
  geom_sf(data = UK_shape_data3, fill = 'yellow', color = 'black') +
  theme_minimal()

#Overlay the SARC coordinates
#map_with_SARCs <- UK_map +
 # geom_sf(data = SARC_map, fill = 'red', color = 'red', alpha = 0.5)

# Overlay the SARC coordinates + police force areas
map_with_overlays <- UK_map +
  geom_sf(data = SARC_map, fill = 'red', color = 'red', alpha = 0.5) +
  geom_sf(data = police_force_areas, color = 'black', fill = 'gray', alpha = 0.5)

print(map_with_overlays)

ggsave("C:/Users/natal/Desktop/GitHub/SARC_research/Final_UK_Map.png", map_with_overlays, width = 10, height = 8, units = "in", dpi = 300)

