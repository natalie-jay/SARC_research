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
library(dplyr)

# Main SARC KML file
SARC_map <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/SARC_map_2014.kml")

# 2021 crime rates according to police force (Variable = crime_rates_2021)
crime_rates_2021 <- read.csv("C:/Users/natal/Desktop/GitHub/SARC_research/crime_rates_2021.csv")

# Adjusting the police_force column in crime_rates_2021
crime_rates_2021 <- crime_rates_2021 %>%
  mutate(police_force = ifelse(police_force == "Police Service of Northern Ireland", 
                               police_force, 
                               sub("\\s+\\S+$", "", police_force)))

# Read UK shape data 
UK_shape_data1 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm0.shp")
UK_shape_data2 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm1.shp")
UK_shape_data3 <- shape_data <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/UK_shape_data/GBR_adm2.shp")

# Read the additional shapefile (e.g., police force areas)
police_force_areas <- st_read("C:/Users/natal/Desktop/GitHub/SARC_research/police_force_areas/Police_Force_Areas__December_2019__Ultra_Generalised_Clipped_Boundaries_EW.shp")

# Rename the column
police_force_areas <- police_force_areas %>%
  rename(police_force = PFA19NM)

# Adjusting the police_force column in police_force_areas
police_force_areas <- police_force_areas %>%
  mutate(police_force = ifelse(police_force == "London, City of", 
                               "City of London", 
                               police_force))

## COMPARISON

diff_crime_to_areas <- setdiff(crime_rates_2021$police_force, police_force_areas$police_force)
diff_areas_to_crime <- setdiff(police_force_areas$police_force, crime_rates_2021$police_force)

print(diff_crime_to_areas)
print(diff_areas_to_crime)

## Greater Manchester does not appear in 2021 Crime Rates
## British Transport and Police Service of Northern Ireland does not appear in Police Force Areas

# TEST AREA
summary(police_force_areas)
plot(police_force_areas)

police_force_areas_simplified <- st_simplify(police_force_areas, dTolerance = 0.01)

ggplot() + geom_sf(data = police_force_areas_simplified)

st_is_valid(police_force_areas)

###

# Merge/join the spatial data with crime rates
police_force_areas_crime <- merge(police_force_areas, crime_rates_2021, by = "police_force")

# Assuming you've merged your crime rate data into police_force_areas and named it police_force_areas_crime
# and it contains a column 'Crime_Rate_per_100k' for the crime rates.

UK_map <- ggplot() +
  geom_sf(data = UK_shape_data1, fill = 'blue', color = 'black') +
  geom_sf(data = UK_shape_data2, fill = 'green', color = 'black') +
  geom_sf(data = UK_shape_data3, fill = 'yellow', color = 'black') +
  theme_minimal()

# Add a layer for the heat gradient based on crime rates
map_with_heat_gradient <- UK_map +
  geom_sf(data = police_force_areas_crime, aes(fill = Crime_Rate_per_100k), color = 'black', alpha = 0.5) +
  scale_fill_gradient(low = "white", high = "red") # Adjust colors as needed

# If you still want to overlay SARC coordinates and the original police force areas without the crime rate data
map_with_overlays_and_heat <- map_with_heat_gradient +
  geom_sf(data = SARC_map, fill = 'red', color = 'red', alpha = 0.5) +
  geom_sf(data = police_force_areas, color = 'black', fill = NA, alpha = 0.5) # Using fill = NA for transparency

# Display the final map
print(map_with_overlays_and_heat)

ggsave("C:/Users/natal/Desktop/GitHub/SARC_research/Final_UK_Map.png", map_with_overlays_and_heat, width = 10, height = 8, units = "in", dpi = 300)

