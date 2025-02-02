# UI with LCARS
ui <- lcarsPage(
  lcarsHeader("Dynamic LCARS Shiny App"),
  
  fluidRow(
    column(
      width = 3,
      lcarsBox(
        title = "Controls",
        uiOutput("dynamic_sidebar")  # ✅ Already correctly replaced with `uiOutput()`
      )
    ),
    
    column(
      width = 9,
      lcarsBox(
        title = "Main Panel",
        lcarsBox(  # ✅ Added `lcarsBox()` to style tabsetPanel()
          tabsetPanel(
            id = "dynamic_tabs",  # Dynamically generated tabs for modules
            tabPanel("Home", h3("Welcome to the Dynamic LCARS Shiny App"))
          )
        )
      )
    )
  )
)
