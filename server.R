server <- function(input, output, session) {
  
  # Generate dynamic navigation buttons for modules
  output$dynamic_sidebar <- renderUI({
    modules_dir <- "modules"
    if (dir.exists(modules_dir)) {
      module_files <- list.files(modules_dir, pattern = "\\.R$", full.names = TRUE)
      module_names <- tools::file_path_sans_ext(basename(module_files))
      
      print("Generating module buttons...")
      print(module_names)  # ✅ Debugging
      
      button_list <- lapply(module_names, function(mod) {
        lcarsButton(inputId = paste0("nav_", mod), label = mod)
      })
      
      do.call(tagList, button_list)  # ✅ Correctly stacks buttons vertically
    } else {
      print("No modules found.")
      NULL  # ✅ No text output if no modules exist
    }
  })
  
  # Reactive Value to Track Selected Module
  selected_module <- reactiveVal("Home")
  
  # Handle Button Clicks to Switch Content
  observe({
    modules_dir <- "modules"
    if (dir.exists(modules_dir)) {
      module_files <- list.files(modules_dir, pattern = "\\.R$", full.names = TRUE)
      module_names <- tools::file_path_sans_ext(basename(module_files))
      
      for (module_name in module_names) {
        local({  # ✅ Ensures correct event binding
          mod <- module_name  # Capture module name in local scope
          observeEvent(input[[paste0("nav_", mod)]], {
            print(paste("Button clicked for:", mod))  # ✅ Debugging
            selected_module(mod)
          })
        })
      }
    }
  })
  
  # Render Selected Module's UI
  output$dynamic_content <- renderUI({
    req(selected_module())
    
    print(paste("Attempting to load UI for module:", selected_module()))  # ✅ Debugging
    
    if (selected_module() == "Home") {
      return(h3("Welcome to the Dynamic LCARS Shiny App"))
    }
    
    module_ui_fn <- paste0(selected_module(), "UI")
    if (exists(module_ui_fn)) {
      print(paste("Found function:", module_ui_fn))  # ✅ Debugging
      return(lcarsBox(do.call(get(module_ui_fn), list(selected_module()))))
    } else {
      print("Module function does not exist!")
      return(p("Module UI function not found."))
    }
  })
}