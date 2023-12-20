# -*- coding: utf-8 -*-
"""
Created on Tue Dec 19 01:48:41 2023

@author: natal
"""

import os
import pandas as pd
import matplotlib.pyplot as plt

# Define Functions
def create_police_df_for_year(year, root_directory):
    police_df = pd.DataFrame(columns=['Month', 'Police Force', 'Crime type'])
    for item in os.listdir(root_directory):
        if os.path.isdir(os.path.join(root_directory, item)) and str(year) in item:
            for file in os.listdir(os.path.join(root_directory, item)):
                if file.endswith('-street.csv'):
                    file_path = os.path.join(root_directory, item, file)
                    df = pd.read_csv(file_path)
                    if 'Falls within' in df.columns:
                        df.rename(columns={'Falls within': 'Police Force'}, inplace=True)
                    if 'Police Force' not in df.columns:
                        df['Police Force'] = pd.NA
                    df = df[['Month', 'Police Force', 'Crime type']]
                    police_df = police_df.append(df, ignore_index=True)
    return police_df

def calculate_annual_statistics_from_monthly_counts(monthly_counts_df):
    stats_df = pd.DataFrame(columns=['Year', 'Min', 'Max', 'Mean', 'StdDev'])
    for index, row in monthly_counts_df.iterrows():
        year = row['Year']
        monthly_crime_rates = row.filter(like='Crime Rate')
        min_value = monthly_crime_rates.min()
        max_value = monthly_crime_rates.max()
        mean_value = monthly_crime_rates.mean()
        std_dev = monthly_crime_rates.std()
        stats_df = stats_df.append({
            'Year': year,
            'Min': min_value,
            'Max': max_value,
            'Mean': mean_value,
            'StdDev': std_dev
        }, ignore_index=True)
    return stats_df

# Process and aggregate data for each year
def process_year(df, year):
    # Filter for a specific crime type
    filtered_df = df[df['Crime type'] == 'Violence and sexual offences']
    
    # Count occurrences for each month
    monthly_counts = filtered_df['Month'].value_counts().sort_index()
    
    # Create a new row with year and monthly counts
    new_row = {'Year': year}
    for month in monthly_counts.index:
        # Assuming the 'Month' column is in 'YYYY-MM' format
        month_name = pd.to_datetime(month).strftime('%B')
        new_row[month_name] = monthly_counts[month]
    
    return new_row

# Modify the process_year function to include crime rate calculation for each month
def process_year(df, year, population_served):
    # Filter for 'Violence and sexual offences'
    filtered_df = df[df['Crime type'] == 'Violence and sexual offences']
    
    # Count occurrences for each month
    monthly_counts = filtered_df['Month'].value_counts().sort_index()
    
    # Create a new row with year, monthly counts, and crime rates
    new_row = {'Year': year}
    for month in monthly_counts.index:
        # Assuming the 'Month' column is in 'YYYY-MM' format
        month_name = pd.to_datetime(month).strftime('%B')
        count = monthly_counts[month]
        new_row[month_name] = count
        # Calculate the crime rate per 100,000 population
        if population_served and population_served > 0:
            new_row[f'{month_name} Crime Rate'] = (count / population_served) * 100000
        else:
            new_row[f'{month_name} Crime Rate'] = None  # Or appropriate placeholder

    return new_row

