library(dplyr)
library(purrr)
library(here)

# Global for sourcing global.R
ui_file <- here("global.R")
cat("Global: Sourcing 'global.R'...\n")
tryCatch({
  source(ui_file)
  cat("Global: Successfully sourced 'global.R'.\n")
}, error = function(e) {
  cat("Error: Failed to source 'global.R' -", e$message, "\n")
})

# Diagnostics for sourcing ui.R
ui_file <- here("ui.R")
cat("Diagnostics: Sourcing 'ui.R'...\n")
tryCatch({
  source(ui_file)
  cat("Diagnostics: Successfully sourced 'ui.R'.\n")
}, error = function(e) {
  cat("Error: Failed to source 'ui.R' -", e$message, "\n")
})

# Diagnostics for sourcing server.R
server_file <- here("server.R")
cat("Diagnostics: Sourcing 'server.R'...\n")
tryCatch({
  source(server_file)
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
