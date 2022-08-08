
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$selection_map <- renderLeaflet({
    leaflet(nhs_borders) %>% 
      addPolygons(fillColor = ~pal(HBCode),
                  layerId = ~HBCode,
                  fillOpacity = 1,
                  weight = 1, 
                  color = "white",
                  label = labels,
                  labelOptions = labelOptions(),
                  highlightOptions = highlightOptions(color = "#666",
                                                      weight = 5)
      ) %>% 
      setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4])
  })
  
  
  
  observeEvent(input$selection_map_shape_click$id, {

    poly_region <- which(nhs_borders$HBCode == input$selection_map_shape_click$id)
    region_highlight <- nhs_borders[poly_region, 1]
    

    leafletProxy("selection_map") %>%
      removeShape(layerId = "highlight") %>%
      addPolylines(data = region_highlight,
                   layerId = "highlight",
                   color = "yellow",
                   weight = 5,
                   opacity = 1)

  })
  
    output$distPlot <- renderPlot({
      
     
      
    })

})
