# Module UI
graphModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(3,
             selectInput(
               ns("basin_filter"),
               "Select Basin:",
               choices = sort(unique(loggernet_summary$basin)),
               selected = "BUT"
             )
      ),
      column(3,
             selectInput(
               ns("site_filter"),
               "Select Site ID:",
               choices = NULL
             )
      ),
      column(3,
             selectizeInput(
               ns("year_filter"),
               "Select Year(s):",
               choices = NULL,
               selected = NULL,
               multiple = TRUE,
               options = list(plugins = list('remove_button', 'drag_drop'))
             )
      ),
      column(3,
             radioButtons(
               ns("time_selection"),
               "Select Time Field:",
               choices = list("Time Start" = "time_start", "Time End" = "time_end"),
               selected = "time_start",
               inline = TRUE
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
    ),
    fluidRow(
      column(12,
             h4("Selected Points for QAQC"),
             DT::dataTableOutput(ns("qaqc_table"))
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

    # Reactive value to store selected points
    selected_points <- reactiveValues(data = {
      if (file.exists("qaqc_delete.csv")) {
        read.csv("qaqc_delete.csv", stringsAsFactors = FALSE)
      } else {
        data.frame(Site_ID = character(), time_start = character(), time_end = character(), variable = character(), Notes = character(), stringsAsFactors = FALSE)
      }
    })

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

      loggernet_filtered
    })

    # Render DTW Comparison Plot
    output$dtw_plot <- plotly::renderPlotly({
      req(filtered_data())
      df <- filtered_data()

      plot <- plotly::plot_ly(
        data = df,
        x = ~TIMESTAMP,
        y = ~dtw_ft,
        type = "scatter",
        mode = "lines",
        name = "Auto DTW",
        line = list(color = "blue", width = 1)
      ) %>%
        layout(
          title = "DTW Comparison Plot",
          yaxis = list(title = "DTW (ft)", autorange = "reversed"),
          xaxis = list(title = "Timestamp"),
          autosize = TRUE
        )

      plot <- plotly::event_register(plot, "plotly_click")
      plot
    })

    # Observe plotly_click event
    observeEvent(event_data("plotly_click"), {
      click <- event_data("plotly_click")
      req(click)

      # Add a new row to the reactive data frame based on time selection
      new_row <- data.frame(
        Site_ID = input$site_filter,
        time_start = if (input$time_selection == "time_start") as.character(click$x) else NA,
        time_end = if (input$time_selection == "time_end") as.character(click$x) else NA,
        variable = NA, # To be filled by the user
        Notes = "", # To be filled by the user
        stringsAsFactors = FALSE
      )

      selected_points$data <- rbind(selected_points$data, new_row)

      # Save the updated table to CSV
      write.csv(selected_points$data, file = "qaqc_delete.csv", row.names = FALSE)
    })

    # Render Filtered Data Table
    output$filtered_table <- DT::renderDataTable({
      req(filtered_data())
      filtered_data() %>%
        filter(!is.na(DepthToWater_MeasurementPoint_ft)) %>%
        select(TIMESTAMP, DepthToWater_MeasurementPoint_ft, dtw_ft) %>%
        DT::datatable(options = list(pageLength = 10, scrollX = TRUE))
    })

    # Render QAQC Table
    output$qaqc_table <- DT::renderDataTable({
      req(selected_points$data)
      DT::datatable(selected_points$data, options = list(pageLength = 5, scrollX = TRUE))
    })
  })
}