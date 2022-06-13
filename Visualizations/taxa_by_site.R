# Author(s): P. Durant
# Contributors: 
# Description: Taxon groups by site

library(tidyverse)

bug_data <- read.csv('./Data/CLEAN_PRELIM_EEBClub_UTICdata_Weather_v2.csv')

#### Create Table of Data of All Taxonomic Info ###

taxa_data <- bug_data %>%
  select(order, family, genus, species) %>%
  # Make sure species are lowercase
  mutate(species = tolower(species)) %>%
  group_by(genus, species) %>%
  # Keep only 1 row for each unique genus/species combos
  slice(n = 1) %>%
  # Create column for scientific names
  mutate(
    binomial = if_else(
      is.na(species),
      # Use spp. if species is unknown
      paste(genus, 'spp.', sep = ' '),
      paste(genus, species, sep = ' ')
    )
  ) %>%
  ungroup()

#write.csv(taxa_data, './data/EEBCLUB_TAXA.csv')


#### Families by Site ####

family_site <- bug_data %>%
  # Keep only the four main sites
  filter(site != 'Misc' & site != 'UT Campus') %>%
  mutate(species = tolower(species)) %>%
  # Group by site and family
  group_by(site, family) %>%
  # Number of each family at each site
  count(name = 'number') %>%
  ungroup()

# Pull order data from taxa dataset
order_family <- taxa_data %>%
  select(order, family) %>%
  group_by(family) %>%
  slice(n = 1)

family_site <- family_site %>%
  left_join(order_family, by = 'family')

family_site_col <- function(x) {

family_site %>%
  # Plot bar plot for pollinator garden
  filter(site == x) %>%
  drop_na() %>%
  ggplot() +
  aes(
    x = number, 
    y = fct_reorder(family, number),
    fill = fct_reorder(order, -number)
  ) +
  geom_col() +
  # Formatting
  ggtitle(x) +
  xlab('Individuals') +
  ylab('Family') +
  scale_fill_discrete(name = 'Order')
  
}

family_site_col('Painter Pollinator Garden')
family_site_col('UT Farm Stand Gardens')
family_site_col('Waller Creek #1 (light)')
family_site_col('Waller Creek #2 (dark)')