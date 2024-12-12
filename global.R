library(dplyr)
library(purrr)
library(fst)

# Diagnostics for sourcing functions
cat("Diagnostics: Checking 'functions' directory...\n")
functions_dir <- "functions"
cat("Function directory:", functions_dir, "\n")

# Attempt to load the data and check if the file exists
path_telem_out <- file.path(Sys.getenv("PATH_TELEM_OUT"), "src_dev")
data_file <- file.path(path_telem_out, "loggernet_data_qaqc.fst")

if (dir.exists(functions_dir)) {
  function_files <- list.files(functions_dir, full.names = TRUE, pattern = "\\.R$")
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
  cat("Diagnostics: Listing function files with their paths...\n")
  function_files %>% walk(function(file) {
    cat("Function file:", file, "\n")
  })
} else {
  cat("Warning: 'functions' directory does not exist.\n")
}

# Diagnostics for sourcing modules
cat("Diagnostics: Checking 'modules' directory...\n")
modules_dir <- "modules"
cat("Modules directory:", modules_dir, "\n")

if (dir.exists(modules_dir)) {
  module_files <- list.files(modules_dir, full.names = TRUE, pattern = "\\.R$")
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
  cat("Diagnostics: Listing module files with their paths...\n")
  module_files %>% walk(function(file) {
    cat("Module file:", file, "\n")
  })
} else {
  cat("Warning: 'modules' directory does not exist.\n")
}

cat("Checking if data file exists at:", data_file, "\n")

if (file.exists(data_file)) {
  cat("Data file found. Attempting to load the data...\n")
  
  loggernet <- tryCatch({
    fst::read_fst(data_file)
  }, error = function(e) {
    cat("Error loading data:", e$message, "\n")
    stop("Data loading failed. Check the file path and format.")
  })
    cat("Summarizing Data.\n")

      loggernet_summary <- loggernet %>%
      group_by(Site_ID, basin, Elevation_ft, lat, lon) %>%
      summarise(
        S_Installed = first(S_Installed),
        S_Removed = first(S_Removed),
        Min_TIMESTAMP = min(TIMESTAMP),
        Max_TIMESTAMP = max(TIMESTAMP),
        .groups = 'drop'
      )

    print(loggernet_summary)
  cat("Data successfully loaded.\n")
  
} else {
  cat("Data file not found at:", data_file, "\n")
  stop("Data file is missing. Ensure the file path is correct.")
}