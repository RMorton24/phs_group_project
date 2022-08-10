#### Cleaning beds data ------

# Load in libraries

library(tidyverse) 
library(janitor) 
library(lubridate)
library(tsibble)
library(slider)
library(feasts)

# Load in data

beds <- read_csv("https://www.opendata.nhs.scot/dataset/554b0e7a-ccac-4bb6-82db-1a8b306fcb36/resource/f272bb7d-5320-4491-84c1-614a2c064007/download/beds_by_nhs_board_of_treatment_and_specialty.csv") %>% 
  clean_names()

health_board <- read_csv("01_data/healt_board/health_board.csv") %>% 
  clean_names()

special_health_board <- read_csv("01_data/healt_board/special_health_boards.csv") %>% 
  clean_names()

# Make quarter a date

beds <- beds %>% 
  separate(quarter, c("year", "quarter"), "Q") %>% 
  mutate(year = as.numeric(year), 
         quarter = as.numeric(quarter)) %>% 
  mutate(year_quarter = make_yearquarter(year = year, quarter = quarter), .after = quarter) %>% 
  select(-year, -quarter) 

#glimpse(beds)

# Join data sets together to get health board names

beds <- beds %>% 
  left_join(health_board, by = "hb") %>% 
  left_join(special_health_board, by = c("hb" = "shb")) %>% 
  select(-contains("qf"), 
         -id.x,
         -id.y,
         -hb_date_enacted,
         -hb_date_archived)

view(beds)

# Write csv file

write_csv(beds, "02_cleaned_data/bed_clean.csv")
