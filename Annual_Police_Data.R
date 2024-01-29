
# Clear working memory
rm(list=ls())

library(dplyr)
library(readr)
library(ggplot2)
library(reshape2)
library(fs)
library(lubridate)
library(tidyr)

# Set base path and root directory
base_path <- "C:/Users/natal/Desktop/GitHub/SARC_research"
root_directory <- file.path(base_path, "Police_Data")

## Function to loop through the folders and create dataframes according to year
create_police_df_for_year <- function(year, root_directory) {
  # Initialize the DataFrame with specified columns
  police_df <- data.frame(Month=character(), Falls.within=character(), Crime.type=character(), stringsAsFactors=FALSE)
  
  # Iterate through all items in the root directory
  items <- list.files(root_directory, full.names = TRUE)
  for (item in items) {
    # Check if the item is a directory and contains the specified year
    if (file.info(item)$isdir && grepl(year, item)) {
      files <- list.files(item, pattern = "-street\\.csv$", full.names = TRUE)
      for (file in files) {
        # Read the CSV file
        df <- read_csv(file, col_types = cols())
        
        # Check for parsing problems
        parse_problems <- problems(df)
        if (nrow(parse_problems) > 0) {
          print(paste("Parsing issues found in file:", file))
          print(parse_problems)
        }
        
        # Select and rename columns as necessary to match the expected structure
        df <- df %>% 
          select(Month, Falls.within = `Falls within`, Crime.type = `Crime type`)
        
        # Append it to the police_df DataFrame
        police_df <- bind_rows(police_df, df)
      }
    }
  }
  
  return(police_df)
}

# Dataframes from 2011 to 2022
police_df_2011 <- create_police_df_for_year(2011, root_directory)
police_df_2012 <- create_police_df_for_year(2012, root_directory)
police_df_2013 <- create_police_df_for_year(2013, root_directory)
police_df_2014 <- create_police_df_for_year(2014, root_directory)
police_df_2015 <- create_police_df_for_year(2015, root_directory)
police_df_2016 <- create_police_df_for_year(2016, root_directory)
police_df_2017 <- create_police_df_for_year(2017, root_directory)
police_df_2018 <- create_police_df_for_year(2018, root_directory)
police_df_2019 <- create_police_df_for_year(2019, root_directory)
police_df_2020 <- create_police_df_for_year(2020, root_directory)
police_df_2021 <- create_police_df_for_year(2021, root_directory)
police_df_2022 <- create_police_df_for_year(2022, root_directory)


## Function for data exploration
print_unique_values <- function(year, dataframes) {
  # Access the DataFrame for the specified year
  df <- dataframes[[as.character(year)]]
  if (!is.null(df)) {
    # Get and print unique values for "Crime type"
    unique_crime_types <- unique(df$`Crime.type`)
    cat("Unique Crime Types for", year, ":\n")
    print(unique_crime_types)
    
    # Get and print unique values for "Falls within"
    unique_police_neighborhoods <- unique(df$`Falls.within`)
    cat("\nUnique Police Neighborhoods for", year, ":\n")
    print(unique_police_neighborhoods)
  } else {
    cat("No data available for the year", year, "\n")
  }
}


police_df_list <- list(
  "2011" = police_df_2011,
  "2012" = police_df_2012,
  "2013" = police_df_2013,
  "2014" = police_df_2014,
  "2015" = police_df_2015,
  "2016" = police_df_2016,
  "2017" = police_df_2017,
  "2018" = police_df_2018,
  "2019" = police_df_2019,
  "2020" = police_df_2020,
  "2021" = police_df_2021,
  "2022" = police_df_2022
)

# Unique values for each year
print_unique_values(2012, police_df_list)
print_unique_values(2013, police_df_list)
print_unique_values(2014, police_df_list)
print_unique_values(2015, police_df_list)
print_unique_values(2016, police_df_list)
print_unique_values(2017, police_df_list)
print_unique_values(2018, police_df_list)
print_unique_values(2019, police_df_list)
print_unique_values(2020, police_df_list)
print_unique_values(2021, police_df_list)
print_unique_values(2022, police_df_list)

## POPULATION 

# Define the police forces and their populations
police_force <- c("Avon and Somerset Constabulary", "Bedfordshire Police", "British Transport Police",
                  "Cambridgeshire Constabulary", "Cheshire Constabulary", "City of London Police",
                  "Cleveland Police", "Cumbria Constabulary", "Derbyshire Constabulary", "Devon & Cornwall Police",
                  "Dorset Police", "Durham Constabulary", "Dyfed-Powys Police", "Essex Police",
                  "Gloucestershire Constabulary", "Greater Manchester Police", "Gwent Police", "Hampshire Constabulary",
                  "Hertfordshire Constabulary", "Humberside Police", "Kent Police", "Lancashire Constabulary",
                  "Leicestershire Police", "Lincolnshire Police", "Merseyside Police", "Metropolitan Police Service",
                  "Norfolk Constabulary", "North Wales Police", "North Yorkshire Police", "Northamptonshire Police",
                  "Northumbria Police", "Nottinghamshire Police", "Police Service of Northern Ireland",
                  "South Wales Police", "South Yorkshire Police", "Staffordshire Police", "Suffolk Constabulary",
                  "Surrey Police", "Sussex Police", "Thames Valley Police", "Warwickshire Police",
                  "West Mercia Police", "West Midlands Police", "West Yorkshire Police", "Wiltshire Police")

