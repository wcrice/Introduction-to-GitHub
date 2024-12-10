library(dplyr)
library(purrr)

# Diagnostics for sourcing functions
cat("Diagnostics: Checking 'functions' directory...\n")
if (dir.exists("functions")) {
  function_files <- list.files("functions", full.names = TRUE, pattern = "\\.R$")
  cat("Diagnostics: Found", length(function_files), "function files in 'functions' directory.\n")
  if (length(function_files) > 0) {
    cat("Diagnostics: Sourcing function files...\n")
    function_files %>% walk(function(file) {
      tryCatch({
        source(file)
        cat("Diagnostics: Successfully sourced:", file, "\n")
      }, error = function(e) {
        cat("Error: Failed to source", file, "-", e$message, "\n")
      })
    })
  }
} else {
  cat("Warning: 'functions' directory does not exist.\n")
}

# Diagnostics for sourcing modules
cat("Diagnostics: Checking 'modules' directory...\n")
if (dir.exists("modules")) {
  module_files <- list.files("modules", full.names = TRUE, pattern = "\\.R$")
  cat("Diagnostics: Found", length(module_files), "module files in 'modules' directory.\n")
  
  if (length(module_files) > 0) {
    cat("Diagnostics: Sourcing module files...\n")
    module_files %>% walk(function(file) {
      tryCatch({
        source(file)
        module_name <- tools::file_path_sans_ext(basename(file))
        ui_fn <- paste0(module_name, "UI")
        server_fn <- paste0(module_name, "Server")
        ui_exists <- exists(ui_fn)
        server_exists <- exists(server_fn)
        
        if (ui_exists & server_exists) {
          cat("Diagnostics: Valid module sourced:", file, "\n")
        } else {
          cat("Diagnostics: Invalid module:", file, "\n")
          cat("  - UI exists:", ui_exists, "\n")
          cat("  - Server exists:", server_exists, "\n")
        }
      }, error = function(e) {
        cat("Error: Failed to source", file, "-", e$message, "\n")
      })
    })
  }
} else {
  cat("Warning: 'modules' directory does not exist.\n")
}

# Diagnostics for sourcing ui.R
cat("Diagnostics: Sourcing 'ui.R'...\n")
tryCatch({
  source("ui.R")
  cat("Diagnostics: Successfully sourced 'ui.R'.\n")
}, error = function(e) {
  cat("Error: Failed to source 'ui.R' -", e$message, "\n")
})

# Diagnostics for sourcing server.R
cat("Diagnostics: Sourcing 'server.R'...\n")
tryCatch({
  source("server.R")
  cat("Diagnostics: Successfully sourced 'server.R'.\n")
}, error = function(e) {
  cat("Error: Failed to source 'server.R' -", e$message, "\n")
})

# Diagnostics for running the application
cat("Diagnostics: Starting Shiny application...\n")
tryCatch({
  shinyApp(ui = ui, server = server)
}, error = function(e) {
  cat("Error: Shiny application failed to start -", e$message, "\n")
})
