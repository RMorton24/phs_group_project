
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
  
  admissions_filter <- reactive({
    
    specialty_admissions %>% 
      filter(specialty == input$specialty, 
             hb_name == input$hb,
             admission_type == input$admission)
    # between(week_ending, as.numeric(input$week_ending[1]), 
    #         as.numeric(input$week_ending[2])))
    
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
  
  # output$distPlot <- renderPlot({
  #   
  #   admissions_filter() %>%  
  #     ggplot() +
  #     geom_line(aes(x = week_ending, y = number_admissions)) +
  #     geom_line(aes(x = week_ending, y = average20182019), colour = "red")
  #   
  # })
  
  output$katePlot <- renderPlotly({
    
    vline_1 <- function(x = 0, color = "#999999") {
      list(
        type = "line",
        y0 = 0,
        y1 = 1,
        yref = "paper",
        x0 = x,
        x1 = x,
        line = list(color = color)
      )
    }
    
    vline_2 <- function(x = 0, color = "#999999") {
      list(
        type = "line",
        y0 = 0,
        y1 = 1,
        yref = "paper",
        x0 = x,
        x1 = x,
        line = list(color = color, dash = "dot")
      )
    }
    
    annotation_1 <- list(yref = "paper", xref = "x", y = 0.6, x = "2020-03-29", 
                         text = "First Lockdown", xanchor = "left", showarrow = F, 
                         font = list(size = 14), textangle = 90)
    
    annotation_2 <- list(yref = "paper", xref = "x", y = 0.6, x = "2021-01-10", 
                         text = "Second Lockdown", xanchor = "left", showarrow = F, 
                         font = list(size = 14), textangle = 90)
    
    annotation_3 <- list(yref = "paper", xref = "x", y = 0.05, x = "2020-07-12", 
                         text = "Restrictions Eased", xanchor = "left", showarrow = F, 
                         font = list(size = 14), textangle = 90)
    
    annotation_4 <- list(yref = "paper", xref = "x", y = 0.05, x = "2021-05-02", 
                         text = "Restrictions Eased", xanchor = "left", showarrow = F, 
                         font = list(size = 14), textangle = 90)
    
    plot_admissions <- plot_ly(data = admissions_filter(),
                               x = ~week_ending,
                               y = ~number_admissions,
                               type = "scatter", 
                               mode = "lines",
                               name = "2020/2021",
                               text = ~paste("The week ending:", week_ending,
                                             "<br> Number of admissions:", number_admissions),
                               textposition = "auto",
                               hoverinfo = "text") %>% 
      layout(title = "Number of Admissions per Week by Health Board, Specialty and Admission Type", 
             xaxis = list(title = "Month", type = "date", tickformat = "%B"),
             yaxis = list(title = "Number of Admissions"),
             legend = list(title = list(text="<br> Year </br>")),
             shapes = list(vline_1("2020-03-29"), vline_1("2021-01-10"), 
                           vline_2("2020-07-12"), vline_2("2021-05-02")),
             annotations = list(annotation_1, annotation_2, annotation_3, annotation_4))
    
    
    plot_admissions <- add_trace(
      plot_admissions,
      data = admissions_filter(),
      x = ~week_ending,
      y = ~average20182019,
      type = "scatter", 
      mode = "lines",
      name = "2018/2019 average",
      text = ~paste("Comparative week ending:", week_ending,
                    "<br> 2018/2019 Average number of admissions:", average20182019), 
      textposition = "auto",
      hoverinfo = "text"
    )
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
      group_by(HBCode = hb)
    #select(!!as.name(input$variable_to_plot_geo), HBCode) %>% 
    # summarise(plot_this = case_when(
    #   str_detect(input$variable_to_plot_geo, "_beds") ~ mean(!!as.name(input$variable_to_plot_geo), na.rm = TRUE),
    #   str_detect(input$variable_to_plot_geo, "th_of_st") ~ sum(stays, na.rm = TRUE)/sum(length_of_stay, na.rm = TRUE)*100,
    #   str_detect(input$variable_to_plot_geo, "th_of_ep") ~ sum(episodes, na.rm = TRUE)/sum(length_of_episode, na.rm = TRUE)*100,
    #   str_detect(input$variable_to_plot_geo, "percent_occ") ~ 100*sum(total_occupied_beddays, na.rm = TRUE)/sum(all_staffed_beddays, na.rm = TRUE),
    #   TRUE ~ sum(!!as.name(input$variable_to_plot_geo), na.rm = TRUE))
    #   )
  })
  
  
  observeEvent(c(input$year_quarter_geo, input$variable_to_plot_geo,
                 input$speciality_geo),{
                   
                   if(input$data_select_geo == "beds"){
                     geo_data <- quarter_filter() %>% 
                       summarise(plot_this = case_when(
                         str_detect(input$variable_to_plot_geo, "_beds") ~ mean(!!as.name(input$variable_to_plot_geo), na.rm = TRUE),
                         str_detect(input$variable_to_plot_geo, "percent_occ") ~ 100*sum(total_occupied_beddays, na.rm = TRUE)/sum(all_staffed_beddays, na.rm = TRUE),
                         TRUE ~ sum(!!as.name(input$variable_to_plot_geo), na.rm = TRUE))
                       )
                   }else{
                     geo_data <- quarter_filter() %>% 
                       summarise(plot_this = case_when(
                         str_detect(input$variable_to_plot_geo, "th_of_st") ~ sum(stays, na.rm = TRUE)/sum(length_of_stay, na.rm = TRUE)*100,
                         str_detect(input$variable_to_plot_geo, "th_of_ep") ~ sum(episodes, na.rm = TRUE)/sum(length_of_episode, na.rm = TRUE)*100,
                         TRUE ~ sum(!!as.name(input$variable_to_plot_geo), na.rm = TRUE))
                       )
                   }              
                   
                   
                   
                   temp_shape <- sp::merge(nhs_borders, geo_data, by = c("HBCode" = "HBCode"))
                   
                   factor_number <- 10^ceiling(log10(temp_shape$plot_this)-2)
                   
                   range <- c(significance_round(min(temp_shape$plot_this), round_up = FALSE, 2), 
                              significance_round(max(temp_shape$plot_this), round_up = TRUE, 2))
                   
                   if(any(is.na(range))){
                     bins <- c(1:9)
                   }else{
                     bins <- seq(from = range[1], to = range[2], by = (range[2] - range[1])/9) %>% 
                       signif(3)
                     if(length(bins) == 1){
                       bins <- c(bins, bins)
                     }
                   }
                   
                   # Create labels for region plot
                   labels_heat <- paste0(
                     "<b>", temp_shape$HBName, "</b><br>", temp_shape$plot_this
                   ) %>% lapply(htmltools::HTML)
                   
                   hot_colour <- colorBin(palette = "YlOrRd", domain = temp_shape$plot_this, bins = bins)
                   
                   
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
                               values = temp_shape$plot_this, 
                               title = input$variable_to_plot_geo,
                               position = "bottomright") %>% 
                     setMaxBounds(bbox[1], bbox[2], bbox[3], bbox[4])
                   
                 })
  
  
})
  
  # output$table_test <- renderTable({
  #   quarter_filter() %>% 
  #     distinct(as.character(year_quarter))
  #  
  #   
  # })
  


