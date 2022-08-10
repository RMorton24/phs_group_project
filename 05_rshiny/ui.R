

shinyUI(
  fluidPage(
    fluidRow(
      titlePanel("PHS Data"),
      # column(
      #   width = 3,
      #   offset = 5,
      #   br(),
      #   fluidRow(
      #     valueBox(10 * 2, "New Orders", icon = icon("bed")),
      #     
      #     valueBoxOutput("progressBox"),
      #     
      #     valueBoxOutput("approvalBox")
      #   ),
      #   br(),
      # )
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
      fluidRow(
        column(
          width = 3,
          sliderTextInput(
            inputId = "year_quarter_geo",
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
            inputId = "speciality_geo",
            label = "Select Speciality",
            choices = sort(unique(beds$specialty_name)))
        ),
        column(
          width = 3,
          selectInput(
            inputId = "variable_to_plot_geo",
            label = "Select Variable to Plot",
            choices = variables_selection
          )
        )
      ),
      mainPanel(
        leafletOutput("heatmap", width = "150%", height = "750px")
      )
    ),
    tabPanel(
      title = "Demographics",
      br(),
      dropdown(

        circle = TRUE,
        status = "info",
        icon = icon("gear"),
        width = "350px",
        tooltip = tooltipOptions(title = "Click to see inputs !"),
        animate = TRUE,
        
        pickerInput(
          inputId = "demo_hb",
          label = "Select/deselect HealthBoard",
          selected = head(activity_patient_demographics$hb_name),
          choices = unique(activity_patient_demographics$hb_name),
          options = list(
            `actions-box` = TRUE), 
          multiple = TRUE
        ),
        
        pickerInput(
          inputId = "demo_location",
          label = "Select/deselect Location", 
          selected = "All",
          choices = unique(activity_patient_demographics$location_name),
          options = list(
            `actions-box` = TRUE), 
          multiple = TRUE
        ),

        pickerInput(
          inputId = "demo_age",
          label = "Select/deselect Age Group", 
          selected = "All",
          choices = unique(activity_patient_demographics$age),
          options = list(
            `actions-box` = TRUE), 
          multiple = TRUE
        ),
        
        pickerInput(
          inputId = "demo_admission_type",
          label = "Select/deselect Type of Admission",
          selected = head(activity_patient_demographics$admission_type),
          choices = unique(activity_patient_demographics$admission_type),
          options = list(
            `actions-box` = TRUE), 
          multiple = TRUE
        ),
        
      ),
      mainPanel(
        column(
          width = 10,
          offset = 1,
        
        plotOutput("demographics_output")
      )
    )
      )
    )
  )
)
)

