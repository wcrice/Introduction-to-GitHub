exampleModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Example Module"),
    textOutput(ns("example_text"))
  )
}

exampleModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    output$example_text <- renderText({
      "This is an example module!"
    })
  })
}
