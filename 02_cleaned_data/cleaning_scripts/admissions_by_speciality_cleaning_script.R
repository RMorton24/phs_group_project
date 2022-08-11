# Load in libraries

library(tidyverse) 
library(janitor) 
library(lubridate)
library(tsibble)

# Read in data

admissions_by_specialty <- read_csv("01_data/hospitalisations_due_to_covid_19/Admissions_by_health_board_and_specialty.csv") %>% 
  clean_names()

health_board <- read_csv("01_data/healt_board/health_board.csv") %>% 
  clean_names()

# Make week_ending a date

admissions_by_specialty <- admissions_by_specialty %>% 
  mutate(week_ending = ymd(week_ending))

# Join health board to get health board names

admissions_by_specialty <- admissions_by_specialty %>% 
  left_join(health_board, by = "hb") %>% 
  select(-contains("qf"), 
         -id, 
         -hb_date_enacted,
         -hb_date_archived)  
  
  admissions_by_specialty <- admissions_by_specialty %>% 
  mutate(hb_name = case_when(
    hb == "S92000003" ~ "NHS Scotland",
    TRUE ~ hb_name
  )) 

# Write csv

write_csv(admissions_by_specialty, "02_cleaned_data/admissions_by_speciality_clean.csv")
