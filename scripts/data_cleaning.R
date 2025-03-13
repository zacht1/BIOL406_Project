library(tidyverse)
library(readr)
library(here)

# import raw field data
raw_data <- read_csv(here::here("data", "raw_site_data.csv"))

# extract English Holly and English Ivy data into separate data frames
holly_data <- raw_data %>% filter(grepl("Holly", Plot, fixed = T))
ivy_data <- raw_data %>% filter(grepl("Ivy", Plot, fixed = T))

