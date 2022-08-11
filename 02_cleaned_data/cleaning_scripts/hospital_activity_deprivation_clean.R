## Script Information -------------------------------------------------------
##
## Script name:  hospital_activity_deprivation_clean.R
##
## Purpose of script: 
##  The purpose of this script is to clean the hospital activity deprivation
##  data. This is then joined on to the main data with more information on the
##  healthboard regions/hospital locations.
##
## Author: Joao Neto
##
## Date Created: 2022/08/11
## 
## Output:
##        activity_patient_demographics.csv - cleaned file of raw data
##                      
## 
##
##/////////////////////////////////////////////////////////////////////////////
##
## Notes:
##   Packages required to be installed-
##        {tidyverse}
##        {here}
##        
##
##
##    Data file require:
##        hospital_ativity_and_patient_demographics.csv
##        hospitals.csv
##        special_health_boards.csv
##
##
## ////////////////////////////////////////////////////////////////////////////


# Load Libraries ----------------------------------------------------------

library(tidyverse)


# Load in the data --------------------------------------------------------


hospital_ativity_and_patient_demographics <- 
  read_csv(here::here("01_data/hospital_ativity_and_patient_demographics.csv")) %>% 
  clean_names()

# Load additional information to be used for join

hospitals <- read_csv(here::here("01_data/healt_board/hospitals.csv")) %>% 
  clean_names()

hb <- read_csv(here::here("01_data/healt_board/health_board.csv")) %>% 
  clean_names()

shb <- read_csv(here::here("01_data/healt_board/special_health_boards.csv")) %>% 
  clean_names()


# Cleaning/Wrangling -----------------------------------------------------------

### hospital_ativity_and_patient_demographics

activity_patient_demographics <- hospital_ativity_and_patient_demographics %>% 
  mutate(year    = str_sub(quarter, 1, 4), .after = id,
         year    = as.numeric(year),
         quarter = str_sub(quarter, 6), 
         quarter = as.numeric(quarter),
         shb      = if_else(nchar(hb) == 6, hb, NA_character_),
         hb       = if_else(nchar(hb) == 9 & str_detect(hb, '^S08'), hb, NA_character_),
         location = if_else(nchar(location) == 5, location, NA_character_),
         age = str_remove(age, pattern = " years")) %>%
  left_join(x = .,
            y = hb, 
            by = "hb", 
            suffix = c("", "_hb_suffix")) %>% 
  left_join(x = .,
            y = shb, 
            by = "shb", 
            suffix = c("", "_shb_suffix")) %>%
  left_join(x = .,
            y = hospitals, 
            by = "location", 
            suffix = c("", "_hospital_suffix")) %>% 
  select(!ends_with(c("_suffix", "qf"))) %>% 
  relocate(c(20:23, 28:29), .after = 16) %>% 
  select(c(1:22))



# Write the output --------------------------------------------------------

activity_patient_demographics %>% 
  write.csv(here::here("02_cleaned_data/activity_patient_demographics.csv"))