population_served <- c(1650000, 664500, NA, 800000, 1070000, 431000, 570000, 498000, 1060000, 1760000,
                       777000, 641000, 523000, 1860000, 641000, 2850000, 598000, 2000000, 1200000, 934000,
                       1870000, 1520000, 1110000, 766000, 1430000, 8990000, 914000, 703000, 832000, 757000,
                       1470000, 1170000, NA, 1350000, 1420000, 1140000, 761000, 1200000, 1720000, 2430000,
                       584000, 1300000, 2940000, 2350000, 727000)

# Create the data frame
police_region_pop_df <- data.frame(police_force = police_force, population_served = population_served)

# Calculate the total population (excluding NA values)
total_population <- sum(police_region_pop_df$population_served, na.rm = TRUE)

# Add a new row for the total
total_row <- data.frame(police_force = "Total", population_served = total_population)

# Combine the original data frame with the new row
police_region_pop_df <- rbind(police_region_pop_df, total_row)


## Monthly counts and rates of sexual violence

# Function to process a year's data
process_year <- function(df, year, population_served) {
  # Filter for 'Violence and sexual offences'
  filtered_df <- filter(df, `Crime.type` == 'Violence and sexual offences')
  
  # Extract the month from the 'Month' column
  filtered_df$Month <- factor(month(ymd(paste0(filtered_df$Month, "-01")), label = TRUE, abbr = FALSE))
  
  # Count occurrences for each month
  monthly_counts <- filtered_df %>%
    group_by(Month) %>%
    summarise(Count = n(), .groups = 'drop') %>%
    arrange(Month)
  
  # Initialize all months with zero count
  all_months <- setNames(rep(0, 12), month.name)
  counts_list <- as.list(setNames(monthly_counts$Count, monthly_counts$Month))
  new_row <- replace(all_months, names(counts_list), counts_list)
  
  # Add year and calculate crime rates
  new_row_df <- data.frame(Year = year, new_row, stringsAsFactors = FALSE)
  for (month_name in names(all_months)) {
    rate_column <- paste0(month_name, " Crime Rate")
    crime_count <- new_row_df[[month_name]]
    if (!is.na(population_served) && population_served != 0) {
      new_row_df[[rate_column]] <- (crime_count / population_served) * 100000
    } else {
      new_row_df[[rate_column]] <- NA
    }
  }
  
  return(new_row_df)
}

# Get the population served from the police_region_pop_df
population_served <- police_region_pop_df$population_served[46] 

# Adjust the data frame structure to include 'Total Counts' and 'Total Crime Rate'
monthly_rates_df <- data.frame(Year = integer(), January = integer(), February = integer(), 
                               March = integer(), April = integer(), May = integer(), 
                               June = integer(), July = integer(), August = integer(), 
                               September = integer(), October = integer(), November = integer(), 
                               December = integer(), TotalCounts = integer(), TotalCrimeRate = double(), 
                               stringsAsFactors = FALSE)

# Loop to process each year
for (year in 2014:2022) {
  # Retrieve the data frame for the year from the list
  if (!is.null(police_df_list[[as.character(year)]])) {
    yearly_df <- police_df_list[[as.character(year)]]
    
    # Process the data for the year using the 'process_year' function
    new_row <- process_year(yearly_df, year, population_served)
    
    # Calculate the total counts for the year
    total_counts <- sum(new_row[2:13], na.rm = TRUE) # Sum of crimes
    new_row$TotalCounts <- total_counts
    
    # Calculate the total crime rate for the year
    new_row$TotalCrimeRate <- (total_counts / population_served) * 100000 # Crime rate per 100,000 people
    
    # Append the new row to the monthly_rates_df data frame
    monthly_rates_df <- rbind(monthly_rates_df, new_row)
  }
}

# Display the updated data frame
print(monthly_rates_df)


####

# Filtering for 'Violence and sexual offences' in the 2022 data
violence_df_2022 <- police_df_2022 %>%
  filter(`Crime.type` == 'Violence and sexual offences')

# Summing the number of crimes per police force
crime_counts_2022 <- violence_df_2022 %>%
  group_by(`Falls.within`) %>%
  summarise(Total_Crimes = n(), .groups = 'drop')

# Renaming 'Falls.within' to 'police_force' for merging
colnames(crime_counts_2022)[which(names(crime_counts_2022) == "Falls.within")] <- "police_force"

# Merging with the population data
crime_rates_2022 <- merge(crime_counts_2022, police_region_pop_df, by = "police_force")

# Calculating the crime rate per 100,000 population
crime_rates_2022 <- crime_rates_2022 %>%
  mutate(Crime_Rate_per_100k = (Total_Crimes / population_served) * 100000)

# Select only the relevant columns to display
crime_rates_2022 <- crime_rates_2022 %>%
  select(police_force, Total_Crimes, Crime_Rate_per_100k)

# Display the results
print(crime_rates_2022)
