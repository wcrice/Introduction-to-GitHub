# Module UI with LCARS
mtcarsExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    lcarsBox(
      title = "Explore the 'mtcars' Dataset",
      fluidRow(
        column(
          width = 3,
          lcarsBox(
            title = "Filter and Analyze Data",
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
            )
          ),
          lcarsBox(
            title = "Variable Descriptions",
            p("Descriptions of dataset variables:"),
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
          )
        ),
        column(
          width = 9,
          lcarsBox(
            title = "Data Exploration",
            tabsetPanel(  # ✅ Replaced lcarsTabsetPanel() with tabsetPanel()
              tabPanel("Table", tableOutput(ns("data_table"))),  # ✅ Replaced lcarsTableOutput() with tableOutput()
              tabPanel("Summary", verbatimTextOutput(ns("summary"))),  # ✅ Replaced lcarsVerbatimTextOutput() with verbatimTextOutput()
              tabPanel("Scatter Plot", plotOutput(ns("scatter_plot"))),  # ✅ Replaced lcarsPlotOutput() with plotOutput()
              tabPanel("Boxplot", plotOutput(ns("boxplot")))  # ✅ Replaced lcarsPlotOutput() with plotOutput()
            )
          )
        )
      )
    )
  )
}
