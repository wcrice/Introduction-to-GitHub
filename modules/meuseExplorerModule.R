# Module UI with LCARS
meuseExplorerModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    lcarsBox(
      title = "Explore the Meuse Dataset",
      tabsetPanel(  # ✅ Replaced lcarsTabsetPanel() with tabsetPanel()
        tabPanel(
          "Visualization",
          fluidRow(
            column(
              width = 3,
              lcarsBox(
                title = "Visualization Options",
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
                lcarsCheckbox(ns("show_points"), "Show Spatial Points", value = TRUE),
                lcarsButton(ns("fit_model"), "Fit Linear Model"),
                br(),
                uiOutput(ns("model_summary"))  # ✅ Replaced lcarsOutput() with uiOutput()
              )
            ),
            column(
              width = 9,
              lcarsBox(
                title = "Spatial Plot",
                plotOutput(ns("spatial_plot"))  # ✅ Replaced lcarsPlotOutput() with plotOutput()
              ),
              lcarsBox(
                title = "Residuals Plot",
                plotOutput(ns("residuals_plot"))  # ✅ Replaced lcarsPlotOutput() with plotOutput()
              )
            )
          )
        ),
        tabPanel(  # ✅ Replaced lcarsTabPanel() with tabPanel()
          "Interactive Map",
          lcarsBox(
            title = "Meuse Dataset Map",
            leafletOutput(ns("meuse_map"))  # ✅ Replaced lcarsLeafletOutput() with leafletOutput()
          ),
          lcarsBox(
            title = "Data Source",
            p(
              "This dataset gives locations and topsoil heavy metal concentrations, along with a number of soil and landscape variables at the observation locations, collected in a flood plain of the river Meuse, near the village of Stein (NL)."
            ),
            p("For more information, visit the official R documentation:"),
            tags$a(href = "https://search.r-project.org/CRAN/refmans/sp/html/meuse.html", 
                   "Meuse {sp} R Documentation", target = "_blank"),
            br(),
            p("References:"),
            tags$ul(
              tags$li("M G J Rikken and R P G Van Rijn, 1993. Soil pollution with heavy metals."),
              tags$li("P.A. Burrough, R.A. McDonnell, 1998. Principles of Geographical Information Systems."),
              tags$li("Stichting voor Bodemkartering (STIBOKA), 1970. Bodemkaart van Nederland.")
            )
          )
        )
      )
    )
  )
}