# 
def calculate_crime_rates(root_directory, crime_type, data):
    # Use the provided 'data' DataFrame for police forces and their corresponding populations
    police_region_pop_df = data
    
    # DataFrame to store the counts for each year and police force
    crime_counts_df = pd.DataFrame(columns=['Year', 'Police Force', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December', 'Total'])

    # Process each year
    for year in range(2011, 2023):
        # Create a DataFrame for the year
        yearly_df = create_police_df_for_year(year, root_directory)
        
        # Process each police force
        for police_force in police_region_pop_df['Police Force']:
            # Check if the police force exists in the yearly data
            if police_force in yearly_df['Police Force'].values:
                new_row = process_year(yearly_df, year, police_force, crime_type)
                crime_counts_df = crime_counts_df.append(new_row, ignore_index=True)

    return crime_counts_df

# Identify unique neighborhoods for each year
def count_unique_neighborhoods(dataframes):
    unique_counts = {}
    for year, df in dataframes.items():
        unique_neighborhoods = df['Police Force'].nunique()
        unique_counts[year] = unique_neighborhoods
    return unique_counts

def find_max_violence_neighborhood(years):
    max_violence_neighborhood = {}
    for year in years:
        df = globals().get(f'police_df_{year}')
        if df is not None:
            violence_df = df[df['Crime type'] == 'Violence and sexual offences']
            if not violence_df.empty:
                max_neighborhood = violence_df.groupby('Police Force').size().idxmax()
                max_violence_neighborhood[year] = max_neighborhood
            else:
                max_violence_neighborhood[year] = "No Data"
    return max_violence_neighborhood


# %%
# Initialization
base_path = r'C:\Users\natal\Desktop\GitHub\SARC_research'
root_directory = os.path.join(base_path, 'Police_Data')

# Data Loading and Processing
police_df_2011 = pd.DataFrame(columns=['Month', 'Police Force', 'Crime type'])
for item in os.listdir(root_directory):
    if os.path.isdir(os.path.join(root_directory, item)) and '2011' in item:
        for file in os.listdir(os.path.join(root_directory, item)):
            if file.endswith('-street.csv'):
                file_path = os.path.join(root_directory, item, file)
                df = pd.read_csv(file_path, usecols=['Month', 'Falls within', 'Crime type'])
                df = df.rename(columns={'Falls within': 'Police Force'})
                police_df_2011 = police_df_2011.append(df, ignore_index=True)

# Create DataFrames for each year
police_df_2012 = create_police_df_for_year(2012, root_directory)
police_df_2013 = create_police_df_for_year(2013, root_directory)
police_df_2014 = create_police_df_for_year(2014, root_directory)
police_df_2015 = create_police_df_for_year(2015, root_directory)
police_df_2016 = create_police_df_for_year(2016, root_directory)
police_df_2017 = create_police_df_for_year(2017, root_directory)
police_df_2018 = create_police_df_for_year(2018, root_directory)
police_df_2019 = create_police_df_for_year(2019, root_directory)
police_df_2020 = create_police_df_for_year(2020, root_directory)
police_df_2021 = create_police_df_for_year(2021, root_directory)
police_df_2022 = create_police_df_for_year(2022, root_directory)


# Dataframes dictionary for all years
dataframes = {
    2011: police_df_2011, 2012: police_df_2012,
    2013: police_df_2013, 2014: police_df_2014,
    2015: police_df_2015, 2016: police_df_2016,
    2017: police_df_2017, 2018: police_df_2018,
    2019: police_df_2019, 2020: police_df_2020,
    2021: police_df_2021, 2022: police_df_2022,
}

# %%  Data for police forces and their corresponding populations
# TEMPORARY - Population within police boundaries should be updated.

data = {
    "Police Force": [
        "Avon and Somerset Constabulary", "Bedfordshire Police",
        "British Transport Police", "Cambridegeshire Constabulary",
        "Cheshire Constabulary", "City of London Police",
        "Cleveland Police", "Cumbria Constabulary",
        "Derbyshire Police", "Devon and Cornwall Police",
        "Dorset Police", "Durham Constabulary",
        "Dyfed-Powys Police", "Essex Police",
        "Gloucestershire Police", "Greater Manchester Police",
        "Gwent Police", "Hampshire Police",
        "Hertfordshire Police", "Humberside Police",
        "Kent Police", "Lancashire Constabulary",
        "Leicestershire Police", "Lincolnshire Police",
        "Merseyside Police", "Metropolitan Police Service",
        "Norfolk Constabulary", "North Wales Police",
        "North Yorkshire Police", "Northamptonshire Police",
        "Northumbria Police", "Nottinghamshire Police",
        "Police Service of Northern Ireland", "South Wales Police",
        "South Yorkshire Police", "Staffordshire Police",
        "Suffolk Constabulary", "Surrey Police",
        "Sussex Police", "Thames Valley Police",
        "Warwickshire Police", "West Mercia Police",
        "West Midlands Police", "West Yorkshire Police",
        "Wiltshire Police",
    ],
    "Population Served": [
        1650000, # Avon and Somerset Constabulary
        664500,  # Bedfordshire Police
        None,    # British Transport Police
        800000,  # Cambridegeshire Constabulary
        1070000, # Cheshire Constabulary
        431000,  # City of London Police
        570000,  # Cleveland Police
        498000,  # Cumbria Constabulary
        1060000, # Derbyshire Police
        1760000, # Devon and Cornwall Police
        777000,  # Dorset Police
        641000,  # Durham Constabulary
        523000,  # Dyfed-Powys Police
        1860000, # Essex Police
        641000,  # Gloucestershire Police
        2850000, # Greater Manchester Police
        598000,  # Gwent Police
        2000000, # Hampshire Police
        1200000, # Hertfordshire Police
        934000,  # Humberside Police
        1870000, # Kent Police
        1520000, # Lancashire Constabulary
        1110000, # Leicestershire Police
        766000,  # Lincolnshire Police
        1430000, # Merseyside Police
        8990000, # Metropolitan Police Service
        914000,  # Norfolk Constabulary
        703000,  # North Wales Police
        832000,  # North Yorkshire Police
        757000,  # Northamptonshire Police
        1470000, # Northumbria Police
        1170000, # Nottinghamshire Police
        None,    # Police Service of Northern Ireland
        1350000, # South Wales Police
        1420000, # South Yorkshire Police
        1140000, # Staffordshire Police
        761000,  # Suffolk Constabulary
        1200000, # Surrey Police
        1720000, # Sussex Police
        2430000, # Thames Valley Police
        584000,  # Warwickshire Police
        1300000, # West Mercia Police
        2940000, # West Midlands Police
        2350000, # West Yorkshire Police
        727000,  # Wiltshire Police
    ]
}

police_region_pop_df = pd.DataFrame(data)

# Calculate the total population
total_population = police_region_pop_df['Population Served'].sum()

# Add a new row for the total
total_row = pd.DataFrame({'Police Force': ['Total'], 'Population Served': [total_population]})
police_region_pop_df = pd.concat([police_region_pop_df, total_row], ignore_index=True)

print(police_region_pop_df)

# %%  Aggregate monthly counts for each year

# Initialize a DataFrame to store the aggregated monthly counts for each year
monthly_counts_df = pd.DataFrame(columns=['Year', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])

# Assuming police_region_pop_df is already defined
population_served = police_region_pop_df.iloc[45]['Population Served']

# Aggregate data for each year
for year in range(2013, 2023):  # Adjust range as needed
    yearly_df = globals()[f'police_df_{year}']
    monthly_counts_df = monthly_counts_df.append(process_year(yearly_df, year, population_served), ignore_index=True)

# Display the aggregated data
print(monthly_counts_df)


# %%  Calculate Crime Rates

# Calculate crime rates using the modified process_year function
for year in range(2013, 2023):  # Adjust range as needed
    yearly_df = globals()[f'police_df_{year}']
    monthly_counts_df = monthly_counts_df.append(process_year(yearly_df, year, population_served), ignore_index=True)

print(monthly_counts_df)

# %%  Extract totals and merge with population data

# Crime Rates
crime_type = 'Violence and sexual offences'  # Replace with the crime type of interest
crime_counts_df = calculate_crime_rates(root_directory, crime_type, data)
print(crime_counts_df)

totals_df = crime_counts_df[['Year', 'Police Force', 'Total']]

# Merge with population data
police_crime_per_100thousand_df = pd.merge(totals_df, police_region_pop_df, on='Police Force', how='left')

# Calculate crime rate per 100,000 people / Ensure division is not by zero
police_crime_per_100thousand_df['Population Served'].replace(0, pd.NA, inplace=True)
police_crime_per_100thousand_df['Crime Rate'] = (police_crime_per_100thousand_df['Total'] / police_crime_per_100thousand_df['Population Served']) * 100000

# Remove rows where 'Year' is 2011 or 2012
police_crime_per_100thousand_df = police_crime_per_100thousand_df[~police_crime_per_100thousand_df['Year'].isin([2011, 2012])]

print(police_crime_per_100thousand_df)

# %%
# Calculate annual statistics for Crime Rates
annual_stats = calculate_annual_statistics_from_monthly_counts(monthly_counts_df)
print(annual_stats)

# %%
# Plots
# Plotting Crime Rates
# ... (Your code for plotting crime rates)

# Plotting Annual Statistics
# ... (Your code for plotting annual statistics)
