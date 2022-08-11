# Load in libraries

library(tidyverse) 
library(plotly)

# Read in data

admissions_by_specialty <- read_csv("02_cleaned_data/admissions_by_speciality_clean.csv")

# Create interactive plot with plotly for admissions by hb/specialty/admission type with 0218/19 average

admissions_filter <- admissions_by_specialty %>% 
  filter(hb == "S08000015",
         specialty == "All", 
         admission_type == "All") 

vline_1 <- function(x = 0, color = "#999999") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color)
  )
}

vline_2 <- function(x = 0, color = "#999999") {
  list(
    type = "line",
    y0 = 0,
    y1 = 1,
    yref = "paper",
    x0 = x,
    x1 = x,
    line = list(color = color, dash = "dot")
  )
}

annotation_1 <- list(yref = "paper", xref = "x", y = 0.6, x = "2020-03-29", 
                     text = "First Lockdown", xanchor = "left", showarrow = F, 
                     font = list(size = 14), textangle = 90)

annotation_2 <- list(yref = "paper", xref = "x", y = 0.6, x = "2021-01-10", 
                     text = "Second Lockdown", xanchor = "left", showarrow = F, 
                     font = list(size = 14), textangle = 90)

annotation_3 <- list(yref = "paper", xref = "x", y = 0.05, x = "2020-07-12", 
                     text = "Restrictions Eased", xanchor = "left", showarrow = F, 
                     font = list(size = 14), textangle = 90)

annotation_4 <- list(yref = "paper", xref = "x", y = 0.05, x = "2021-05-02", 
                     text = "Restrictions Eased", xanchor = "left", showarrow = F, 
                     font = list(size = 14), textangle = 90)

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
         xaxis = list(title = "Month", type = "date", tickformat = "%B"),
         yaxis = list(title = "Number of Admissions"),
         legend = list(title = list(text="<br> Year </br>")),
         shapes = list(vline_1("2020-03-29"), vline_1("2021-01-10"), 
                       vline_2("2020-07-12"), vline_2("2021-05-02")),
         annotations = list(annotation_1, annotation_2, annotation_3, annotation_4))


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

