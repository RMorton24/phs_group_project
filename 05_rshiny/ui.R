


shinyUI(
  fluidPage(
    
    
    titlePanel("PHS Data"),
    
    sidebarLayout(
      sidebarPanel(
        # sliderInput()
        leafletOutput("selection_map", width = "100%", height = 600)
      ),
      
      mainPanel(
        
        fluidRow(
          column(
            width = 3,
            sliderTextInput(
              inputId = "year_quarter",
              label = "Select Year and Quarter:",
              choices = sort(unique(beds$year_quarter)),
              selected = c(sort(unique(beds$year_quarter))[1],
                           sort(unique(beds$year_quarter))[3]),
              grid = TRUE
            )
          ),
          column(
            width = 3,
            selectInput(
              inputId = "speciality",
              label = "Select Speciality",
              choices = unique(beds$specialty_name))
          ),
          column(
            width = 3,
            selectInput(
              inputId = "variable_to_plot",
              label = "Select Variable to Plot",
              choices = variables_selection
            )
          )
        ),
        leafletOutput("heatmap")
      )
    )
  )
)  