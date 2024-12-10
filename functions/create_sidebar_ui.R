create_sidebar_ui <- function() {
  tagList(
    h3("Welcome to the Collaborative Learning App!"),
    p(
      "This Shiny app is designed to help you learn GitHub in a collaborative environment. 
      Here's how you can use this app to improve your GitHub skills:"
    ),
    tags$ul(
      tags$li("Clone the repository to your local machine using Git or GitHub Desktop."),
      tags$li("Add new functions to the 'functions' directory to expand the app's capabilities."),
      tags$li("Create new modules and save them in the 'modules' directory to add new features."),
      tags$li("Commit your changes locally and push them to the shared repository."),
      tags$li("Open pull requests to propose changes, and review changes proposed by others."),
      tags$li("Merge pull requests to incorporate contributions into the main branch."),
      tags$li(
        "Experiment with reverting commits or resolving merge conflicts to practice 
        handling real-world Git scenarios."
      )
    ),
    p(
      "As you contribute to this app, you'll gain hands-on experience with key GitHub workflows 
      like cloning repositories, branching, committing changes, managing pull requests, and resolving conflicts."
    ),
    hr(),
    h4("Ready to Start?"),
    p("Use the navigation tabs to explore different dataset modules and practice enhancing them!"),
    actionButton("get_started", "Get Started!", icon = icon("rocket"))
  )
}
