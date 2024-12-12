library(here)

# Server
server <- function(input, output, session) {
  
  # Generate dynamic sidebar UI (e.g., based on sourced functions)
  output$dynamic_sidebar <- renderUI({
  if (exists("create_sidebar_ui")) {
    create_sidebar_ui()
  } else {
    h4("No dynamic sidebar UI available.")
  }
  })
  
  # Dynamically add tabs for modules
  modules_dir <- here("modules")
  if (dir.exists(modules_dir)) {
  cat("Modules directory exists: ", modules_dir, "\n")
  module_files <- list.files(modules_dir, pattern = "\\.R$", full.names = TRUE)
  cat("Found module files: ", module_files, "\n")
  for (module_file in module_files) {
    module_name <- tools::file_path_sans_ext(basename(module_file))
    cat("Processing module: ", module_name, "\n")
    
    # Assume each module defines a `moduleNameUI` and `moduleNameServer` function
    module_ui_fn <- paste0(module_name, "UI")
    module_server_fn <- paste0(module_name, "Server")
    
    if (exists(module_ui_fn) && exists(module_server_fn)) {
    cat("Found UI and Server functions for module: ", module_name, "\n")
    # Add a tab for the module
    insertTab(
      inputId = "dynamic_tabs",
      tabPanel(
      title = module_name,
      do.call(get(module_ui_fn), list(module_name))
      ),
      target = "Home",
      position = "after"
    )
    
    # Call the module's server function
    do.call(get(module_server_fn), list(id = module_name))
    } else {
    cat("UI or Server function missing for module: ", module_name, "\n")
    }
  }
  } else {
  cat("Modules directory does not exist: ", modules_dir, "\n")
  }
}