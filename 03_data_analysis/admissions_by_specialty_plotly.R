# Load in libraries

library(tidyverse) 
library(janitor) 
library(plotly)

# Read in data

admissions_by_specialty <- read_csv("02_cleaned_data/admissions_by_speciality_clean.csv")


# Create interactive plot with plotly for admissions by hb/specialty/admission type with 0218/19 average

admissions_plot <- admissions_by_specialty %>% 
  filter(hb_name == "NHS Ayrshire and Arran",
         specialty == "All", 
         admission_type == "Planned") %>%  
  ggplot(aes(x = week_ending, y = number_admissions)) +
  geom_line(colour = "steelblue") +
  geom_line(aes(x = week_ending, average20182019), colour = "#999999") +
  labs(y = "Number of admissions",
       x = "Week ending",
       title = "Number of Admissions per Week by Health Board, Specialty and Admission Type")

ggplotly(admissions_plot)