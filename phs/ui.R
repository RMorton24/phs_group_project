
library(shiny)

shinyUI(
  fluidPage(
    

    titlePanel("PHS Data"),

    sidebarLayout(
        sidebarPanel(
            sliderInput()
        ),
        
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
