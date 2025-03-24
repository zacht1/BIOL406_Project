## ======================================================================== ##
# Exploratory analysis for determining further statistical analysis methods.
#
# Date : March 20, 2025
# Persons most responsible : Zach Taylor
## ======================================================================== ##
library(tidyverse)
library(cowplot)
library(here)
library(lmerTest)
library(lme4)

# important cleaned data
holly_data <- read_csv(here::here("data", "holly_plot_stats.csv"))
ivy_data <- read_csv(here::here("data", "ivy_plot_stats.csv"))

# check for normal distribution
ggplot(holly_data, aes(x = site_type, y = pH_mean)) +
  geom_boxplot() +
  geom_jitter(width = 0.1, alpha = 0.5) +
  theme_minimal()

shapiro.test(holly_data$pH_mean)

# try Linear Mixed-Effects Model (LME)
holly_data_long <- holly_data %>%
  pivot_longer(cols = starts_with("pH"), names_to = "pH_sample", values_to = "pH") %>%
  filter(pH_sample != "pH_mean")

ivy_data_long <- ivy_data %>%
  pivot_longer(cols = starts_with("pH"), names_to = "pH_sample", values_to = "pH") %>%
  filter(pH_sample != "pH_mean")

# Check the new structure
head(data_long)

# Fit LME model with site type and spatial position as fixed effects
model <- lmer(pH ~ site_type * pH_sample + (1 | plot_id), data = holly_data_long)

# ANOVA to test effects
anova(model, ddf = "Kenward-Roger")

# included pH sample distance in model
holly_data_long$distance <- ifelse(holly_data_long$pH_sample == "pH1", 0, 
                             ifelse(holly_data_long$pH_sample == "pH2", 0.5, 1.5))

model_distance <- lmer(pH ~ site_type * distance + (1 | plot_id), data = holly_data_long)
summary(model_distance)



model_simple <- lmer(pH ~ site_type + (1 | plot_id), data = holly_data_long)  # No distance
model_full <- lmer(pH ~ site_type * distance + (1 | plot_id), data = holly_data_long)  # Interaction model

anova(model_simple, model_full)


