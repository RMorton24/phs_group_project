library(shiny)
library(tidyverse)
library(leaflet)
library(sf)
library(htmlwidgets)
library(shinydashboard)
library(shinyWidgets)
library(bslib)
library(tsibble)




# Load relevant data sets

activity_patient_demographics <- read_csv(here::here("02_cleaned_data/activity_patient_demographics.csv")) 

specialty_admissions <- read_csv(here::here("02_cleaned_data/admissions_by_speciality_clean.csv"))

activity_deprivation <- read_csv(here::here("02_cleaned_data/activity_deprivation.csv"))

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




# Beds data ---------------------------------------------------------------

beds <- read_csv(here::here("02_cleaned_data/bed_clean.csv")) %>% 
  mutate(year_quarter = yearquarter(year_quarter))

variables_selection <- beds %>% 
  select(contains(c("bed", "occup"))) %>%  names()