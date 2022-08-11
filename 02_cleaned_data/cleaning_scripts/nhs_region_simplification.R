## Script Information -------------------------------------------------------
##
## Script name:  nhs_region_simplification.R
##
## Purpose of script: 
##  The purpose of this script is to simplify the geomerty of the NHS 
##  health board regions. This is to improve the user experience in the Rshiny 
##  app by reducing load times.
##
## Author: Ross Morton
##
## Date Created: 2022/08/09
## 
## Output:
##  nhs_region_simple geometry-
##        nhs_region_simple.dbf
##        nhs_region_simple.prj
##        nhs_region_simple.shp
##        nhs_region_simple.shx
##                      
## 
##
##/////////////////////////////////////////////////////////////////////////////
##
## Notes:
##   Packages required to be installed-
##        {tidyverse}
##        {here}
##        {sf}
##
##
##    Data file require:
##        SG_NHS_HealthBoards_2019.shp
##
## ////////////////////////////////////////////////////////////////////////////



# Load in Libraries -------------------------------------------------------
library(tidyverse)
library(sf)



# Load in NHS region shape ------------------------------------------------

nhs_borders <- st_read(
  dsn = here::here("01_data/geospatial_data/SG_NHS_HealthBoards_2019/"), 
  layer = "SG_NHS_HealthBoards_2019") %>% 
  st_simplify(dTolerance = 2500) %>% 
  st_transform('+proj=longlat +datum=WGS84')


# Save NHS simplified regions ---------------------------------------------
suppressWarnings({
  st_write(nhs_borders,
           dsn = here::here("02_cleaned_data/nhs_region_simple"),
           driver = "ESRI Shapefile")
}, classes = "warning")


