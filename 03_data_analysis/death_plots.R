# Load in libraries

library(tidyverse) 
library(lubridate)
library(janitor)

# Read in data

deaths_by_age_sex <- read_csv("01_data/death_data/deaths_hb_agesex_20220302.csv") %>% 
  clean_names()

deaths_by_deprivation <- read_csv("01_data/death_data/deaths_hb_simd_20220302.csv") %>% 
  clean_names()

health_board <- read_csv("01_data/healt_board/health_board.csv") %>% 
  clean_names()

# Clean data

deaths_by_deprivation <- deaths_by_deprivation %>% 
  mutate(week_ending = ymd(week_ending)) 

deaths_by_age_sex <- deaths_by_age_sex %>% 
  mutate(week_ending = ymd(week_ending)) %>% 
  left_join(health_board, by = "hb") %>%
  select(-contains("qf"),
         -id, 
         -hb_date_enacted,
         -hb_date_archived) %>% 
  mutate(hb_name = case_when(
    hb == "S92000003" ~ "NHS Scotland",
    TRUE ~ hb_name
  )) 
  
# Create plot of deaths over time by sex, age and hb

death_trends <- deaths_by_age_sex %>% 
  filter(age_group == "All ages", 
         sex == "All",
         hb == "S92000003") %>% 
  ggplot() +
  geom_line(aes(x = week_ending, y = deaths), colour = "steelblue") +
  labs(title = "Deaths Over Time by Age, Sex and Health Board",
       x = "Month",
       y = "Number of Deaths")
    
    # add theme, title and edit axis labels

# Create plot of number of deaths by SIMD

death_deprivation_plot <- deaths_by_deprivation %>% 
  group_by(simd_quintile) %>% 
  summarise(total_deaths = sum(deaths)) %>% 
  ggplot() +
  geom_col(aes(x = simd_quintile, y = total_deaths), fill = "purple") +
  labs(title = "Number of Deaths Across 2020/2021 by SIMD",
       x = "SIMD",
       y = "Total Deaths") 
  
death_deprivation_plot
