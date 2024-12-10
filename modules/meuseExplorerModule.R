# Module UI
meuseExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Explore the Meuse Dataset"),
    tabsetPanel(
      tabPanel(
        "Visualization",
        sidebarPanel(
          h4("Visualization Options"),
          selectInput(
            ns("model_var"),
            "Select Variable for Linear Model:",
            choices = c(
              "Cadmium (mg/kg)", "Copper (mg/kg)", "Lead (mg/kg)",
              "Zinc (mg/kg)", "Elevation (m)", "Distance to Meuse (normalized)",
              "Organic Matter (%)", "Distance to Meuse (m)"
            ),
            selected = "Zinc (mg/kg)"
          ),
          checkboxInput(ns("show_points"), "Show Spatial Points", value = TRUE),
          actionButton(ns("fit_model"), "Fit Linear Model"),
          br(),
          uiOutput(ns("model_summary"))
        ),
        mainPanel(
          plotOutput(ns("spatial_plot")),
          plotOutput(ns("residuals_plot"))
        )
      ),
      tabPanel(
        "Interactive Map",
        mainPanel(
          leafletOutput(ns("meuse_map")),
          br(),
          h4("Data Source"),
          p("This dataset gives locations and topsoil heavy metal concentrations, along with a number of soil and landscape variables at the observation locations, collected in a flood plain of the river Meuse, near the village of Stein (NL). Heavy metal concentrations are from composite samples of an area of approximately 15 m x 15 m."),
          p("For more information, visit the official R documentation for the dataset:"),
          tags$a(href = "https://search.r-project.org/CRAN/refmans/sp/html/meuse.html", "Meuse {sp} R Documentation", target = "_blank"),
          br(),
          p("References:"),
          tags$ul(
            tags$li("M G J Rikken and R P G Van Rijn, 1993. Soil pollution with heavy metals - an inquiry into spatial variation, cost of mapping and the risk evaluation of copper, cadmium, lead and zinc in the floodplains of the Meuse west of Stein, the Netherlands. Doctoraalveldwerkverslag, Dept. of Physical Geography, Utrecht University."),
            tags$li("P.A. Burrough, R.A. McDonnell, 1998. Principles of Geographical Information Systems. Oxford University Press."),
            tags$li("Stichting voor Bodemkartering (STIBOKA), 1970. Bodemkaart van Nederland : Blad 59 Peer, Blad 60 West en 60 Oost Sittard: schaal 1 : 50 000. Wageningen, STIBOKA.")
          )
        )
      )
    )
  )
}

# Module Server
meuseExplorerModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    cat("Server: meuseExplorerModuleServer initialized\n")  # Debug message
    
    # Convert RDH coordinates to WGS84 using sf
    library(sf)
    meuse_sf <- st_as_sf(meuse, coords = c("x", "y"), crs = 28992)  # RDH projection
    meuse_wgs84 <- st_transform(meuse_sf, crs = 4326)  # WGS84 projection
    
    # Rename columns for user-friendly names (excluding coordinates)
    meuse_wgs84 <- meuse_wgs84 %>% 
      dplyr::rename(
        `Cadmium (mg/kg)` = cadmium,
        `Copper (mg/kg)` = copper,
        `Lead (mg/kg)` = lead,
        `Zinc (mg/kg)` = zinc,
        `Elevation (m)` = elev,
        `Distance to Meuse (normalized)` = dist,
        `Organic Matter (%)` = om,
        `Flood Frequency` = ffreq,
        `Soil Type` = soil,
        `Lime Class` = lime,
        `Land Use` = landuse,
        `Distance to Meuse (m)` = dist.m
      )
    
    # Reactive dataset for filtering
    reactive_data <- reactive({
      meuse_wgs84
    })
    
    # Render spatial plot
    output$spatial_plot <- renderPlot({
      data <- reactive_data()
      validate(
        need(!is.null(input$model_var) && input$model_var %in% colnames(data), "Invalid model variable.")
      )
      if (input$show_points) {
        breaks <- quantile(data[[input$model_var]], probs = seq(0, 1, length.out = 6), na.rm = TRUE)
        colors <- colorRampPalette(c("blue", "red"))(length(breaks) - 1)
        bins <- cut(data[[input$model_var]], breaks = breaks, include.lowest = TRUE)
        
        plot(
          st_coordinates(data)[, 1], st_coordinates(data)[, 2],
          col = colors[as.numeric(bins)],
          xlab = "Longitude", ylab = "Latitude",
          main = paste("Spatial Plot -", input$model_var),
          pch = 19
        )
        legend("topright", legend = levels(bins), fill = colors, 
               title = paste(input$model_var), cex = 0.8)
      } else {
        plot.new()
        text(0.5, 0.5, "Spatial points are hidden.", cex = 1.2)
      }
    })
    
    # Fit linear model and show summary
    observeEvent(input$fit_model, {
      data <- as.data.frame(meuse)
      model <- lm(log(zinc) ~ elev + sqrt(dist) + om + ffreq, data = data)
      residuals <- residuals(model)
      
      # Render model summary
      output$model_summary <- renderUI({
        tagList(
          h4("Model Summary:"),
          verbatimTextOutput(session$ns("summary_text"))
        )
      })
      
      output$summary_text <- renderPrint({
        summary(model)
      })
      
      # Render residuals plot
      output$residuals_plot <- renderPlot({
        par(mfrow = c(2, 2))
        plot(model)
      })
    })
    
    # Render interactive Leaflet map
    output$meuse_map <- renderLeaflet({
      data <- reactive_data()
      leaflet(data) %>% 
        addTiles() %>% 
        addCircleMarkers(
          lng = st_coordinates(data)[, 1], # Longitude in WGS84
          lat = st_coordinates(data)[, 2], # Latitude in WGS84
          radius = 5,
          color = "blue",
          popup = ~paste(
            "<strong>Location Summary:</strong>",
            "<br><strong>Cadmium (mg/kg):</strong>", `Cadmium (mg/kg)`,
            "<br><strong>Copper (mg/kg):</strong>", `Copper (mg/kg)`,
            "<br><strong>Lead (mg/kg):</strong>", `Lead (mg/kg)`,
            "<br><strong>Zinc (mg/kg):</strong>", `Zinc (mg/kg)`,
            "<br><strong>Elevation (m):</strong>", `Elevation (m)`,
            "<br><strong>Organic Matter (%):</strong>", `Organic Matter (%)`
          )
        )
    })
  })
}
