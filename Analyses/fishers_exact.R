# Author(s): P. Durant
# Contributors: 
# Description: Fishers exact test 

require(tidyverse)
bug_data <- read.csv('./Data/CLEAN_PRELIM_EEBClub_UTICdata_Weather_v2.csv')

#### Contingency Table 1 ####
# Are the insect communities different across sites?
# Columns: 4 sites
# Rows: Taxa

# Order-family level
bug_data %>%
  select(site, order, family) %>%
  # Keep only the four main sites
  filter(site != 'Misc' & site != 'UT Campus') %>%
  # Just use presence or absence of number of families
  group_by(family) %>%
  slice(n = 1) %>%
  ungroup() %>%
  # Reshape data so that each site has a column
  mutate(
    site = gsub(pattern = ' ', replacement = '_', x = site),
    site = gsub(pattern = '#|\\)|\\(', replacement = '', x = site), 
    site = tolower(site),
    # Necessary to get counts of number of taxa present
    presence = 1,
  ) %>%
  pivot_wider(
    names_from = site, 
    values_from = presence, 
    id_cols = c('order', 'family')
  ) %>%
  # Replace NAs with 0
  mutate_all(replace_na, 0) %>%
  # Add up different family observations by order
  group_by(order) %>%
  summarise(across(waller_creek_2_dark:waller_creek_1_light))
  




#### Contingency Table 2 ####
# Are undergrads better at sampling insect diversity than iNaturalist?
# Columns: TX EEB or iNat
# Rows: Order
# Subset data to make tables for each site
