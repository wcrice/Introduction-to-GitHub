ui <- lcarsPage(
  lcarsHeader("Dynamic LCARS Shiny App"),
  
  fluidRow(
    # Left Panel: Navigation Panel (Takes 90% of Vertical Space)
    column(
      width = 3,
      div(style = "height: 90vh; display: flex; flex-direction: column;",
          lcarsBox(
            title = "Navigation",
            left_inputs = inputColumn(  # ✅ Correct LCARS layout for vertical buttons
              uiOutput("dynamic_sidebar"),  # ✅ Dynamically generated buttons appear here
              uiOutput("navigation_controls")  # ✅ Module-specific navigation controls appear here
            ),
            width_left = 200  # ✅ Ensure proper width for LCARS sidebar
          )
      )
    ),
    
    # Main Panel: Displays Content Dynamically
    column(
      width = 9,
      lcarsBox(
        title = "Main Panel",
        uiOutput("dynamic_content")  # ✅ Module content dynamically updates here
      )
    )
  )
)