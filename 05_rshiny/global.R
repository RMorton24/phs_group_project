library(shiny)
library(leaflet)
library(rgeos)

nhs_borders <- st_read(dsn = "../01_data/geospatial_data/SG_NHS_HealthBoards_2019/", 
                       layer = "SG_NHS_HealthBoards_2019") %>% 
  st_simplify(dTolerance = 2500) %>% 
  st_transform('+proj=longlat +datum=WGS84')

labels <- paste0(
  "<b>", nhs_borders$HBName, "</b><br>", nhs_borders$HBCode
) %>% lapply(htmltools::HTML)

pal <- colorFactor("viridis", domain = nhs_borders$HBCode, 
                   n = nrow(nhs_borders))

bbox <- st_bbox(nhs_borders) %>% 
  as.vector()