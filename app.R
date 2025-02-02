# Global for sourcing global.R
ui_file <- "global.R"
cat("\033[1;35mGlobal:\033[0m Sourcing 'global.R'...\n")
tryCatch({
  source(ui_file)
  cat("\033[1;32mSuccess:\033[0m Successfully sourced 'global.R'.\n")
}, error = function(e) {
  cat("\033[1;31mError:\033[0m Failed to source 'global.R' -", e$message, "\n")
})

# Diagnostics for sourcing ui.R
ui_file <- "ui.R"
cat("\033[1;35mDiagnostics:\033[0m Sourcing 'ui.R'...\n")
tryCatch({
  source(ui_file)
  cat("\033[1;32mSuccess:\033[0m Successfully sourced 'ui.R'.\n")
}, error = function(e) {
  cat("\033[1;31mError:\033[0m Failed to source 'ui.R' -", e$message, "\n")
})

# Diagnostics for sourcing server.R
server_file <- "server.R"
cat("\033[1;35mDiagnostics:\033[0m Sourcing 'server.R'...\n")
tryCatch({
  source(server_file)
  cat("\033[1;32mSuccess:\033[0m Successfully sourced 'server.R'.\n")
}, error = function(e) {
  cat("\033[1;31mError:\033[0m Failed to source 'server.R' -", e$message, "\n")
})

# Diagnostics for running the application
cat("\033[1;34mDiagnostics:\033[0m Starting Shiny application...\n")
tryCatch({
  shinyApp(ui = ui, server = server)
}, error = function(e) {
  cat("\033[1;31mError:\033[0m Shiny application failed to start -", e$message, "\n")
})
