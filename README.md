# **Comprehensive Lesson Plan: GitHub for Collaborative Development**

This 5-hour workshop will teach participants how to use GitHub, covering the website, desktop app, and command-line interface (CLI). Participants will collaboratively build a Shiny app that ingests functions from a directory and integrates them into `ui.R` and `server.R`. Each participant will write small functions or UI/server segments to practice version control. The dataset used will be built into R (e.g., `mtcars`).

---

## **1. Introduction to GitHub (30 minutes)**

### **Objective**
- Understand what GitHub is and its role in collaborative software development.
- Learn key concepts: repositories, branches, commits, pull requests, and merges.

### **Activities**
1. **Presentation (10 minutes)**:
   - Explain Git, GitHub, and version control.
   - Discuss repositories, branches, commits, pull requests, and merges.
   - Highlight the differences between the GitHub website, desktop app, and CLI.

2. **Demo (10 minutes)**:
   - Show how to navigate the GitHub website.
   - Demonstrate the structure of a repository, focusing on the `app.R`, `global.R`, `ui.R`, and `server.R` files.

3. **Hands-on Setup (10 minutes)**:
   - Create a GitHub account (if needed).
   - Install Git and GitHub Desktop.
   - Configure Git (CLI) with `git config` commands.

---

## **2. Cloning and Exploring the Repository (30 minutes)**

### **Objective**
- Learn how to clone a repository and explore its contents.

### **Activities**
1. **Website Method (5 minutes)**:
   - Clone the repository using the "Code" button on the GitHub website and GitHub Desktop.

2. **CLI Method (10 minutes)**:
   - Clone using `git clone <repo-url>`.
   - Navigate into the directory using `cd <repo-name>`.

3. **Repository Tour (15 minutes)**:
   - Open the repository in an editor (e.g., RStudio or VSCode).
   - Discuss the `app.R`, `global.R`, `ui.R`, `server.R` files, and the `functions` directory.
   - Explain the expected functionality of the Shiny app.

---

## **3. Testing and Installing Required Libraries (15 minutes)**

### **Objective**
- Ensure all required libraries are installed to support the Shiny app development.

### **Activities**
1. **Install Required Libraries**:
   - Copy and run the following script to check and install missing libraries:
     ```r
     # Install required libraries if not already installed
     required_packages <- c(
       "shiny", "ggplot2", "leaflet", "leaflet.providers",
       "viridis", "openair", "sp", "ggspatial", "explore",
       "rpart.plot", "dplyr", "purrr", "here"
     )

     installed_packages <- installed.packages()[, "Package"]
     missing_packages <- setdiff(required_packages, installed_packages)

     if (length(missing_packages) > 0) {
       install.packages(missing_packages, dependencies = TRUE)
     } else {
       message("All required packages are already installed.")
     }
     ```

---

## **4. Creating and Editing a Module (45 minutes)**

### **Objective**
- Use an example module as a template and integrate it into the Shiny app.

### **Activities**
1. **Edit and Rename Example Module**:
   - Use the `meuseExplorerModule.R` file as a starting point.
   - Rename the module to reflect the dataset or functionality.
   - Update the module code to match the specific dataset being used. Example:
     ```r
newModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Interactive Plot Module"),
    actionButton(ns("reset"), "Reset", icon = icon("refresh")),
    plotOutput(ns("random_plot"))
  )
}

newModuleServer <- function(id, session) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Reactive expression to generate random data when reset is clicked
    random_data <- eventReactive(input$reset, {
      data.frame(
        x = runif(100),
        y = runif(100)
      )
    })
    
    # Render the plot
    output$random_plot <- renderPlot({
      data <- random_data()
      plot(data$x, data$y, 
           main = "Random Scatter Plot",
           xlab = "Random X", ylab = "Random Y",
           pch = 19, col = "blue")
    })
  })
}

     ```
   - Save the updated module in the `functions` directory.

2. **Integrate Module into Shiny App**:
   - Include the module in the `ui.R` and `server.R` files.
   - Test the module to ensure it works as expected.

---

## **5. Making Edits and Committing Changes (1 hour)**

### **Objective**
- Learn to create and edit files, stage and commit changes, and push updates.

### **Activities**
1. **Write Functions (30 minutes)**:
   - Assign each participant a small task:
     - Write a new function (e.g., a summary, plot, or data transformation function) and save it in the `functions` directory.
   - Example function for plotting `mtcars`:
     ```r
     create_plot <- function(data) {
       ggplot(data, aes(x = mpg, y = hp)) + geom_point()
     }
     ```
   - Save their work in `functions`.

2. **Commit Changes (30 minutes)**:
   - **GitHub Desktop**: Stage, commit, and push changes.
   - **CLI**: Use the following commands:
     ```bash
     git add functions/<filename>.R
     git commit -m "Added <description of function>"
     git push origin main
     ```

---

## **6. Branching, Pull Requests, and Merging (1.5 hours)**

### **Objective**
- Collaborate using branches and pull requests (PRs).

### **Activities**
1. **Create a Branch (15 minutes)**:
   - Teach how to create a branch using:
     - **CLI**: `git checkout -b <branch-name>`.
     - **Desktop**: Create a branch through the interface.
     - Make small edits (e.g., update `ui.R` or `server.R`) on the branch.

2. **Open a Pull Request (15 minutes)**:
   - Push the branch to GitHub:
     ```bash
     git push origin <branch-name>
     ```
   - Open a pull request on GitHub.
   - Add a title, description, and reviewers.

3. **Review and Merge PRs (45 minutes)**:
   - Assign participants as reviewers for each other's PRs.
   - Practice:
     - Adding comments to PRs.
     - Resolving conflicts (simulate by editing the same file in two branches).
     - Merging PRs into the main branch via the GitHub website or CLI.

---

## **7. Reverting Changes, Tagging, and Final Integration (1 hour)**

### **Objective**
- Handle mistakes by reverting changes, tagging releases, and integrating the final app.

### **Activities**
1. **Revert Changes (20 minutes)**:
   - Teach how to revert a commit:
     - **CLI**: `git revert <commit-hash>`.
     - **Desktop**: Use the "Revert" option.
   - Undo changes in the Shiny app (e.g., remove unnecessary functions).

2. **Tagging Releases (10 minutes)**:
   - Create a tag for the first release:
     ```bash
     git tag -a v1.0 -m "First release of the Shiny app"
     git push origin v1.0
     ```

3. **Integrate Functions into Shiny App (30 minutes)**:
   - Update `global.R` to source all functions in the `functions` directory:
     ```r
     list.files("functions", full.names = TRUE) %>% purrr::walk(source)
     ```
   - Integrate UI and server segments written by participants.

---

## **8. Wrap-Up and Q&A (30 minutes)**

### **Objective**
- Reinforce key lessons and address any questions.

### **Activities**
1. **Review (10 minutes)**:
   - Recap key GitHub workflows: cloning, branching, PRs, merging, and reverting.

2. **Show Final Shiny App (10 minutes)**:
   - Run the integrated Shiny app using `shiny::runApp()`.

3. **Q&A (10 minutes)**:
   - Answer participant questions and discuss further learning resources.

---

### **Deliverables**
1. Fully functional Shiny app built collaboratively.
2. Participants understand GitHub workflows and tools.

### **Post-Class Resources**
- GitHub Learning Lab.
- Cheat sheets for Git commands.
- Recommended courses on Git and GitHub.

