


shinyUI(
  fluidPage(
    

    titlePanel("PHS Data"),

    sidebarLayout(
        sidebarPanel(
            # sliderInput()
          leafletOutput("selection_map", width = "100%", height = 600)
        ),
        
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
