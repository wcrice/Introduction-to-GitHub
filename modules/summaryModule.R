# Module UI
summaryModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Explore the 'loggernet_summary' Table"),
    sidebarPanel(
      h4("Filter and Analyze Data"),
      selectInput(
        ns("basin_filter"),
        "Select Basin:",
        choices = unique(loggernet_summary$basin),
        selected = unique(loggernet_summary$basin)[1],
        multiple = TRUE
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DT::dataTableOutput(ns("data_table"))),
        tabPanel("Summary", verbatimTextOutput(ns("summary"))),
        tabPanel("Map", leaflet::leafletOutput(ns("map")))
      )
    )
  )
}

# Module Server
summaryModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(dplyr)
    library(leaflet)
    library(DT)
    
    # Reactive filtered dataset
    filtered_data <- reactive({
      req(input$basin_filter) # Ensure input is valid
      loggernet_summary %>%
        filter(basin %in% input$basin_filter) %>%
        mutate(
          S_Installed = ifelse(is.na(S_Installed), "Not Installed", as.character(S_Installed)),
          S_Removed = ifelse(is.na(S_Removed), "Not Removed", as.character(S_Removed)),
          color = ifelse(S_Installed == "Not Installed", "red", "blue") # Assign color based on installation status
        )
    })

    # Render filtered dataset as an interactive table
    output$data_table <- DT::renderDataTable({
      req(filtered_data())
      DT::datatable(
        filtered_data(),
        options = list(scrollX = TRUE, pageLength = 50),
        rownames = FALSE
      )
    })

    # Render summary of the filtered dataset
    output$summary <- renderPrint({
      req(filtered_data())
      summary(filtered_data())
    })

    # Render interactive map
    output$map <- leaflet::renderLeaflet({
      req(filtered_data())
      data <- filtered_data()
      
      leaflet(data) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~lon,
          lat = ~lat,
          popup = ~paste0(
            "Site ID: ", Site_ID, "<br>",
            "Basin: ", basin, "<br>",
            "Elevation: ", Elevation_ft, " ft<br>",
            "S_Installed: ", S_Installed, "<br>",
            "S_Removed: ", S_Removed
          ),
          radius = 5,
          color = ~color, # Use the color column to assign marker colors
          fillOpacity = 0.7
        )
    })
  })
}
