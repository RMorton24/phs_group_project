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

write_csv(deaths_by_deprivation, "02_cleaned_data/deaths_by_deprivation.csv")

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
         hb_name == "NHS Scotland") %>% 
  ggplot() +
  geom_line(aes(x = week_ending, y = deaths), colour = "steelblue") +
  labs(title = "Deaths Over Time by Age, Sex and Health Board",
       x = "Month",
       y = "Number of Deaths")
    
    # add theme, title and edit axis labels

# Create plot of number of deaths by SIMD 
#> THIS ONE CHRIS

death_deprivation_plot <- deaths_by_deprivation %>% 
  group_by(simd_quintile) %>% 
  summarise(total_deaths = sum(deaths)) %>% 
  ggplot() +
  geom_col(aes(x = simd_quintile, y = total_deaths), fill = "purple") +
  labs(title = "Number of Deaths Across 2020/2021 by SIMD",
       x = "SIMD",
       y = "Total Deaths") 
  
death_deprivation_plot

# Create plot of number of deaths per month by SIMD

death_deprivation_month <- deaths_by_deprivation %>% 
  mutate(year = year(week_ending),
         month = month(week_ending),
         day = day(week_ending)) %>% 
  mutate(month_name = month(month, label = TRUE, abbr = FALSE))

death_deprivation_month %>% 
  select(year, average20152019, deaths, month_name, simd_quintile) %>% 
  group_by(month_name, simd_quintile, deaths) %>% 
  summarise(mean_deaths = mean(deaths)) %>% 
  ggplot() +
  geom_col(aes(x = month_name, y = mean_deaths, fill = simd_quintile)) +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Quintile deaths per month")


# Create plot of number of deaths by SIMD over time 

#> THIS ONE CHRIS

deaths_deprivation_time <- deaths_by_deprivation %>% 
  #select(week_ending, simd_quintile, deaths, average20152019) %>% 
  #filter(simd_quintile == 1) %>% 
  group_by(week_ending) %>% 
  ggplot() +
  geom_line(aes(x = week_ending, y = deaths, linetype = "2020/2021"), colour = "red") +
  geom_line(aes(x = week_ending, y = average20152019, linetype = "2015-2019"), colour = "blue") +
  facet_wrap(~simd_quintile) +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Trend of Deaths by SIMD over Time") +
  labs(x = "Date",
       y = "Number of Deaths") +
  guides(linetype = guide_legend(title = NULL))
  
  deaths_deprivation_time

 