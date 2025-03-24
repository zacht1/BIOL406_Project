## ======================================================================== ##
# Performing statistical analysis on cleaned data and generating figures for
# final paper.
#
# Date : March 20, 2025
# Persons most responsible : Zach Taylor
## ======================================================================== ##
library(tidyverse)
library(cowplot)
library(readr)
library(here)
library(lme4)
library(lmerTest)

holly_data <- read_csv(here::here("data", "holly_plot_stats.csv"))
ivy_data <- read_csv(here::here("data", "ivy_plot_stats.csv"))


##### ANALYSIS 1 : Soil pH and diversity #####
# Pearson correlation between mean site pH and site shannon diversity for noth 
# English Holly and English Ivy

holly_pearson <- cor.test(holly_data$pH_mean, holly_data$shannon_wiener_index, method = "pearson")
ivy_pearson <- cor.test(ivy_data$pH_mean, ivy_data$shannon_wiener_index, method = "pearson")

holly_ph_plot <- ggplot(holly_data, aes(x=pH_mean, y=shannon_wiener_index)) +
  geom_point(size = 2) +
  stat_smooth(method = "lm", col = "#33456c", linewidth = 0.5, fill = "#6c9ccd", alpha = 0.3) +
  theme_bw() + 
  annotate("text", x = 6.3, y = 1.85, fontface = 'italic', size = 3.5,
           label = paste("r²  =", round(holly_pearson$estimate**2, 3), ", p <",
                         round(holly_pearson$p.value, 3))) + 
  xlab("Soil pH") + 
  ylab("Shannon-Wiener Index") + 
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

ivy_ph_plot <- ggplot(ivy_data, aes(x=pH_mean, y=shannon_wiener_index)) +
  geom_point(size = 2) +
  stat_smooth(method = "lm", col = "#33456c", linewidth = 0.5, fill = "#6c9ccd", na.rm = T, alpha = 0.3) +
  theme_bw() + 
  annotate("text", x = 6.5, y = 1.75, fontface = 'italic', size = 3.5,
           label = paste("r²  =", round(ivy_pearson$estimate**2, 4), ", p =",
                         round(ivy_pearson$p.value, 3))) + 
  xlab("Soil pH") + 
  ylab("Shannon-Wiener Index") + 
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

diversity_ph_plots <- plot_grid(holly_ph_plot, ivy_ph_plot, labels = "AUTO")
ggsave(here::here("figures", "diversty_ph_correlation.png"))

diversity_ph_plots

##### ANALYSIS 2 : pH in invaded vs control sites #####
#   investigating how pH varies 
# between control and invaded sites for both English Holly and English Ivy

# might be better and simple to use ANOVA, gives a better p value but doesn't ]
# take into account repeated measurements in same plot. Is it important to
# take into account within plot variation

# convert pH data to long format
holly_data_long <- holly_data %>%
  pivot_longer(cols = starts_with("pH"), names_to = "pH_sample", values_to = "pH") %>%
  filter(pH_sample != "pH_mean") %>%
  mutate(distance = ifelse(pH_sample == "pH1", 0, ifelse(pH_sample == "pH2", 0.5, 1.5)),
         invasive_type = "holly")

ivy_data_long <- ivy_data %>%
  pivot_longer(cols = starts_with("pH"), names_to = "pH_sample", values_to = "pH") %>%
  filter(pH_sample != "pH_mean")  %>%
  mutate(distance = ifelse(pH_sample == "pH1", 0, ifelse(pH_sample == "pH2", 0.5, 1.5)),
         invasive_type = "ivy")

# testing correlation between distance from invasive species (pH sample number) and soil pH
holly_ph_dist <- cor.test(holly_data_long$distance, holly_data_long$pH)
ivy_ph_dist <- cor.test(ivy_data_long$distance, ivy_data_long$pH)

# linear mixed-effects models
model_simple <- lmer(pH ~ site_type + (1 | plot_id), data = holly_data_long)  # no distance
model_quad <- lmer(pH ~ site_type * (distance + I(distance^2)) + (1 | plot_id), data = holly_data) # interaction model, non-linear relationship between distance and pH  
model_full <- lmer(pH ~ site_type * distance + (1 | plot_id), data = holly_data_long)  # interaction model, linear relationship between distance and pH

model_forest <- lmer(pH ~ site_type * forest_type + (1 | plot_id), data = holly_data_long)

summary(model_simple)  # model summary

# random effects: residual variance (intra) is much higher than plot variance (inter) => site-level variation so
#  LME more appropriate than ANOVA

anova(model_simple, model_full)  # comparing model fits
qqline(resid(model)) # examine residuals (checking for normality) to check model assumptions

# plotting, bar chart

# combine data sets
data_long <- rbind(holly_data_long, ivy_data_long)

# grouped box plots by control and invaded for invasive species type
combined_ph_plot <- ggplot(data_long, aes(x = invasive_type, y = pH, fill = site_type)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  # geom_point(size = 2, alpha = 0.7) +
  theme_bw() +
  ylim(min(data_long$pH, na.rm=T)-0.2, max(data_long$pH, na.rm=T)+0.2) +
  labs(x = "Invasive Species", y = "Soil pH", fill = "Site Type") +
  scale_fill_manual(values = c("control" = "#b1d9eb", "invaded" = "#47577a")) +
  scale_x_discrete(labels=c("Ilex aquifolium","Hedera helix")) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(here::here("figures", "combined_ph_boxplot.png"))
combined_ph_plot

# subplot of individual box plots for each invasive species
holly_ph_boxplot <- ggplot(holly_data_long, aes(x = site_type, y = pH, fill = site_type)) +
  geom_boxplot(alpha = 0.6) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  theme_bw() +
  ylim(min(holly_data_long$pH, na.rm=T)-0.2, max(holly_data_long$pH, na.rm=T)+0.2) +
  labs(x = "Site Type", y = "Soil pH") +
  scale_fill_manual(values = c("control" = "#b1d9eb", "invaded" = "#47577a")) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )

ivy_ph_boxplot <- ggplot(ivy_data_long, aes(x = site_type, y = pH, fill = site_type)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  theme_bw() +
  ylim(min(ivy_data_long$pH, na.rm=T)-0.2, max(ivy_data_long$pH, na.rm=T)+0.2) +
  labs(x = "Site Type", y = "Soil pH") +
  scale_fill_manual(values = c("control" = "#b1d9eb", "invaded" = "#47577a")) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )

ph_boxplots <- plot_grid(holly_ph_boxplot, ivy_ph_boxplot, labels = "AUTO")
ggsave(here::here("figures", "ph_boxplot_subplot.png"))
ph_boxplots


# box plot for pH differences in deciduous and coniferus forests
forest_ph_boxplot <- ggplot(data_long, aes(x = forest_type, y = pH_mean)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  theme_bw() +
  ylim(min(data_long$pH, na.rm=T)-0.2, max(data_long$pH, na.rm=T)+0.2) +
  labs(x = "Forest Type", y = "Soil pH") +
  scale_fill_manual(values = c("Coniferus" = "#b1d9eb", "Deciduous" = "#47577a")) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )



