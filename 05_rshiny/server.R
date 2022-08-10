
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  demographic_filter <- reactive({
    
    activity_patient_demographics %>%
      filter(!is.na(hb_name),
             age %in% input$demo_age,
             hb_name %in% input$demo_hb,
             admission_type %in% input$demo_admission_type,
             location_name %in% input$demo_location) %>%
      group_by(sex, year, age) %>%
      summarise(nr_episodes          = sum(episodes),
                nr_stays             = sum(stays))
    
  })
  # observe({
  #   print(paste0(input$demo_age,
  #                input$demo_hb_name,
  #                input$demo_admission_type,
  #                input$demo_location_name))
  # })
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
  output$heatmap2 <- renderLeaflet({
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
    
    specialty_admissions %>% 
      filter(specialty == input$specialty, 
             hb_name == input$hb,
             admission_type == input$admission,
             between(week_ending, as.numeric(input$week_ending[1]), 
                     as.numeric(input$week_ending[2]))) %>%  
      ggplot() +
      geom_line(aes(x = week_ending, y = number_admissions)) +
      geom_line(aes(x = week_ending, y = average20182019), colour = "red")
    
  })
  
  output$demographics_output <- renderPlot({
    # browser()
    # activity_patient_demographics
    demographic_filter() %>%
      ggplot() +
      aes(x = age, y = nr_episodes, fill = sex) +
      geom_col(position = "dodge") +
      theme_minimal()
    
  })
  # output$progressBox <- renderValueBox({
  #   valueBox(
  #     paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
  #     color = "purple"
  #   )
  # })
  # 
  # output$approvalBox <- renderValueBox({
  #   valueBox(
  #     "80%", "Approval", icon = icon("fa-solid fa-bed-pulse", lib = "font-awesome"),
  #     color = "yellow"
  #   )
  # })
  
  
  key_domain <- reactiveVal()
  
  observeEvent(input$data_select_geo,{
    
    if(input$data_select_geo == "beds"){
      updateSelectInput(session,
                        inputId = "variable_to_plot_geo",
                        label = "Select Variable to plot",
                        choices = beds_variables_selection)
      
      updateSelectInput(session,
                        inputId = "speciality_geo",
                        label = "Select Speciality",
                        choices = sort(unique(beds$specialty_name)))
      
      # updateSliderTextInput(session,
      #                       
      #                       inputId = "year_quarter_geo",
      #                       label = "Select Year and Quarter:",
      #                       choices = sort(unique(beds$year_quarter)),
      #                       selected = c(sort(unique(beds$year_quarter))[1],
      #                                    sort(unique(beds$year_quarter))[3])
      # )
      
      key_domain("specialty_name")
                            
    }else{
      updateSelectInput(session,
                        inputId = "variable_to_plot_geo",
                        label = "Select Variable to Plot",
                        choices = activity_dep_variables)
      
      updateSelectInput(session,
                        inputId = "speciality_geo",
                        label = "Select Admission Type",
                        choices = sort(unique(activity_deprivation$admission_type)))
      
      # updateSliderTextInput(session,
      #                       inputId = "year_quarter_geo",
      #                       label = "Select Year and Quarter:",
      #                       choices = sort(unique(activity_deprivation$year_quarter)),
      #                       selected = c(sort(unique(activity_deprivation$year_quarter))[1],
      #                                    sort(unique(activity_deprivation$year_quarter))[3])
      # )
      key_domain("admission_type")
      
    }
    
  })
  
  quarter_filter <- reactive({
    eval(as.name(input$data_select_geo)) %>% 
      filter(year_quarter >= yearquarter(input$year_quarter_geo[1]) &
               year_quarter <= yearquarter(input$year_quarter_geo[2]),
             !!as.name(key_domain()) == input$speciality_geo) %>% 
      group_by(HBCode = hb) %>% 
      select(!!as.name(input$variable_to_plot_geo), HBCode) %>% 
      summarise(plot_this = mean(!!as.name(input$variable_to_plot_geo), na.rm = TRUE))
  })
  
  # observeEvent(input$year_quarter,{
  #   print(paste(input$year_quarter, class(input$year_quarter)))
  # })
  
  
  observeEvent(c(input$year_quarter_geo, input$variable_to_plot_geo,
                 input$speciality_geo),{
    
   
    temp_shape <- sp::merge(nhs_borders, quarter_filter(), by = c("HBCode" = "HBCode"))
    
    factor_number <- 10^ceiling(log10(temp_shape$plot_this)-2)
    
    range <- c(significance_round(min(temp_shape$plot_this), round_up = FALSE, 2), 
               significance_round(max(temp_shape$plot_this), round_up = TRUE, 2))
    
    if(any(is.na(range))){
      bins <- c(1:9)
    }else{
      bins <- seq(from = range[1], to = range[2], by = (range[2] - range[1])/9) %>% 
        signif(3)
    }
    
    # Create labels for region plot
    labels_heat <- paste0(
      "<b>", temp_shape$HBName, "</b><br>", temp_shape$plot_this
    ) %>% lapply(htmltools::HTML)
    
    hot_colour <- colorBin(palette = "YlOrRd", domain = temp_shape$plot_this, bins = bins)
    # browser()
    leafletProxy("heatmap2") %>% 
      clearShapes() %>% 
      clearControls() %>% 
      addPolygons(data = temp_shape,
                  fillColor = hot_colour(temp_shape$plot_this),
                  fillOpacity = 1,
                  weight = 3, 
                  color = "#7fcdbb",
                  dash = 4,
                  label = labels_heat,
                  labelOptions = labelOptions()) %>% 
      addLegend(pal = hot_colour,
                values = temp_shape$plot_this, title = input$variable_to_plot_geo,
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

