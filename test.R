library(shiny)
library(lcars)

# Define UI
ui <- lcarsPage(
  lcarsHeader("Dynamic LCARS Shiny App"),
  
  fluidRow(
    column(
      width = 3,
      lcarsBox(
        title = "Navigation",
        left_inputs = inputColumn(
          lcarsButton("home", "Home"),
          lcarsButton("module1", "Module 1"),
          lcarsButton("module2", "Module 2"),
          lcarsButton("module3", "Module 3")
        ),
        width_left = 200  # Adjust the width as needed
      )
    ),
    
    column(
      width = 9,
      lcarsBox(
        title = "Main Panel",
        uiOutput("dynamic_content")
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive value to track the current tab
  current_tab <- reactiveVal("home")
  
  # Observe button clicks to update the current tab
  observeEvent(input$home, {
    current_tab("home")
  })
  observeEvent(input$module1, {
    current_tab("module1")
  })
  observeEvent(input$module2, {
    current_tab("module2")
  })
  observeEvent(input$module3, {
    current_tab("module3")
  })
  
  # Render dynamic content based on the current tab
  output$dynamic_content <- renderUI({
    switch(current_tab(),
           "home" = h3("Welcome to the Dynamic LCARS Shiny App"),
           "module1" = h3("Content for Module 1"),
           "module2" = h3("Content for Module 2"),
           "module3" = h3("Content for Module 3")
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
