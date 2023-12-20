# -*- coding: utf-8 -*-
"""

@author: natal
"""

import os
import pandas as pd
import matplotlib.pyplot as plt


#base_path = r'C:\Users\natal\Desktop\Smriti\SARC_research'
base_path = r'C:\Users\natal\Desktop\GitHub\SARC_research'

root_directory = os.path.join(base_path, 'Police_Data')


## 2011 TEST
police_df_2011 = pd.DataFrame(columns=['Month', 'Police Force', 'Crime type'])

# Iterate through all items in the root directory
for item in os.listdir(root_directory):
    # Check if the item is a directory and contains '2011'
    if os.path.isdir(os.path.join(root_directory, item)) and '2011' in item:
        # Iterate through each file in the directory
        for file in os.listdir(os.path.join(root_directory, item)):
            # Check if the file ends with '-street.csv'
            if file.endswith('-street.csv'):
                file_path = os.path.join(root_directory, item, file)
                # Read the specified columns from the CSV file
                df = pd.read_csv(file_path, usecols=['Month', 'Falls within', 'Crime type'])
                # Rename 'Falls within' to 'Police Force'
                df = df.rename(columns={'Falls within': 'Police Force'})
                # Append it to the police_df_2011 DataFrame
                police_df_2011 = police_df_2011.append(df, ignore_index=True)


### Summary Stats in 2011

## Unique Responses
# Get unique responses in the "Crime type" column
unique_crime_types_2011 = police_df_2011['Crime type'].unique()

# Print the unique crime types
print(unique_crime_types_2011)

# Get unique responses in the "Police Force" column
unique_police_neighborhoods_2011 = police_df_2011['Police Force'].unique()

# Print the unique crime types
print(unique_police_neighborhoods_2011)

# %%

def create_police_df_for_year(year, root_directory):
    # Initialize the DataFrame with specified columns
    police_df = pd.DataFrame(columns=['Month', 'Police Force', 'Crime type'])

    # Iterate through all items in the root directory
    for item in os.listdir(root_directory):
        # Check if the item is a directory and contains the specified year
        if os.path.isdir(os.path.join(root_directory, item)) and str(year) in item:
            # Iterate through each file in the directory
            for file in os.listdir(os.path.join(root_directory, item)):
                # Check if the file ends with '-street.csv'
                if file.endswith('-street.csv'):
                    file_path = os.path.join(root_directory, item, file)
                    # Read the CSV file
                    df = pd.read_csv(file_path)

                    # Check if 'Falls within' column exists, rename it to 'Police Force' if so
                    if 'Falls within' in df.columns:
                        df.rename(columns={'Falls within': 'Police Force'}, inplace=True)

                    # If 'Police Force' is not in the DataFrame, add it as an empty column
                    if 'Police Force' not in df.columns:
                        df['Police Force'] = pd.NA

                    # Select only the specified columns
                    df = df[['Month', 'Police Force', 'Crime type']]

                    # Append it to the police_df DataFrame
                    police_df = police_df.append(df, ignore_index=True)

    return police_df


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

# %%

# A dictionary for all of the years as keys
dataframes = {
    2011: police_df_2011, 2012: police_df_2012,
    2013: police_df_2013, 2014: police_df_2014,
    2015: police_df_2015, 2016: police_df_2016,
    2017: police_df_2017, 2018: police_df_2018,
    2019: police_df_2019, 2020: police_df_2020,
    2021: police_df_2021, 2022: police_df_2022,
}

# %%

def print_unique_values(year, dataframes):
    """
    Print unique crime types and neighborhoods in specific columns for the given year.

    Parameters:
    year (int): The year for which to print unique values.
    """
    # Access the DataFrame for the specified year
    df = dataframes.get(year)
    if df is not None:
        # Get and print unique values for "Crime type"
        unique_crime_types = df['Crime type'].unique()
        print(f"Unique Crime Types for {year}:")
        print(unique_crime_types)

        # Get and print unique values for "Police Force"
        unique_police_neighborhoods = df['Police Force'].unique()
        print(f"\nUnique Police Neighborhoods for {year}:")
        print(unique_police_neighborhoods)
    else:
        print(f"No data available for the year {year}")

print_unique_values(2012, dataframes)
print_unique_values(2013, dataframes)
print_unique_values(2014, dataframes)
print_unique_values(2015, dataframes)
print_unique_values(2016, dataframes)
print_unique_values(2017, dataframes)
print_unique_values(2018, dataframes)
print_unique_values(2019, dataframes)
print_unique_values(2020, dataframes)
print_unique_values(2021, dataframes)
print_unique_values(2022, dataframes)

# %%

# TEMPORARY. Population within police boundaries should be updated.

