# Author(s): P. Durant
# Contributors: 
# Description: Taxon groups by site

library(tidyverse)
library(ggpubr) # One of many good multi-panel figure packages

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
  # Record each unique genus/species combos for each site
  # Comment these three lines out below to restore to abundance plots
  group_by(site, family, genus, species) %>%
  slice(n = 1) %>%
  ungroup() %>%
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
      fill = order
    ) +
    geom_col() +
    # Formatting
    ggtitle(x) +
    xlab('Number of Identified Species or Genera') +
    ylab(NULL) + # It is clear that these axes are for family imo
    scale_fill_txeeb_orders()
  
}

papo_fam <- family_site_col('Painter Pollinator Garden')
utfs_fam <- family_site_col('UT Farm Stand Gardens')
wcli_fam <- family_site_col('Waller Creek #1 (light)')
wcda_fam <-family_site_col('Waller Creek #2 (dark)')

# Multipanel figure
ggpubr::ggarrange(
  # Panels
  papo_fam, utfs_fam, wcli_fam, wcda_fam,
  # Formatting
  ncol = 2, nrow = 2,
  common.legend = T, legend = 'bottom', 
  align = 'hv'
)
