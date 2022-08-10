# Load in libraries

library(tidyverse) 
library(plotly)

# Read in data

admissions_by_specialty <- read_csv("02_cleaned_data/admissions_by_speciality_clean.csv")


# Create interactive plot with plotly for admissions by hb/specialty/admission type with 0218/19 average

admissions_filter <- admissions_by_specialty %>% 
  filter(hb == "S92000003",
         specialty == "All", 
         admission_type == "Emergency") 

plot_admissions <- plot_ly(data = admissions_filter,
                           x = ~week_ending,
                           y = ~number_admissions,
                           type = "scatter", 
                           mode = "lines",
                           name = "2020/2021",
                           text = ~paste("The week ending:", week_ending,
                                         "<br> Number of admissions:", number_admissions),
                           textposition = "auto",
                           hoverinfo = "text") %>% 
  layout(title = "Number of Admissions per Week by Health Board, Specialty and Admission Type", 
         xaxis = list(title = "Week Ending", type = "date", tickformat = "%B"),
         yaxis = list(title = "Number of Admissions"),
         legend = list(title = list(text="<br> Year </br>")))

plot_admissions <- add_trace(
  plot_admissions,
  data = admissions_filter,
  x = ~week_ending,
  y = ~average20182019,
  type = "scatter", 
  mode = "lines",
  name = "2018/2019 average",
  text = ~paste("Comparative week ending:", week_ending,
                "<br> 2018/2019 Average number of admissions:", average20182019), 
  textposition = "auto",
  hoverinfo = "text"
)

plot_admissions
