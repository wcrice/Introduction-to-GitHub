# Module UI
mtcarsExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Explore the 'mtcars' Dataset"),
    sidebarPanel(
      h4("Filter and Analyze Data"),
      checkboxGroupInput(
        ns("cyl_filter"),
        "Select Cylinders:",
        choices = unique(mtcars$cyl),
        selected = unique(mtcars$cyl)
      ),
      selectInput(
        ns("x_var"),
        "Select X-axis Variable:",
        choices = names(mtcars),
        selected = "wt"
      ),
      selectInput(
        ns("y_var"),
        "Select Y-axis Variable:",
        choices = names(mtcars),
        selected = "mpg"
      ),
      h4("Variable Descriptions"),
      tags$ul(
        tags$li("mpg: Miles/(US) gallon"),
        tags$li("cyl: Number of cylinders"),
        tags$li("disp: Displacement (cu.in.)"),
        tags$li("hp: Gross horsepower"),
        tags$li("drat: Rear axle ratio"),
        tags$li("wt: Weight (1000 lbs)"),
        tags$li("qsec: 1/4 mile time"),
        tags$li("vs: V/S"),
        tags$li("am: Transmission (0 = automatic, 1 = manual)"),
        tags$li("gear: Number of forward gears"),
        tags$li("carb: Number of carburetors")
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", tableOutput(ns("data_table"))),
        tabPanel("Summary", verbatimTextOutput(ns("summary"))),
        tabPanel("Scatter Plot", plotOutput(ns("scatter_plot"))),
        tabPanel("Boxplot", plotOutput(ns("boxplot")))
      )
    )
  )
}

# Module Server
mtcarsExplorerModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    library(dplyr)
    library(ggplot2)
    
    # Reactive filtered dataset
    filtered_data <- reactive({
      req(input$cyl_filter)
      mtcars %>%
        filter(cyl %in% input$cyl_filter)
    })
    
    # Render filtered dataset as a table
    output$data_table <- renderTable({
      filtered_data()
    })
    
    # Render summary of the filtered dataset
    output$summary <- renderPrint({
      req(filtered_data())
      summary(filtered_data())
    })
    
    # Render scatter plot with selected variables
    output$scatter_plot <- renderPlot({
      req(filtered_data())
      ggplot(filtered_data(), aes_string(x = input$x_var, y = input$y_var)) +
        geom_point(size = 3, color = "blue") +
        labs(
          x = input$x_var,
          y = input$y_var,
          title = paste("Scatter Plot of", input$y_var, "vs", input$x_var)
        ) +
        theme_minimal()
    })
    
    # Render boxplot with selected x and y variables
    output$boxplot <- renderPlot({
      req(filtered_data())
      ggplot(filtered_data(), aes_string(x = paste0("factor(", input$x_var, ")"), y = input$y_var)) +
        geom_boxplot(fill = "lightblue") +
        labs(
          x = input$x_var,
          y = input$y_var,
          title = paste("Boxplot of", input$y_var, "by", input$x_var)
        ) +
        theme_minimal()
    })
  })
}
