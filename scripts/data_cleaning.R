## ======================================================================== ##
# Cleaning, re-formatting and generating summary statistics for raw field data.
# Generates and writes four .csv files to ./data
#
# Date : March 13, 2025
# Persons most responsible : Zach Taylor
## ======================================================================== ##
library(tidyverse)
library(readr)
library(here)

# import raw field data
raw_data <- read_csv(here::here("data", "raw_site_data.csv")) %>%
  rename("Mosses" = "Moss Cover (%)")

# extract English Holly and English Ivy data into separate data frames
holly_data <- raw_data %>% filter(grepl("Holly", Plot, fixed = T))
ivy_data <- raw_data %>% filter(grepl("Ivy", Plot, fixed = T))

# change ivy and holly data to long format, containing data for percent cover (excluding pH data from these data frames)
holly_cover_data <- holly_data %>%
  select(-`Sample 1 pH`, -`Sample 2 pH`, -`Sample 3 pH`, -`Canopy cover (%)`) %>%
  pivot_longer(cols = -c(Plot, `Forest Type`, `Site Characteristics`),
               names_to = "Species", values_to = "Percent Cover")

ivy_cover_data <- ivy_data %>%
  select(-`Sample 1 pH`, -`Sample 2 pH`, -`Sample 3 pH`, -`Canopy cover (%)`) %>%
  pivot_longer(cols = -c(Plot, `Forest Type`, `Site Characteristics`),
               names_to = "Species", values_to = "Percent Cover")

write_csv(holly_cover_data, here::here("data", "holly_plot_species.csv"))
write_csv(ivy_cover_data, here::here("data", "ivy_plot_species.csv"))

# calculating species diversity and .... for ivy and holly plot
ivy_stats <- ivy_cover_data %>% 
  group_by(Plot) %>% 
  filter(`Percent Cover` > 0 & Species != "Mosses") %>%  # remove mosses
  mutate(Total_Cover = sum(`Percent Cover`),   # total cover per plot
         p_i = `Percent Cover` / Total_Cover,  # proportion of each species
         p_log_p = p_i * log(p_i)) %>%         # used for Shannon diversity index calculation
  summarise("Species Richness" = n_distinct(Species),
            "Mean Percent Cover" = mean(`Percent Cover`),
            "Standard Deviation of Percent Cover" = sd(`Percent Cover`),
            "Shannon Diversity Index" = -sum(p_log_p, na.rm = TRUE))

holly_stats <- holly_cover_data %>% 
  group_by(Plot) %>% 
  filter(`Percent Cover` > 0 & Species != "Mosses") %>%  # remove mosses
  mutate(Total_Cover = sum(`Percent Cover`),   # total cover per plot
         p_i = `Percent Cover` / Total_Cover,  # proportion of each species
         p_log_p = p_i * log(p_i)) %>%         # used for Shannon diversity index calculation
  summarise("Species Richness" = n_distinct(Species),
            "Mean Percent Cover" = mean(`Percent Cover`),
            "Standard Deviation of Percent Cover" = sd(`Percent Cover`),
            "Shannon Diversity Index" = -sum(p_log_p, na.rm = TRUE))

# add stats back into holly and ivy data frames
holly_data <- merge(holly_data, holly_stats, by="Plot") %>%
  mutate(`Mean pH` = rowMeans(  # adding column for mean pH of all samples
    across(c(`Sample 1 pH`, `Sample 2 pH`, `Sample 3 pH`)), na.rm = TRUE
    ))

ivy_data <- merge(ivy_data, ivy_stats, by="Plot") %>%
  mutate(`Mean pH` = rowMeans(  # adding column for mean pH of all samples
    across(c(`Sample 1 pH`, `Sample 2 pH`, `Sample 3 pH`)), na.rm = TRUE
  ))

write_csv(holly_data, here::here("data", "holly_plot_stats.csv"))
write_csv(ivy_data, here::here("data", "ivy_plot_stats.csv"))

