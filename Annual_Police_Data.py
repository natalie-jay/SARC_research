# -*- coding: utf-8 -*-
"""
Created on Sun Nov 26 19:28:52 2023

@author: natal
"""

import os
import pandas as pd
import matplotlib.pyplot as plt


#base_path = r'C:\Users\natal\Desktop\Smriti\SARC_research'
base_path = r'C:\Users\natal\Desktop\GitHub\SARC_research'

main_folder = os.path.join(base_path, 'Police_Data')

police_df_2011 = pd.DataFrame(columns=['Month', 'Falls within', 'Crime type'])

# Define the root directory where your folders are located
root_directory = main_folder

# Iterate through all items in the root directory
for item in os.listdir(root_directory):
    # Check if the item is a directory and contains '2011'
    if os.path.isdir(os.path.join(root_directory, item)) and '2011' in item:
        # Iterate through each file in the directory
        for file in os.listdir(os.path.join(root_directory, item)):
            # Check if the file ends with '-street.csv'
            if file.endswith('-street.csv'):
                file_path = os.path.join(root_directory, item, file)
                # Read only the specified columns from the CSV file
                df = pd.read_csv(file_path, usecols=['Month', 'Falls within', 'Crime type'])
                # Append it to the police_df_2011 DataFrame
                police_df_2011 = police_df_2011.append(df, ignore_index=True)


### Get summary stats for crime type in 2011

## Unique Responses
# Get unique responses in the "Crime type" column
unique_crime_types_2011 = police_df_2011['Crime type'].unique()

# Print the unique crime types
print(unique_crime_types_2011)

# Get unique responses in the "Falls within" column
unique_police_neighborhoods_2011 = police_df_2011['Falls within'].unique()

# Print the unique crime types
print(unique_police_neighborhoods_2011)

# %%

def create_police_df_for_year(year, root_directory):

    # Initialize the DataFrame with specified columns
    police_df = pd.DataFrame(columns=['Month', 'Falls within', 'Crime type'])

    # Iterate through all items in the root directory
    for item in os.listdir(root_directory):
        # Check if the item is a directory and contains the specified year
        if os.path.isdir(os.path.join(root_directory, item)) and str(year) in item:
            # Iterate through each file in the directory
            for file in os.listdir(os.path.join(root_directory, item)):
                # Check if the file ends with '-street.csv'
                if file.endswith('-street.csv'):
                    file_path = os.path.join(root_directory, item, file)
                    # Read only the specified columns from the CSV file
                    df = pd.read_csv(file_path, usecols=['Month', 'Falls within', 'Crime type'])
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

def print_unique_values(year, dataframes):
    """
    Print unique values in specific columns for the given year.

    Parameters:
    year (int): The year for which to print unique values.
    dataframes (dict): A dictionary of DataFrames, keyed by year.
    """
    # Access the DataFrame for the specified year
    df = dataframes.get(year)
    if df is not None:
        # Get and print unique values for "Crime type"
        unique_crime_types = df['Crime type'].unique()
        print(f"Unique Crime Types for {year}:")
        print(unique_crime_types)

        # Get and print unique values for "Falls within"
        unique_police_neighborhoods = df['Falls within'].unique()
        print(f"\nUnique Police Neighborhoods for {year}:")
        print(unique_police_neighborhoods)
    else:
        print(f"No data available for the year {year}")



dataframes = {
    2011: police_df_2011,
    2012: police_df_2012,
    2013: police_df_2013,
    2014: police_df_2014,
    2015: police_df_2015,
    2016: police_df_2016,
    2017: police_df_2017,
    2018: police_df_2018,
    2019: police_df_2019,
    2020: police_df_2020,
    2021: police_df_2021,
    2022: police_df_2022,
}

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
# Initialized a DataFrame to store the counts for each year
monthly_counts_df = pd.DataFrame(columns=['Year', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])

# Function to process a year's data
def process_year(df, year):
    # Filter for 'Violence and sexual offences'
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


for year in range(2013, 2023):  # Adjust range as needed
    yearly_df = globals()[f'police_df_{year}']
    monthly_counts_df = monthly_counts_df.append(process_year(yearly_df, year), ignore_index=True)
    
# %%

def calculate_annual_statistics_from_monthly_counts(monthly_counts_df):
    """
    Calculate the annual min, max, mean, and std deviation for each year in the monthly_counts_df.

    Parameters:
    monthly_counts_df (pd.DataFrame): A DataFrame with monthly crime counts, indexed by year.

    Returns:
    pd.DataFrame: A DataFrame containing the statistics for each year.
    """
    # Initialize a DataFrame to store the statistics
    stats_df = pd.DataFrame(columns=['Year', 'Min', 'Max', 'Mean', 'StdDev'])

    # Iterate over each row in the monthly_counts_df
    for index, row in monthly_counts_df.iterrows():
        year = row['Year']
        monthly_counts = row.drop('Year')  # Exclude the Year column

        min_value = monthly_counts.min()
        max_value = monthly_counts.max()
        mean_value = monthly_counts.mean()
        std_dev = monthly_counts.std()

        # Append the statistics for this year to the DataFrame
        stats_df = stats_df.append({
            'Year': year,
            'Min': min_value,
            'Max': max_value,
            'Mean': mean_value,
            'StdDev': std_dev
        }, ignore_index=True)

    return stats_df

# Obtain annual summary stats
annual_stats = calculate_annual_statistics_from_monthly_counts(monthly_counts_df)

# %%

def count_unique_neighborhoods(dataframes):
    """
    Count the number of unique neighborhoods for each year.

    Parameters:
    dataframes (dict): A dictionary of DataFrames, keyed by year.

    Returns:
    dict: A dictionary containing the count of unique neighborhoods for each year.
    """
    dataframes = {
        2011: police_df_2011,
        2012: police_df_2012,
        2013: police_df_2013,
        2014: police_df_2014,
        2015: police_df_2015,
        2016: police_df_2016,
        2017: police_df_2017,
        2018: police_df_2018,
        2019: police_df_2019,
        2020: police_df_2020,
        2021: police_df_2021,
        2022: police_df_2022,
    }
    
    unique_counts = {}

    for year, df in dataframes.items():
        unique_neighborhoods = df['Falls within'].nunique()  # Count unique values in 'Falls within'
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

            # Group by 'Falls within' and count occurrences, then find the neighborhood with the maximum count
            if not violence_df.empty:
                max_neighborhood = violence_df.groupby('Falls within').size().idxmax()
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

# Set the 'Year' column as the index for easier plotting
filtered_df = filtered_df.set_index('Year')

# Plotting
plt.figure(figsize=(10, 6))
for year in filtered_df.index:
    plt.plot(filtered_df.columns, filtered_df.loc[year], label=year)

plt.xlabel('Month', fontweight='bold')
plt.ylabel('Count of Violence and Sexual Offences', fontweight='bold')
plt.title('Monthly Counts of Violence and Sexual Offences from 2013 to 2022', fontweight='bold')
plt.xticks(rotation=45)
plt.legend(title='Year')
plt.grid(True)

filename = 'monthly_counts.png'
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

 
    
    