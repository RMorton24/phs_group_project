

shinyUI(
  fluidPage(
    fluidRow(
      titlePanel("PHS Data"),
      column(
        width = 3,
        offset = 5,
        br(),
        fluidRow(
          valueBox(10 * 2, "New Orders", icon = icon("bed")),
          
          valueBoxOutput("progressBox"),
          
          valueBoxOutput("approvalBox")
        ),
        br(),
      )
    ),
    fluidRow(
      tabsetPanel(
        tabPanel(
          title = "Tab 1",
          sidebarLayout(
            sidebarPanel(
              width = 4,
              leafletOutput("selection_map", width = "100%", height = 475)
            ),
            mainPanel(
              plotOutput("distPlot1"),
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
              selected = "All",
              choices = unique(specialty_admissions$specialty),
              options = list(
                `actions-box` = TRUE), 
              multiple = TRUE
            ),
            
            pickerInput(
              inputId = "hb",
              label = "Select/deselect HealthBoard",
              selected = head(specialty_admissions$hb_name),
              choices = unique(specialty_admissions$hb_name),
              options = list(
                `actions-box` = TRUE), 
              multiple = TRUE
            ),
            
            sliderInput(inputId = 'week_ending',
                        label = 'Time Span',
                        value = c(min(specialty_admissions$week_ending),
                                  max(specialty_admissions$week_ending)),
                        min = min(specialty_admissions$week_ending),
                        max = max(specialty_admissions$week_ending)),
            
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
        ),
    tabPanel(
      title = "Tab 3",
      br(),
      dropdown(
        
        circle = TRUE, 
        status = "info",
        icon = icon("gear"), 
        width = "350px",
        tooltip = tooltipOptions(title = "Click to see inputs !"),
      ),
      mainPanel(
        leafletOutput("heatmap1", width = "150%", height = "750px")
      )
    )
      )
    )
  )
)
