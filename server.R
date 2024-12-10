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
  if (dir.exists("modules")) {
    module_files <- list.files("modules", pattern = "\\.R$", full.names = TRUE)
    for (module_file in module_files) {
      module_name <- tools::file_path_sans_ext(basename(module_file))
      
      # Assume each module defines a `moduleNameUI` and `moduleNameServer` function
      module_ui_fn <- paste0(module_name, "UI")
      module_server_fn <- paste0(module_name, "Server")
      
      if (exists(module_ui_fn) && exists(module_server_fn)) {
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
        do.call(get(module_server_fn), list(module_name, session))
      }
    }
  }
}