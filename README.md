# **Influence of H. helix (English Ivy) and I. aquifolium (English Holly) on soil pH and Shannon’s Diversity Index in Both Coniferous and Deciduous Forests**

This project repository contains scripts and data used to invastigate this topic. All scripts and data authored/collected by Zach Taylor, Mobina Aghili, Roxana Kazemi Arbat and Omer Ahmad.

### Data Collection Methodology
Data collection focused on how the presence of either invasive species affected soil acidity as well as species compositions and percentage covers in both forest types. Coniferous data were gathered along the Douglas Fir trail leading to the Council trail, and deciduous data were collected along the Camosun trail near Pacific Spirit Park in Vancouver, BC. Data collection followed a pairwise approach: invaded plots were established by venturing a certain depth/distance into the forest until the target invasive species was encountered, and corresponding control plots were identified by moving parallel to the trail, reaching a similar forest depth where the invasive species was absent. Quadrat-based sampling was conducted across 8 total sites, with 4 invaded plots (2 coniferous, 2 deciduous) and 4 control plots (2 coniferous, 2 deciduous). Soil samples were taken right by the invasive species plant (sample 1), 0.5m away (sample 2) and 2m away (sample 3) about 2-3 inches deep in invaded plots, and 3 measurements were taken from uninvaded plots approximately at the center (sample 2) and 2m in either direction (samples 1 and 3). Species cover and identities were determined by referring to a plant identifier app when unknown or simply the provided species identification guide, and individual estimates were refined through consensus until a reliable value was reached collectively; additionally, qualitative covariates such as canopy cover, estimated percentage of sunlight, presence of other invasive species and slope differences, and soil moisture were recorded comparatively for plots. This study aims to examine whether sites invaded by English ivy or English holly show considerable differences in soil pH compared to the uninvaded areas and whether their presence leads to lower Shannon diversity due to competitive exclusion. It also explores how these differences vary between deciduous and coniferous forests. 
The soil samples for English Holly 1 and 2, English Ivy 1 and 2 invaded plot and control plots at the Douglas Fir trail leading to Council Trail were taken on Thursday, March 6th, at 12-3:30 p.m., pH tests were conducted on Wednesday, March 12th at 10:30 p.m for Ivy 2, while the remainder were done the following day, March 13th at 11 a.m. The soil samples for English Holly 4 invaded plot, and its control plot along the Camosun trail were taken Tuesday, March 11th at 2:30 p.m., pH tests were conducted on Wednesday, March 12th at 10:30 p.m. The soil samples for English Holly 3, Ivy 3 and 4 and the corresponding control plots along the Camosun trail were taken Sunday at 4:00 p.m., pH tests were conducted on Thursday, March 13th, at 11 a.m. 

### Repository Contents:

##### Scripts Folder
1. **data_cleaning.R** : R script for the cleaning, formatting and summarisation of the raw field data. This script imports the raw data file (raw_site_data.csv), re-formats it for easier use, calculates some summary statistics and indices for further analysis and writes the resulting data to file (see below).

##### Data Folder
1. **raw_site_data.csv** : raw data collected in the field. Data contains 28 columns; Plot, Forest Type, Percent cover for species (columns 3-23), Canopy Cover (%), Sample 1-3 pH, Site Characteristics. 
    - Plot: nominal level, categorical data type, invasive species name + trial # + indication of control or not. 
    - Forest Type: nominal level, categorical data type, either Coniferous or Deciduous. 
    - Species Percent Cover (columns 3-23): ratio level, numeric data type, each column is a species indicating relative cover as a percentage. Listed in order: English Holly, English Ivy, Trailing Blackberry, Spiny wood fern, Salal, Walla lettuce, Sword fern, Deer fern, Huckleberry, Species 2 (a potentially different blackberry species), Sugar-scoop, Salmon BErry, Elderberry, Herb Robert, Large-leaved avens, Creeping buttercup, Oregon grape, Common Snowberry, Tall Fescue and Cherry Laurel. 
    - Moss cover: numeric data type, a percentage of the amount of moss covering the landscape, although moss species were not differentiated.
    - Canopy Cover: numeric data type, a percentage indicating the amount of overhead cover. 
    - Sample 1-3 pH measure columns: numeric data type, ranging between 5.0 and 7.0, (some missing values present which will be completed once we get the extra kit). 
    - Site Characteristics: character/string data type, indicating dampness, elevation (completely flat, slight, or gradual slope) and direction of elevation (North, South, etc.)<br>

