
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
              zoom = 6)
  })
  
  # Create heatmap plot
  output$heatmap <- renderLeaflet({
    leaflet(nhs_borders) %>% 
      addTiles() %>% 
      addPolygons(fillColor = ~pal(HBCode),
                  layerId = ~HBCode,
                  fillOpacity = 1,
                  weight = 1, 
                  color = "white",
                  label = labels_regions,
                  labelOptions = labelOptions()) %>% 
      setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4])
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
  
  quarter_filter <- reactive({
    beds %>% 
      filter(year_quarter >= yearquarter(input$year_quarter[1]) &
               year_quarter <= yearquarter(input$year_quarter[2]),
             specialty_name == input$speciality) %>% 
      group_by(HBCode = hb) %>% 
      select(!!as.name(input$variable_to_plot)) %>% 
      summarise(plot_this = sum(!!as.name(input$variable_to_plot)))
  })
  
  # observeEvent(input$year_quarter,{
  #   print(paste(input$year_quarter, class(input$year_quarter)))
  # })
  
  
  observeEvent(quarter_filter(),{
    
    
    temp_shape <- sp::merge(nhs_borders, quarter_filter(), by = c("HBCode" = "HBCode"))
    
    range <- quarter_filter() %>% 
      summarise(across(.cols = plot_this, 
                       .fns = list(min = min, 
                                   max = max), .names = "{.fn}"))
    
    bins <- seq(from = range$min, to = range$max, by = (range$max - range$min)/9)
    
    # Create labels for region plot
    labels_heat <- paste0(
      "<b>", temp_shape$HBName, "</b><br>", temp_shape$plot_this
    ) %>% lapply(htmltools::HTML)
    
    hot_colour <- colorBin(palette = "YlOrRd", domain = temp_shape$plot_this, bins = bins)
     # browser()
    leafletProxy("heatmap") %>% 
      clearShapes() %>% 
      clearControls() %>% 
      addPolygons(data = temp_shape,
                  fillColor = hot_colour(temp_shape$plot_this),
                  fillOpacity = 1,
                  weight = 1, 
                  color = "white",
                  dash = 4,
                  label = labels_heat,
                  labelOptions = labelOptions()) %>% 
      addLegend(pal = hot_colour,
                values = temp_shape$plot_this, title = input$variable_to_plot,
                position = "bottomright") %>% 
      setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4])

  })
  
  
  
    # output$table_test <- renderTable({
    #   quarter_filter() %>% 
    #     distinct(as.character(year_quarter))
    #  
    #   
    # })

})
