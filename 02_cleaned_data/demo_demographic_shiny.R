library(tidyverse)
library(janitor)
library(CodeClanData)
library(shiny)
library(bslib)
library(shinyWidgets)
library(shinydashboard)
library(DT)

df <- read_csv("02_cleaned_data/activity_patient_demographics.csv")

ui <- fluidPage(
  titlePanel("patients_demographic"),

  fluidRow(
    #our input
    column(
      width = 12, #column of max width
      plotOutput("graph")
    )
  ),
  fluidRow(
    #our output
    column(
      width = 3,
      offset = 3,
      pickerInput(inputId = "age",
                  label = "age",
                  choices = unique(df$age),
                  options = list('actions-box' = TRUE),
                  multiple = TRUE
      )
    ),
    column(
      width = 3,
      pickerInput(inputId = "hb_name",
                  label = "hb_name",
                  choices = unique(df$hb_name),
                  options = list('actions-box' = TRUE),
                  multiple = TRUE
      )
    ),
    column(
      width = 3,
      pickerInput(inputId = "admission_type",
                  label = "admission_type",
                  choices = unique(df$admission_type),
                  options = list('actions-box' = TRUE),
                  multiple = TRUE
      )
    ),
    column(
      width = 3,
      pickerInput(inputId = "location_name",
                  label = "location_name",
                  choices = unique(df$location_name),
                  options = list('actions-box' = TRUE),
                  multiple = TRUE
      )
    )
  )
)

server <- function(input, output, session) {
  output$graph <- renderPlot(
    df  %>% 
      filter(!is.na(hb_name)) %>% 
      filter(age %in% input$age) %>% 
      filter(hb_name %in% input$hb_name) %>% 
      filter(admission_type %in% input$admission_type) %>% 
      filter(location_name %in% input$location_name) %>% 
      group_by(sex, year, age) %>% 
      summarise(nr_episodes          = sum(episodes), 
                nr_stays             = sum(stays)) %>% 
      #           count_length_episode = sum(length_of_episode),
      #           count_length_stays   = sum(length_of_stay)) %>% 
      ggplot() + 
      aes(x = age, y = nr_episodes, fill = sex) +
      geom_col(position = "dodge") + 
      geom_smooth(show.legend = FALSE, size = 1) +
      theme_minimal()
  )
}

shinyApp(ui, server)
