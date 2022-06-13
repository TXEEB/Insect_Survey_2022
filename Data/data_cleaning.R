library(readxl)
library(dplyr)

#### Tidying ####

prelim_data <- read_xlsx('./Data/CLEAN_PRELIM_EEBClub_UTICdata_Weather.xlsx')

tidy_data <- prelim_data %>%
  # Remove uninformative columns
  select(
    -Country, 
    -State, 
    -County, 
    -storageLocation) %>%
  # Make column names consistent
  rename(
    cataloger_first = `cataloger firstName`,
    cataloger_last = `cataloger lastName`,
    catalog_date = catalogedDate,
    collector_first1 = `collector first name1`,
    collector_last1 = `collector last name1`,
    collector_first2 = `collector first name2`,
    collector_last2 = `collector last name2`,
    start_date = startDate,
    end_date = endDate,
    collecting_method = `collecting method`,
    collector_number = collectorNumber,
    latitude = `latitude 1`,
    longitude = `longitude 1`,
    site = localityName,
    collection_notes = `Collection Notes`,
    determined_date = determinedDate,
    determiner_first = `determiner first Name1`,
    determiner_last = `determiner last Name1`,
    order = Order1,
    family = Family1,
    genus = Genus1,
    species = Species1,
    prep_type = prepType,
    preparer_last = prep_by_LastName,
    preparer_first = prep_by_FirstName,
    count = Count,
    stage = Stage,
    sex = Sex,
    catalog_number = catalogNumber,
    cataloging_notes = `cataloging notes`,
    temp_record = `Temperature (F)`,
    temp_ext = `Temperature (F) - external`,
    cloudy = `Cloudy/Sunny`,
    humid_record = `Humidity (%)`,
    humid_ext = `Humidity (%) - external`
  ) %>%
  # Create column of combined temperature and humidity in case of missing data
  # Coerce cloudy/sunny data to boolean
  mutate(
    temp_comb = if_else(!is.na(temp_record), temp_record, temp_ext),
    humid_comb = if_else(!is.na(humid_record), humid_record, humid_ext),
    cloudy = if_else(cloudy == 'Cloudy', T, F)
  )

write.csv(tidy_data, './Data/CLEAN_PRELIM_EEBClub_UTICdata_Weather_v2.csv')