2. **ivy_plot_stats.csv** : A data frame containing species percent cover data, pH measurements, and calculated statistics for English Ivy-invaded plots and control plots. Columns are as follows: 
    - Plot: Nominal, categorical data type. Identifies the plot (e.g., "Ivy 1", "Ivy 1 Control"). 
    - Forest Type: Nominal, categorical data type (Coniferous/Deciduous) forests. 
    - Species Percent Cover (columns 3-23): Numeric data type, represents percent cover of each species found in the plot. Canopy Cover (%): Numeric data type represents percentage of overhead canopy cover. 
    - Sample 1-3 pH: Numeric data type, soil pH measurements taken at three different spots within the plot (some missing values present, which will be completed once we get the extra kit). 
    - Site Characteristics: Character/string data type which describes environmental conditions (e.g., elevation, slope, moisture). 
    - Species Richness: Numeric data type describing the total number of unique species recorded in the plot. 
    - Mean Percent Cover: Numeric data type. Average percent cover across species in the plot. 
    - Standard Deviation of Percent Cover: Numeric data type. Variation in percent cover values. 
    - Shannon Diversity Index: Numeric data type. Measures species diversity within the plot. 
    - Mean pH: Numeric data type. Average of Sample 1-3 pH values (some missing values present again).<br>


3. **holly_plot_stats.csv** : A data frame containing species percent cover data, pH measurements, and calculated statistics for English Holly-invaded plots and control plots. Columns are as follows: 
    - Plot: Nominal, categorical data type. Identifies the plot (e.g., "Holly 1", "Holly 1 Control").
    - Forest Type: Nominal, categorical data type (Coniferous/Deciduous) forests. 
    - Species Percent Cover (Columns 3-23): Numeric data type, represents percent cover of each species found in the plot. 
    - Canopy Cover (%): Numeric data type represents percentage of overhead canopy cover. 
    - Sample 1-3 pH: Numeric data type, soil pH measurements taken at three different spots within the plot (some missing values present, which will be completed once we get the extra kit). 
    - Site Characteristics: Character/string data type which describes environmental conditions (e.g., elevation, slope, moisture). 
    - Species Richness: Numeric data type describing the total number of unique species recorded in the plot. 
    - Mean Percent Cover: Numeric data type. Average percent cover across species in the plot. 
    - Standard Deviation of Percent Cover: Numeric data type. Variation in percent cover values. 
    - Shannon Diversity Index: Numeric data type. Measures species diversity within the plot. 
    - Mean pH: Numeric data type. Average of Sample 1-3 pH values (some missing values present again).<br>


4. **ivy_plot_species.csv** : long format data frame containing species percent cover data for English Ivy plots and control plots. Data contains 5 columns; Plot, Forest Type, Site Characteristics, Species, and Percent Cover. 
    - *Plot*: nominal level, categorical data type, Ivy followed by the plot # (trial) and followed by an indication of control if applicable.
    - *Forest Type*: nominal level, categorical data type, indicating Coniferous or Deciduous. 
    - *Site Characteristics*: character/string data type, elevation (completely flat, slight, or gradual slope) and direction of elevation(North, South, etc), and environmental moisture are indicated. 
    - *Species*: string or nominal data representing the species identities found in the plot. 
    - *Percent Cover*: numeric data type (%) indicating the percentage of a species found in plots.<br>


5. **holly_plot_species.csv** : long format data frame containing species percent cover data for English Holly plots and control plots. Data contains 5 columns; Plot, Forest Type, Site Characteristics, Species, and Percent Cover. 
    - Plot: nominal level, categorical data type, Holly followed by the plot number (trial) and followed by an indication of control if applicable.
    - Forest Type: nominal level, categorical data type, indicating Coniferous or Deciduous. 
    - Site Characteristics: character/string data type, elevation (completely flat, slight, or gradual slope) and direction of elevation (North, South, etc), and environmental moisture are indicated. 
    - Species: string or nominal data representing the species identities found in the plot. Percent Cover: numeric data type (%) indicating the percentage of a species found in plots. 
