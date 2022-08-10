---
title: "R Notebook"
output: html_notebook
---

```{r}
library(tidyverse)
library(janitor)
library(lubridate)
library(ggplot2)
```


# read data
## hospital activity
```{r}
  hospitality_activity_page <- 
    read_csv("01_data/hospital_activity_page.csv") %>% 
    clean_names()
    # remove_empty(c("rows", "cols"))
    
  hospitality_activity_speciality <- 
    read_csv("01_data/hospital_activity_by_speciality.csv") %>% 
    clean_names()

  hospital_ativity_and_patient_demographics <- 
    read_csv("01_data/hospital_ativity_and_patient_demographics.csv") %>% 
    clean_names()
  
  hospital_activity_and_deprivation <- read_csv("01_data/hospital_activity_and_deprivation.csv") %>% 
    clean_names()
```

## admission by covid
```{r}
# by health_board
covid_admission_hb_age_sex <-
  read_csv("01_data/hospitalisations_due_to_covid_19/admissions_by_health_board_age_and_sex.csv") %>% 
  clean_names()

covid_admission_hb_deprivation <- 
  read_csv("01_data/hospitalisations_due_to_covid_19/admissions_by_health_board_and_deprivation.csv") %>% 
  clean_names()

covid_admission_hb_speciality <- 
  read_csv("01_data/hospitalisations_due_to_covid_19/Admissions_by_health_board_and_specialty.csv") %>% 
  clean_names()
```

##extra data set
```{r}
hospitals <- read_csv(("01_data/healt_board/hospitals.csv")) %>% 
  clean_names()

hb <- read_csv("01_data/healt_board/health_board.csv") %>% 
  clean_names()

shb <- read_csv("01_data/healt_board/special_health_boards.csv") %>% 
  clean_names()

```


```{r}
hospital_ativity_and_patient_demographics %>% 
  separate(quarter, c("year", "quarter"), "Q") %>% 
  mutate(year = as.numeric(year), 
         quarter = as.numeric(quarter)) %>% 
  mutate(year_quarter = make_yearquarter(year = year, quarter = quarter), .after = quarter) %>% 
  select(-year, -quarter)
```




# age_sex -------------------------------------------------------------------

### hospital_ativity_and_patient_demographics
```{r}
patient_demographics_date <- hospital_ativity_and_patient_demographics %>% 
    mutate(year    = stringr::str_sub(quarter, 1, 4), .after = id,
           year    = as.numeric(year),
           quarter = stringr::str_sub(quarter, 6), 
           quarter = as.numeric(quarter)) %>% 
  select(!ends_with("qf"))
           

# join hb
patient_demographics_hb <- patient_demographics_date %>% 
    filter(!hb %in% c("S27000001", "S92000003"),
         nchar(hb) > 8)

patient_demographics_hb <- patient_demographics_hb %>% 
  left_join(x = patient_demographics_hb,
            y = hb, 
            by = "hb", 
            copy = FALSE,
            suffix = c("", "_hb_suffix")) %>% 
  relocate(hb_name, .after = hb) %>% 
  select(c(1:15))


#join hospital
patient_demographics_hospital <- patient_demographics_date %>% 
  filter(nchar(location) < 6)

patient_demographics_hospital <- patient_demographics_hospital %>% 
    left_join(x = patient_demographics_hospital,
            y = hospitals, 
            by = "location", 
            copy = FALSE,
            suffix = c("", "_HOSP_SUFFIX"))
```

### graph
```{r}
patient_demographics_left_join %>%
  group_by(sex, year) %>% 
  summarise(nr_episodes = sum(episodes)) %>% 
  ggplot() + 
  # geom_point() +
  aes(x = year, y = nr_episodes, fill = sex) +
  geom_col(position = "dodge") +
  scale_x_continuous(breaks = seq(2016, 2021, 1)) +
  labs(title = "Number of episodes by sex",
       subtitle = "from 2016 to 2021 ",
       x = NULL, 
       y = "count episodes") +
  theme_minimal() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  scale_fill_manual(values = c("Male"   = "lightblue",
                               "Female" = "pink2")) +
  geom_text(aes(label = nr_episodes),
            position = position_dodge(0.9),
            vjust = 0,
            angle = 90)
  # geom_point(show.legend = FALSE) +
  # geom_smooth(color = "black", size = 1,  show.legend = FALSE)


# + 
#   geom_text(position = position_stack(vjust = 0.5))
# 
# +
#   geom_label(aes(label = nr_episodes), position = position_stack(vjust = 0), , angle = 90) + 
#   geom_smooth(color = "black", size = 4,  show.legend = FALSE)
# 

```

## covid_admission_hb_age_sex
```{r}
covid_admission_hb_age_sex_date <- covid_admission_hb_age_sex %>% 
  mutate(date    = ymd(week_ending), .before = 1,
         year    = year(date),     
         month   = month(date),   
         day     = day(date),     
         quarter = quarter(date))
  
  
  
covid_admission_hb_age_sex_left_join <- covid_admission_hb_age_sex_date %>% 
  left_join(x = covid_admission_hb_age_sex_date, 
            y = hospitals,
            by = "hb",
            suffix = c("","_hospital"))

covid_admission_hb_age_sex_left_join
```

```{r}
covid_admission_hb_age_sex_left_join %>%
  group_by(sex, year) %>% 
  summarise(nr_episodes = sum(episodes)) %>% 
  ggplot() + 
  aes(x = year, y = nr_episodes, fill = sex) +
  geom_col(position = "dodge") +
  scale_x_continuous(breaks = seq(2016, 2021, 1)) +
  labs(title = "Number of episodes by sex",
       subtitle = "from 2016 to 2021 ",
       x = NULL, 
       y = "count episodes") +
  theme_minimal() +
  theme(legend.title = element_blank(),
        legend.position = "bottom",
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()) +
  scale_fill_manual(values = c("Male"   = "lightblue",
                               "Female" = "pink2")) +
  geom_text(aes(label = nr_episodes, 
                nr_episodes = nr_episodes + 0.5
                ),
            position = position_dodge(0.9),
            vjust = 0,
            angle = 90)
```

