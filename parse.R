library(tidyverse)
library(sf)
library(leaflet)
library(htmltools)

# Original data from Maanmittauslaitos retuned as an XML file
# https://www.maanmittauslaitos.fi/asioi-verkossa/avoimien-aineistojen-tiedostopalvelu
# nimet.csv transformed from XML with XSLT
data <- read.csv(file = "nimet.csv", header = FALSE, encoding = "UTF-8", stringsAsFactors = FALSE)

# Few rows of bad data
names <- data[2:800827,]

rm(data)
gc()

names_latlon <- names %>% 
  mutate(V1 = str_trim(V1, side = "both")) %>% 
  separate(V1, into = c("x", "y"), sep = "\\s")

names_latlon <- names_latlon %>% 
  filter(!is.na(y)) %>% 
  filter(!is.na(V2)) %>% 
  filter(grepl("[0-9]",x))

names(names_latlon) <- c("lat", "lon", "nimi", "kieli")

names_latlon_sf <- st_as_sf(names_latlon, coords = c("lat", "lon"), crs = 3067)

names_latlon_sf_4326 <- st_transform(names_latlon_sf, crs = 4326)

rm(names)
rm(names_latlon)
rm(names_latlon_sf)
gc()

fin <- names_latlon_sf_4326 %>% 
  filter(kieli == 'fin')

swe <- names_latlon_sf_4326 %>% 
  filter(kieli == 'swe')

rm(names_latlon_sf_4326)
gc()

data_fi <- fin %>% 
  filter(grepl("kartano|järvi|vesi|lampi", nimi))

data_sw <- swe %>% 
  filter(grepl("gård|sjö|träsk|vatten", nimi))

data <- rbind(data_fi, data_sw)

data <- data %>% 
  arrange(nimi)

saveRDS(data, "mapdata.RDS")

