


shinyUI(
  fluidPage(
    titlePanel("PHS Data"),
    tabsetPanel(
      tabPanel(
        title = "Tab 1",
        sidebarLayout(
          sidebarPanel(
            # sliderInput()
            leafletOutput("selection_map", width = "100%", height = 500)
          ),
          
          mainPanel(
            plotOutput("distPlot"),
            
            
            leafletOutput("heatmap1")
          )
        )
      ),
      tabPanel(
        title = "Tab 2",
        br(),
        dropdownButton(
          
          circle = TRUE, 
          status = "info",
          icon = icon("gear"), 
          width = "300px",
          tooltip = tooltipOptions(title = "Click to see inputs !"),
          
          pickerInput(
            inputId = "healthboard",
            label = "Select/deselect Healthboard", 
            choices = LETTERS,
            options = list(
              `actions-box` = TRUE), 
            multiple = TRUE
          ),
          
          sliderInput(inputId = 'quarter',
                      label = 'Time Span',
                      value = 3,
                      min = 1,
                      max = 9),
          
          
          
          radioGroupButtons(
            inputId = "sex",
            label = "Choose Sex",
            choices = c("Male", "Female")
          )
          
        ),
        br(),
        mainPanel(
          column(
            offset = 1,
            11,
            tags$style(HTML("
      .leaflet-left .leaflet-control{
        visibility: hidden;
      }
    ")),
    
          leafletOutput("heatmap", width = "150%", height = "750px")
        )
        )
      )
    )
  )
)
