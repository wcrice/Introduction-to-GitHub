# Module UI
volcanoExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Explore the Volcano Dataset"),
    sidebarPanel(
      h4("Visualization Options"),
      checkboxInput(ns("show_contour"), "Show Contour Lines", value = TRUE),
      selectInput(
        ns("color_palette"),
        "Choose Color Gradient:",
        choices = list("Terrain" = "terrain", "Viridis" = "viridis", "Heat" = "heat"),
        selected = "terrain"
      )
    ),
    mainPanel(
      plotOutput(ns("volcano_plot"))
    )
  )
}

# Module Server
volcanoExplorerModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    # Reactive palette function
    palette_func <- reactive({
      switch(
        input$color_palette,
        terrain = terrain.colors,
        viridis = {
          if (requireNamespace("viridis", quietly = TRUE)) {
            viridis::viridis
          } else {
            warning("Viridis package not installed; using terrain.colors instead.")
            terrain.colors
          }
        },
        heat = heat.colors,
        terrain.colors  # Default in case of invalid input
      )
    })
    
    # Render Volcano Plot
    output$volcano_plot <- renderPlot({
      tryCatch({
        validate(
          need(is.matrix(volcano), "The volcano dataset is missing or invalid.")
        )
        
        par(mar = c(4, 4, 2, 1))
        filled.contour(
          volcano,
          color.palette = palette_func(),
          plot.title = title(main = "Volcano Topography", xlab = "X Coordinate", ylab = "Y Coordinate"),
          plot.axes = {
            axis(1); axis(2)
            if (input$show_contour) {
              contour(volcano, add = TRUE, col = "black", lwd = 0.5)
            }
          }
        )
      }, error = function(e) {
        plot.new()
        text(0.5, 0.5, paste("Error rendering plot:", e$message), cex = 1.2)
      })
    })
  })
}
