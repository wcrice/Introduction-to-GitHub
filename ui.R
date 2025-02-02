# Define UI
ui <- lcarsPage(
  lcarsHeader("Dynamic LCARS Shiny App"),
  
  fluidRow(
    # Sidebar: Dynamically Generated Buttons (Vertically Stacked)
    column(
      width = 3,
      lcarsBox(
        title = "Modules",
        left_inputs = inputColumn(  # ✅ Correct LCARS layout for vertical buttons
          uiOutput("dynamic_sidebar")  # ✅ Dynamically generated buttons appear here
        ),
        width_left = 200  # ✅ Ensure proper width for LCARS sidebar
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