# Data for police forces and their corresponding populations
data = {
    "Police Force": [
        "Avon and Somerset Constabulary",
        "Bedfordshire Police",
        "British Transport Police",
        "Cambridegeshire Constabulary",
        "Cheshire Constabulary",
        "City of London Police",
        "Cleveland Police",
        "Cumbria Constabulary",
        "Derbyshire Police",
        "Devon and Cornwall Police",
        "Dorset Police",
        "Durham Constabulary",
        "Dyfed-Powys Police",
        "Essex Police",
        "Gloucestershire Police",
        "Greater Manchester Police",
        "Gwent Police",
        "Hampshire Police",
        "Hertfordshire Police",
        "Humberside Police",
        "Kent Police",
        "Lancashire Constabulary",
        "Leicestershire Police",
        "Lincolnshire Police",
        "Merseyside Police",
        "Metropolitan Police Service",
        "Norfolk Constabulary",
        "North Wales Police",
        "North Yorkshire Police",
        "Northamptonshire Police",
        "Northumbria Police",
        "Nottinghamshire Police",
        "Police Service of Northern Ireland",
        "South Wales Police",
        "South Yorkshire Police",
        "Staffordshire Police",
        "Suffolk Constabulary",
        "Surrey Police",
        "Sussex Police",
        "Thames Valley Police",
        "Warwickshire Police",
        "West Mercia Police",
        "West Midlands Police",
        "West Yorkshire Police",
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

# Create the DataFrame
police_region_pop_df = pd.DataFrame(data)

# Calculate the total population
total_population = police_region_pop_df['Population Served'].sum()

# Add a new row for the total
total_row = pd.DataFrame({'Police Force': ['Total'], 'Population Served': [total_population]})
police_region_pop_df = pd.concat([police_region_pop_df, total_row], ignore_index=True)

# Display the DataFrame
print(police_region_pop_df)


# %%

## Aggregate monthly counts for each year
monthly_counts_df = pd.DataFrame(columns=['Year', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])

# Function to process a year's data
def process_year(df, year, population_served):
    # Filter for 'Violence and sexual offences'
    filtered_df = df[df['Crime type'] == 'Violence and sexual offences']
    
    # Count occurrences for each month
    monthly_counts = filtered_df['Month'].value_counts().sort_index()
    
    # Create a new row with year and monthly counts and rates
    new_row = {'Year': year}
    for month in monthly_counts.index:
        # Assuming the 'Month' column is in 'YYYY-MM' format
        month_name = pd.to_datetime(month).strftime('%B')
        crime_count = monthly_counts[month]
        new_row[month_name] = crime_count
        # Calculate and add the crime rate per 100,000 for the month
        if pd.notna(population_served) and population_served != 0:
            new_row[f'{month_name} Crime Rate'] = (crime_count / population_served) * 100000
        else:
            new_row[f'{month_name} Crime Rate'] = pd.NA

    return new_row

# Assuming police_region_pop_df is already defined
population_served = police_region_pop_df.iloc[45]['Population Served']

# Aggregate monthly counts and rates for each year
monthly_counts_df = pd.DataFrame()

for year in range(2013, 2023):  # Adjust range as needed
    yearly_df = globals()[f'police_df_{year}']
    monthly_counts_df = monthly_counts_df.append(process_year(yearly_df, year, population_served), ignore_index=True)

# Display the updated DataFrame
print(monthly_counts_df)


# %%

## Monthly and total counts specific to each police force + year (e.g. 2013 Dorset Police )
def process_year(df, year, police_force, crime_type):
    # Filter for the specified year, police force, and crime type
    filtered_df = df[(df['Month'].str.contains(str(year))) & (df['Police Force'] == police_force) & (df['Crime type'] == crime_type)]
    
    # Initialize monthly counts
    monthly_counts = {month: 0 for month in ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']}

    # Count occurrences for each month
    for index, row in filtered_df.iterrows():
        month = pd.to_datetime(row['Month']).strftime('%B')
        monthly_counts[month] += 1

    # Create a new row with year, police force, and monthly counts
    new_row = {'Year': year, 'Police Force': police_force}
    new_row.update(monthly_counts)

    # Calculate the total crimes for the year
    new_row['Total'] = sum(monthly_counts.values())

    return new_row

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

# Crime Rates
crime_type = 'Violence and sexual offences'  # Replace with the crime type of interest
crime_counts_df = calculate_crime_rates(root_directory, crime_type, data)
print(crime_counts_df)

    
# %%

# Extract totals for each police force and year
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

def calculate_annual_statistics_from_monthly_counts(monthly_counts_df):
    """
    Calculate the annual min, max, mean, and std deviation for each year in the monthly_counts_df,
    considering only Crime Rate columns.

    Parameters:
    monthly_counts_df (pd.DataFrame): A DataFrame with monthly crime rates, indexed by year.

    Returns:
    pd.DataFrame: A DataFrame containing the statistics for each year.
    """
    # Initialize a DataFrame to store the statistics
    stats_df = pd.DataFrame(columns=['Year', 'Min', 'Max', 'Mean', 'StdDev'])

    # Iterate over each row in the monthly_counts_df
    for index, row in monthly_counts_df.iterrows():
        year = row['Year']
        # Filter to include only Crime Rate columns
        monthly_crime_rates = row.filter(like='Crime Rate')

        min_value = monthly_crime_rates.min()
        max_value = monthly_crime_rates.max()
        mean_value = monthly_crime_rates.mean()
        std_dev = monthly_crime_rates.std()

        # Append the statistics for this year to the DataFrame
        stats_df = stats_df.append({
            'Year': year,
            'Min': min_value,
            'Max': max_value,
            'Mean': mean_value,
            'StdDev': std_dev
        }, ignore_index=True)

    return stats_df

# Obtain annual summary stats for Crime Rates
annual_stats = calculate_annual_statistics_from_monthly_counts(monthly_counts_df)
print(annual_stats)


# %%

def count_unique_neighborhoods(dataframes):
    """
    Count the number of unique neighborhoods for each year.

    Parameters:
    dataframes (dict): A dictionary of DataFrames, keyed by year.

    Returns:
    dict: A dictionary containing the count of unique neighborhoods for each year.
    """
    
    unique_counts = {}

    for year, df in dataframes.items():
        unique_neighborhoods = df['Police Force'].nunique()  # Count unique values in 'Police Force'
        unique_counts[year] = unique_neighborhoods

    return unique_counts

# Get the count of unique neighborhoods for each year
unique_neighborhoods_counts = count_unique_neighborhoods(dataframes)

# %%

def find_max_violence_neighborhood(years):
    """
    Find the neighborhood with the highest number of 'Violence and sexual offences' for each year.

    Parameters:
    years (list): A list of years to process.

    Returns:
    dict: A dictionary containing the neighborhood with the maximum count of 'Violence and sexual offences' for each year.
    """
    max_violence_neighborhood = {}

    for year in years:
        # Dynamically access the DataFrame for each year
        df = globals().get(f'police_df_{year}')
        if df is not None:
            # Filter for 'Violence and sexual offences'
            violence_df = df[df['Crime type'] == 'Violence and sexual offences']

            # Group by 'Police Force' and count occurrences, then find the neighborhood with the maximum count
            if not violence_df.empty:
                max_neighborhood = violence_df.groupby('Police Force').size().idxmax()
                max_violence_neighborhood[year] = max_neighborhood
            else:
                max_violence_neighborhood[year] = "No Data"

    return max_violence_neighborhood

# Example usage
# Specify the range of years you have data for
years = range(2011, 2023)

# Find the neighborhood with the highest count of 'Violence and sexual offences' for each year
max_violence_neighborhoods = find_max_violence_neighborhood(years)


# %%

# Filter the DataFrame for the years 2013 to 2022
filtered_df = monthly_counts_df[(monthly_counts_df['Year'] >= 2013) & (monthly_counts_df['Year'] <= 2022)]

# Select only columns that contain 'Crime Rate'
crime_rate_columns = [col for col in filtered_df.columns if 'Crime Rate' in col]
filtered_df = filtered_df[['Year'] + crime_rate_columns]

# Set the 'Year' column as the index for easier plotting
filtered_df = filtered_df.set_index('Year')

# Plotting
plt.figure(figsize=(10, 6))
for year in filtered_df.index:
    plt.plot(filtered_df.columns, filtered_df.loc[year], label=int(year))  # Convert year to int

plt.xlabel('Month', fontweight='bold')
plt.ylabel('Crime Rate per 100,000', fontweight='bold')
plt.title('Monthly Crime Rates of Violence and Sexual Offences from 2013 to 2022', fontweight='bold')
plt.xticks(rotation=45)
plt.legend(title='Year')
plt.grid(True)

filename = 'monthly_crime_rates.png'
save_path = os.path.join(base_path, filename)
plt.savefig(save_path)

plt.show()

# %%

# Set 'Year' as index
annual_stats.set_index('Year', inplace=True)

###
# BAR Plotting
annual_stats.plot(kind='bar', figsize=(12, 6))

plt.title('Annual Crime Statistics', fontweight='bold')
plt.xlabel('Year', fontweight='bold')
plt.ylabel('Statistic Value', fontweight='bold')
plt.xticks(rotation=45)
plt.grid(True)

filename = 'annual_stats_bar.png'
save_path = os.path.join(base_path, filename)
plt.savefig(save_path)

plt.show()

# LINE Plotting

plt.figure(figsize=(12, 6))

plt.plot(annual_stats.index, annual_stats['Min'], label='Min')
plt.plot(annual_stats.index, annual_stats['Max'], label='Max')
plt.plot(annual_stats.index, annual_stats['Mean'], label='Mean')
plt.plot(annual_stats.index, annual_stats['StdDev'], label='StdDev')

# Set x-axis ticks to be each year
plt.xticks(annual_stats.index)

plt.title('Annual Crime Statistics Trends (2013-2022)', fontweight='bold')
plt.xlabel('Year', fontweight='bold')
plt.ylabel('Value', fontweight='bold')
plt.legend(title='Statistic')
plt.grid(True)

filename = 'annual_stats_line.png'
save_path = os.path.join(base_path, filename)
plt.savefig(save_path)

plt.show()

 
    
    