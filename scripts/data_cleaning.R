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
raw_data <- read_csv(here::here("data", "raw_data", "site_data.csv")) %>%
  rename("mosses" = "moss_cover")

# extract English Holly and English Ivy data into separate data frames
holly_data <- raw_data %>% filter(grepl("Holly", plot_id, fixed = T))
ivy_data <- raw_data %>% filter(grepl("Ivy", plot_id, fixed = T))

# change ivy and holly data to long format, containing data for percent cover (excluding pH data from these data frames)
holly_cover_data <- holly_data %>%
  select(-c(pH1, pH2, pH3, canopy_cover, site_characteristics)) %>%
  pivot_longer(cols = -c(plot_id, forest_type),
               names_to = "species", values_to = "percent_cover")

ivy_cover_data <- ivy_data %>%
  select(-c(pH1, pH2, pH3, canopy_cover, site_characteristics)) %>%
  pivot_longer(cols = -c(plot_id, forest_type),
               names_to = "species", values_to = "percent_cover")

write_csv(holly_cover_data, here::here("data", "holly_species_long.csv"))
write_csv(ivy_cover_data, here::here("data", "ivy_species_long.csv"))

# calculating species diversity and .... for ivy and holly plot
ivy_stats <- ivy_cover_data %>% 
  group_by(plot_id) %>% 
  filter(percent_cover > 0 & species != "mosses") %>%  # remove mosses
  mutate(total_cover = sum(percent_cover),   # total cover per plot
         p_i = percent_cover / total_cover,  # proportion of each species
         p_log_p = p_i * log(p_i)) %>%         # used for Shannon diversity index calculation
  summarise("species_richness" = n_distinct(species),
            "mean_percent_cover" = mean(percent_cover),
            "percent_cover_sd" = sd(percent_cover),
            "shannon_wiener_index" = -sum(p_log_p, na.rm = TRUE))

holly_stats <- holly_cover_data %>% 
  group_by(plot_id) %>% 
  filter(percent_cover > 0 & species != "mosses") %>%  # remove mosses
  mutate(total_cover = sum(percent_cover),   # total cover per plot
         p_i = percent_cover / total_cover,  # proportion of each species
         p_log_p = p_i * log(p_i)) %>%         # used for Shannon diversity index calculation
  summarise("species_richness" = n_distinct(species),
            "mean_percent_cover" = mean(percent_cover),
            "percent_cover_sd" = sd(percent_cover),
            "shannon_wiener_index" = -sum(p_log_p, na.rm = TRUE))

# add stats back into holly and ivy data frames
holly_data <- merge(holly_data, holly_stats, by="plot_id") %>%
  mutate(pH_mean = rowMeans(across(c(pH1, pH2, pH3)), na.rm = TRUE))  # adding column for mean pH of all samples 

ivy_data <- merge(ivy_data, ivy_stats, by="plot_id") %>%
  mutate(pH_mean = rowMeans(across(c(pH1, pH2, pH3)), na.rm = TRUE))  # adding column for mean pH of all samples

# add column to data frames to easily distinguish control vs invaded sites
holly_data <- holly_data %>% 
  mutate(site_type = ifelse(grepl("Control", plot_id, fixed = T), "control", "invaded"))

ivy_data <- ivy_data %>%
  mutate(site_type = ifelse(grepl("Control", plot_id, fixed = T), "control", "invaded"))

write_csv(holly_data, here::here("data", "holly_plot_stats.csv"))
write_csv(ivy_data, here::here("data", "ivy_plot_stats.csv"))

