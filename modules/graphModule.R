# Module UI
graphModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(4,
        selectInput(
          ns("basin_filter"),
          "Select Basin:",
          choices = sort(unique(loggernet_summary$basin)),
          selected = "BUT"
        )
      ),
      column(4,
        selectInput(
          ns("site_filter"),
          "Select Site ID:",
          choices = NULL
        )
      ),
      column(4,
        selectizeInput(
          ns("year_filter"),
          "Select Year(s):",
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(plugins = list('remove_button', 'drag_drop'))
        )
      )
    ),
    fluidRow(
      column(12,
        tabsetPanel(
          tabPanel("DTW Comparison Plot",
            plotly::plotlyOutput(ns("dtw_plot"), height = "400px")
          )
        )
      )
    ),
    fluidRow(
      column(12,
        DT::dataTableOutput(ns("filtered_table"))
      )
    )
  )
}

# Module Server
graphModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(dplyr)
    library(plotly)
    library(DT)

    # Update Site ID dropdown based on selected Basin
    observeEvent(input$basin_filter, {
      sites <- loggernet_summary %>%
        filter(basin == input$basin_filter) %>%
        pull(Site_ID) %>%
        unique() %>%
        sort()
      updateSelectInput(session, "site_filter", choices = sites, selected = sites[1])
    })

    # Update Year dropdown based on selected Site ID
    observeEvent(input$site_filter, {
      years <- loggernet %>%
        filter(Site_ID == input$site_filter) %>%
        pull(WaterYear) %>%
        unique() %>%
        sort()
      updateSelectizeInput(session, "year_filter", choices = years, selected = years)
    })

    # Reactive filtered dataset
    filtered_data <- reactive({
      req(input$site_filter, input$year_filter)

      loggernet_filtered <- loggernet %>%
        filter(Site_ID == input$site_filter, WaterYear %in% input$year_filter)

      # Check if required columns are present, and handle missing columns
      if (!"DepthToWater_MeasurementPoint_ft" %in% colnames(loggernet_filtered)) {
        loggernet_filtered$dtw_ft_manual <- NA
      }

      loggernet_filtered
    })

    # Render DTW Comparison Plot
    output$dtw_plot <- plotly::renderPlotly({
      req(filtered_data())
      df <- filtered_data()
      plotly::plot_ly(
        df, 
        x = ~TIMESTAMP, 
        y = ~dtw_ft, 
        type = "scatter", 
        mode = "lines+markers", 
        name = "Auto DTW", 
        line = list(color = "blue")
      ) %>%
        add_markers(
          data = df,
          y = ~DepthToWater_MeasurementPoint_ft,
          mode = "markers", 
          name = "Measured DTW", 
          marker = list(symbol = "triangle-up", color = "red", size = 8)
        ) %>%
        layout(
          title = "DTW Comparison Plot",
          yaxis = list(title = "DTW (ft)", autorange = "reversed"),
          xaxis = list(title = "Timestamp"),
          yaxis = list(title = "DTW (ft)"),
          autosize = TRUE
        )
    })

    # Render Filtered Data Table
    output$filtered_table <- DT::renderDataTable({
      req(filtered_data())
      filtered_data() %>%
        filter(!is.na(DepthToWater_MeasurementPoint_ft)) %>%
        select(TIMESTAMP, DepthToWater_MeasurementPoint_ft) %>%
        DT::datatable(options = list(pageLength = 10, scrollX = TRUE))
    })
  })
}
