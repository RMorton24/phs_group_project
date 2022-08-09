
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Create Leaflet output (selection map)
  output$selection_map <- renderLeaflet({
    leaflet(nhs_borders) %>% 
      addPolygons(fillColor = ~pal(HBCode),
                  layerId = ~HBCode,
                  fillOpacity = 1,
                  weight = 1, 
                  color = "white",
                  label = labels_regions,
                  labelOptions = labelOptions(),
                  highlightOptions = highlightOptions(color = "#666",
                                                      weight = 5)
      ) %>% 
      setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4]) %>% 
      setView(lng = mean(bbox[1], bbox[3]), 
              lat = mean(bbox[2], bbox[4]),
              zoom = 5.5) %>% 
      onRender(
        "function(el, x) {
          L.control.zoom({
            position:'bottomright'
          }).addTo(this);
        }")
  })
  
  # Create heatmap plot
  output$heatmap1 <- renderLeaflet({
    leaflet(nhs_borders) %>% 
      addTiles() %>% 
      addPolygons(fillColor = ~pal(HBCode),
                  layerId = ~HBCode,
                  fillOpacity = 1,
                  weight = 1, 
                  color = "white",
                  label = labels_regions,
                  labelOptions = labelOptions()) %>% 
      setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4]) %>% 
      onRender(
        "function(el, x) {
          L.control.zoom({
            position:'bottomright'
          }).addTo(this);
        }")
  })
  
  # Start event if regions in the map are selected
  observeEvent(input$selection_map_shape_click$id, {
    # Prepare the shape to be highlighted
    poly_region <- which(nhs_borders$HBCode == input$selection_map_shape_click$id)
    region_highlight <- nhs_borders[poly_region, 1]
    
    # Highlight the region on map
    leafletProxy("selection_map") %>%
      removeShape(layerId = "highlight") %>%
      addPolylines(data = region_highlight,
                   layerId = "highlight",
                   color = "yellow",
                   weight = 5,
                   opacity = 1)
      
  })
  
    output$distPlot <- renderPlot({
      
      bed_admissions %>% 
        filter(specialty == input$specialty, 
               hb_name == input$hb,
               admission_type == input$admission,
               between(week_ending, as.numeric(input$week_ending[1]), as.numeric(input$week_ending[2]))) %>%  
        ggplot() +
        geom_line(aes(x = week_ending, y = number_admissions)) +
        geom_line(aes(x = week_ending, y = average20182019), colour = "red")
      
    })

})
