library(dplyr)
library(purrr)
library(fst)
library(lcars)
library(here)
library(shiny)

# Diagnostics for sourcing functions
cat("\033[1;35mDiagnostics:\033[0m Checking 'functions' directory...\n")  # LCARS-style console log
functions_dir <- "functions"
cat("Function directory:", functions_dir, "\n")

if (dir.exists(functions_dir)) {
  function_files <- list.files(functions_dir, full.names = TRUE, pattern = "\\.R$")
  cat("\033[1;34mDiagnostics:\033[0m Found", length(function_files), "function files in 'functions' directory.\n")
  
  if (length(function_files) > 0) {
    cat("\033[1;32mDiagnostics:\033[0m Sourcing function files...\n")
    function_files %>% walk(function(file) {
      tryCatch({
        source(file)
        cat("\033[1;32mSuccess:\033[0m Sourced:", file, "\n")
      }, error = function(e) {
        cat("\033[1;31mError:\033[0m Failed to source", file, "-", e$message, "\n")
      })
    })
  }
  
  cat("\033[1;34mDiagnostics:\033[0m Listing function files with their paths...\n")
  function_files %>% walk(function(file) {
    cat("Function file:", file, "\n")
  })
} else {
  cat("\033[1;31mWarning:\033[0m 'functions' directory does not exist.\n")
}

# Diagnostics for sourcing modules
cat("\033[1;35mDiagnostics:\033[0m Checking 'modules' directory...\n")
modules_dir <- "modules"
cat("Modules directory:", modules_dir, "\n")

if (dir.exists(modules_dir)) {
  module_files <- list.files(modules_dir, full.names = TRUE, pattern = "\\.R$")
  cat("\033[1;34mDiagnostics:\033[0m Found", length(module_files), "module files in 'modules' directory.\n")
  
  if (length(module_files) > 0) {
    cat("\033[1;32mDiagnostics:\033[0m Sourcing module files...\n")
    module_files %>% walk(function(file) {
      tryCatch({
        source(file)
        module_name <- tools::file_path_sans_ext(basename(file))
        ui_fn <- paste0(module_name, "UI")
        server_fn <- paste0(module_name, "Server")
        ui_exists <- exists(ui_fn)
        server_exists <- exists(server_fn)
        
        if (ui_exists & server_exists) {
          cat("\033[1;32mSuccess:\033[0m Valid module sourced:", file, "\n")
        } else {
          cat("\033[1;33mWarning:\033[0m Invalid module:", file, "\n")
          cat("  - UI exists:", ui_exists, "\n")
          cat("  - Server exists:", server_exists, "\n")
        }
      }, error = function(e) {
        cat("\033[1;31mError:\033[0m Failed to source", file, "-", e$message, "\n")
      })
    })
  }
  
  cat("\033[1;34mDiagnostics:\033[0m Listing module files with their paths...\n")
  module_files %>% walk(function(file) {
    cat("Module file:", file, "\n")
  })
} else {
  cat("\033[1;31mWarning:\033[0m 'modules' directory does not exist.\n")
}
