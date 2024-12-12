# Module UI
carsExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Explore the 'cars' Dataset"),
    sidebarPanel(
      sliderInput(
        ns("speed_filter"),
        "Filter by Speed:",
        min = min(cars$speed),
        max = max(cars$speed),
        value = range(cars$speed)
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput(ns("summary"))),
        tabPanel("Scatter Plot", plotOutput(ns("scatter_plot"))),
        tabPanel(
          "Documentation",
          mainPanel(
            h4("Data Source"),
            p("The 'cars' dataset provides information on the speed of cars and the distances taken to stop. The data were recorded in the 1920s."),
            p("For more information, visit the official R documentation for the dataset:"),
            tags$a(href = "https://search.r-project.org/CRAN/refmans/desk/html/data.cars.html", "Speed and Stopping Distances of Cars", target = "_blank"),
            br(),
            p("References:"),
            tags$ul(
              tags$li("R package datasets (object cars). Originally published in: Ezekiel, M. (1930): Methods of Correlation Analysis, Wiley."),
              tags$li("Auer, L.v., Hoffmann, S. & Kranz, T. (2023): Ökonometrie - Das R-Arbeitsbuch, 2nd ed., Springer-Gabler (https://www.oekonometrie-lernen.de).")
            )
          )
        )
      )
    )
  )
}

# Module Server
carsExplorerModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    # Filtered dataset reactive
    filtered_data <- reactive({
      cars %>%
        filter(speed >= input$speed_filter[1], speed <= input$speed_filter[2])
    })
    
    # Render summary
    output$summary <- renderPrint({
      summary(filtered_data())
    })
    
    # Render scatter plot
    output$scatter_plot <- renderPlot({
      plot(filtered_data()$speed, filtered_data()$dist,
           xlab = "Speed", ylab = "Stopping Distance",
           main = "Scatter Plot of Speed vs. Distance")
    })
  })
}
