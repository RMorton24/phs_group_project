

shinyUI(
  
  fluidPage(theme = shinytheme("cerulean"),
            
    fluidRow(
      
      titlePanel("PHS Data"),
      
    ),
    fluidRow(
      
      tabsetPanel(
        
# Admissions trend tab--------------------------------------------------------
        
        tabPanel(
          title = "Admissions Data of NHS HB",
          br(),
          
          sidebarLayout(
            
            sidebarPanel(
              width = 4,
              "Select NHS Health Board",
              
              leafletOutput("selection_map", width = "100%", height = 475),
              
              pickerInput(
                inputId = "specialty",
                label = "Select/deselect Specialty", 
                selected = "All",
                choices = unique(specialty_admissions$specialty),
                options = list(
                  `actions-box` = TRUE), 
                multiple = FALSE
              ),
              
              radioGroupButtons(
                inputId = "admission",
                label = "Admission Type",
                choices = c("Emergency", "Planned", "All"),
                selected = "All"
              )
            ),
            
            mainPanel(
              plotlyOutput("katePlot", width = "100%")
              
            )
          )
        ),

# Geo map -----------------------------------------------------------------
    
    tabPanel(
      title = "Health Board Activity",
      br(),
      
      fluidRow(
        
        sidebarLayout(
          position = "right",
          
          sidebarPanel(
            
            width = 3,
            
            radioButtons(
              inputId = "data_select_geo",
              label = "Select Data to review",
              choices = c("Beds" = "beds", "Hospital Activity" = "activity_deprivation"),
            ),
            
            sliderTextInput(
              inputId = "year_quarter_geo",
              label = "Select Year and Quarter:",
              choices = sort(unique(beds$year_quarter)),
              selected = c(sort(unique(beds$year_quarter))[1],
                           sort(unique(beds$year_quarter))[3]),
              grid = TRUE
            ),
            
            
            selectInput(
              inputId = "speciality_geo",
              label = "Select Speciality",
              choices = sort(unique(beds$specialty_name))
            ),
            
            
            selectInput(
              inputId = "variable_to_plot_geo",
              label = "Select Variable to Plot",
              choices = beds_variables_selection
            )
          ),
          mainPanel(
            
            column(
              offset = 1,
              width = 11,
              
              leafletOutput("heatmap2", width = "100%", height = "550px")
            )
          )
        )
        
      )
    ),
    
    
# Demographics tab --------------------------------------------------------
    
    
    tabPanel(
      title = "Demographics",
      br(),
      
      tabsetPanel(
# Average stay length  ---------------------------------------------------
        tabPanel(
          title = "Average Stay Lengths",
          br(),

          dropdown(
            
            circle = TRUE,
            status = "info",
            icon = icon("gear"),
            width = "350px",
            tooltip = tooltipOptions(title = "Click for inputs"),
            animate = FALSE,
            
            pickerInput(
              inputId = "demo_hb",
              label = "Select/deselect HealthBoard",
              selected = unique(activity_patient_demographics$hb_name),
              choices = unique(activity_patient_demographics$hb_name),
              options = list(
                `actions-box` = TRUE), 
              multiple = TRUE
            ),
            
            pickerInput(
              inputId = "demo_age",
              label = "Select/deselect Age Group", 
              selected = unique(activity_patient_demographics$age),
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
              offset = 4,
              width = 8,
              
              plotOutput("demographics_output", width = "120%", height = "250px"),
              
              plotOutput("demographics_simd_output", width = "120%", height = "250px")
              
            )
          )
        ),
        
        
# Covid Admissions by Gender tab ----------------------------------------------------
        
        
        tabPanel(
          
          title = "Covid Admissions by Gender",
          br(),
          
          dropdown(
            
            circle = TRUE,
            status = "info",
            icon = icon("gear"),
            width = "350px",
            tooltip = tooltipOptions(title = "Click for inputs"),
            animate = FALSE,
            
            pickerInput(
              inputId = "demo_hb_covid",
              label = "Select/deselect HealthBoard",
              selected = unique(covid_admission_age_sex$hb_name),
              choices = unique(covid_admission_age_sex$hb_name),
              options = list(
                `actions-box` = TRUE), 
              multiple = TRUE
            ),
            
            radioGroupButtons(
              inputId = "demo_admission_type_covid",
              label = "Select/deselect Type of Admission",
              selected = "All",
              choices = unique(covid_admission_age_sex$admission_type),
              direction = "horizontal"
            ),
            
          ),
          
          mainPanel(
            
            column(
              width = 5,
              offset = 1,
              
              plotOutput("demographics_output_covid", width = "350%", height = "450px")
              
            )
          )
        ),

# Covid Admissions by Age Group -------------------------------------------

        tabPanel(
          
          title = "Covid Admissions by Age Group",
          br(),
          
          dropdown(
            
            circle = TRUE,
            status = "info",
            icon = icon("gear"),
            width = "350px",
            tooltip = tooltipOptions(title = "Click for inputs"),
            animate = FALSE,
            
            pickerInput(
              inputId = "demo_hb_covid_age",
              label = "Select/deselect HealthBoard",
              selected = unique(covid_admission_age_sex$hb_name),
              choices = unique(covid_admission_age_sex$hb_name),
              options = list(
                `actions-box` = TRUE), 
              multiple = TRUE
            ),
            
            
            radioGroupButtons(
              inputId = "demo_admission_type_covid_age",
              label = "Select/deselect Type of Admission",
              selected = "All",
              choices = unique(covid_admission_age_sex$admission_type),
              direction = "horizontal"
            ),
          ),
          
          mainPanel(
            
            column(
              width = 5,
              offset = 1,
              
              plotOutput("demographics_output_covid_age", width = "350%", height = "450px")
            )
          )
        )
      )
    ),

# Death trends by deprivation level ---------------------------------------


    tabPanel(
      title = "Death Trends by Deprivation",
      br(),
      
      column(
        width = 4,
        
      plotOutput("deathplot1")
      ),
      
      column(
        width = 8,
        
        plotOutput("deathplot2")
      )
    )
      )
    )
  )
)

