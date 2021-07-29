library(sf)
library(ggplot2)
library(dplyr)
library(viridis)

# Import Data from csv file
NGE_List <- readr::read_csv("~/Desktop/2019_NGE_List.csv")

# 1. Pivot Tables, with filters and grouping
str(NGE_List)
# Add column to dataset filled with just 1's to count sum when filtering
NGE_List$count=1
# How to Filter by County
Fulton_P = filter(NGE_List, COUNTY %in% c("FULTON"))
# How to group rows by County, then count the number of rows for each county
County_P <- NGE_List %>% group_by(COUNTY)
County_P <- County_P %>% summarise(sum_count = sum(count))

# 2. Merge Tables to get some ratios
# Import Data from another file (this is from Georgia Registration Statistics)
Active_Voters <- readr::read_csv("~/Desktop/Active_Voters_2020.csv")
# to join, both tables need to have a similar column,
# so I renamed 'county' columns on both files to 'COUNTYUC'
County_P <- County_P %>% rename(COUNTYUC = COUNTY)
Active_Voters <- Active_Voters %>% rename(COUNTYUC = County)
# Join the two files
County_Ratio <- inner_join(County_P, Active_Voters)
# Then create a new column that calculates ratio
County_Ratio$ratio = County_Ratio$sum_count / County_Ratio$`TOTAL VOTERS`*100

# 3. Bring in Shapefile for mapping
mymap <- st_read("~/Desktop/GA_Counties/GA_Counties.shp", stringsAsFactors = FALSE)
str(mymap)
# Merge map data with County Data
mappingCounty <- inner_join(mymap, County_Ratio)

# 4. Mapping the data with ggplot2
str(mappingCounty)
# this is where all the formatting of the map is
# the scale fill is just the coloring of the gradient, I used the viridis package here
ggplot(mappingCounty) +
  geom_sf(aes(fill = ratio)) +
  scale_fill_viridis(option="magma") +
  labs(title = "GA 2019 NGE List Cancellations",
       subtitle = "Ratio of Cancellations by Registered Voters per County")












