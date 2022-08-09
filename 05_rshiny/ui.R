


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
            plotOutput("distPlot1"),
            
            
            leafletOutput("heatmap1", width = "150%", height = "750px")
          )
        )
      ),
      tabPanel(
        title = "Tab 2",
        br(),
        dropdown(
          
          circle = TRUE, 
          status = "info",
          icon = icon("gear"), 
          width = "350px",
          tooltip = tooltipOptions(title = "Click to see inputs !"),
          
          pickerInput(
            inputId = "specialty",
            label = "Select/deselect Specialty", 
            choices = unique(bed_admissions$specialty),
            options = list(
              `actions-box` = TRUE), 
            multiple = TRUE
          ),
          
          pickerInput(
            inputId = "hb",
            label = "Select/deselect HealthBoard", 
            choices = unique(bed_admissions$hb_name),
            options = list(
              `actions-box` = TRUE), 
            multiple = TRUE
          ),
          
          sliderInput(inputId = 'week_ending',
                      label = 'Time Span',
                      value = c(min(bed_admissions$week_ending),
                                max(bed_admissions$week_ending)),
                      min = min(bed_admissions$week_ending),
                      max = max(bed_admissions$week_ending)),
          
          radioGroupButtons(
            inputId = "admission",
            label = "Admission Type",
            choices = c("Emergency", "Planned", "All")
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
    
          plotOutput("distPlot", width = "150%")
        )
        )
      )
    )
  )
)
