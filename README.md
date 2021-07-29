# Mapping_GA

This project contains an example of how to create a Georgia map plot.

## Step 0. Import Data
```
NGE_List <- readr::read_csv("~/Desktop/2019_NGE_List.csv")
```

## Step 1. Pivot Tables (Filtering and Grouping)
```
str(NGE_List)
# Add column to dataset filled with just 1's to count sum when filtering
NGE_List$count=1
# How to Filter by County
Fulton_P = filter(NGE_List, COUNTY %in% c("FULTON"))
# How to group rows by County, then count the number of rows for each county
County_P <- NGE_List %>% group_by(COUNTY)
County_P <- County_P %>% summarise(sum_count = sum(count))
```

## Step 2. Merging Tables and Math
```
str(NGE_List)
# Add column to dataset filled with just 1's to count sum when filtering
NGE_List$count=1
# How to Filter by County
Fulton_P = filter(NGE_List, COUNTY %in% c("FULTON"))
# How to group rows by County, then count the number of rows for each county
County_P <- NGE_List %>% group_by(COUNTY)
County_P <- County_P %>% summarise(sum_count = sum(count))
```

## Step 3. Shapefile
```
mymap <- st_read("~/Desktop/GA_Counties/GA_Counties.shp", stringsAsFactors = FALSE)
str(mymap)
# Merge map data with County Data
mappingCounty <- inner_join(mymap, County_Ratio)
```

## Step 4. Mapping with ggplot2
```
str(mappingCounty)
# this is where all the formatting of the map is
# the scale fill is just the coloring of the gradient, I used the viridis package here
ggplot(mappingCounty) +
  geom_sf(aes(fill = ratio)) +
  scale_fill_viridis(option="magma") +
  labs(title = "GA 2019 NGE List Cancellations",
       subtitle = "Ratio of Cancellations by Registered Voters per County")

```

## Step 5. Output Map
![Map](https://github.com/dorriehammond/Mapping_GA/blob/main/Tutorial/Ratio2019.pdf)

