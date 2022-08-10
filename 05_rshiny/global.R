library(shiny)
library(tidyverse)
library(leaflet)
library(rgeos)
library(sf)
library(htmlwidgets)
library(shinydashboard)
library(shinyWidgets)


# Load relevant data sets

specialty_admissions <- read_csv(here::here("02_cleaned_data/admissions_by_speciality_clean.csv"))

# Load variables/functions for Leaflet Plots ------------------------------

# Load in the region geometry
nhs_borders <- st_read(dsn = here::here("02_cleaned_data/nhs_region_simple"))

# Create labels for region plot
labels_regions <- paste0(
  "<b>", nhs_borders$HBName, "</b><br>", nhs_borders$HBCode
) %>% lapply(htmltools::HTML)

# Create colour pallete "function"
pal <- colorFactor("viridis", domain = nhs_borders$HBCode, 
                   n = nrow(nhs_borders))

# Create the view box for the leaflet
bbox <- st_bbox(nhs_borders) %>% 
  as.vector()