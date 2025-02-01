# **Interactive Workshop: GitHub Desktop for Collaborative Development**

## **Workshop Overview**

This 1-hour interactive workshop focuses on using **GitHub Desktop** for collaborative development. Participants will collaboratively build a Shiny app by creating and integrating modular functions. The workshop will use the built-in R dataset `mtcars`.

---

## **Before You Start**

**Required Tools and Setup:**  
Before attending the workshop, make sure you have the following installed and configured:

1. **GitHub Account:**  
   - A GitHub account linked to your **LWA** email address.  
   - If you don't have one, sign up at [github.com](https://github.com) using your LWA email.

2. **GitHub Desktop:**  
   - Download and install GitHub Desktop: [desktop.github.com](https://desktop.github.com/).  

3. **R and RStudio:**  
   - Install **R**: [cran.r-project.org](https://cran.r-project.org/)  
   - Install **RStudio**: [posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)  

4. **Internet Access and Permissions:**  
   - Ensure you have internet access and permission to install software on your device.

**Optional but Recommended:**  
- Text editor like **VSCode** or **Notepad++** for quick file edits.

---

## **Agenda**

### **1. Introduction to GitHub and GitHub Desktop (10 minutes)**

**Objective:**  
- Understand GitHub and how GitHub Desktop simplifies version control for collaboration.

**Activity:**  
- **Interactive Discussion:**  
  - What is GitHub? Why is version control important?  
  - Key concepts: repositories, commits, branches, pull requests, and merges.  
- **Live Demo:**  
  - Walk through the GitHub Desktop interface: cloning repositories, making commits, and pushing changes.

---

### **2. Setting Up GitHub Desktop (10 minutes)**

**Objective:**  
- Install and configure GitHub Desktop for project collaboration.  

**Activity:**  
- **Step-by-Step Setup:**  
  - Open GitHub Desktop and sign in with your **LWA GitHub account**.  
  - Configure Git settings:  
    - **File → Options → Git:**  
      - **Name:** Your full name (e.g., "Jane Doe")  
      - **Email:** Your LWA email (e.g., `jane.doe@lwa.org`)  
- **Quick Check:**  
  - Verify setup by confirming your profile appears in GitHub Desktop.

---

### **3. Cloning the Repository (10 minutes)**

**Objective:**  
- Clone the project repository using GitHub Desktop.  

**Activity:**  
- **Guided Exercise:**  
  - Click **File → Clone Repository**.  
  - Paste the provided repository URL → Choose a local folder → **Clone**.  
- **Repository Tour:**  
  - Open the project in **RStudio**.  
  - Identify and discuss the roles of `app.R`, `ui.R`, `server.R`, and the `functions` folder.

---

### **4. Installing Required Libraries (5 minutes)**

**Objective:**  
- Install all necessary R libraries for running the Shiny app.  

**Activity:**  
- **Hands-on Coding:**  
  - In **RStudio**, run this script to install missing packages:  
    ```r
    required_packages <- c("shiny", "ggplot2", "dplyr")
    installed_packages <- installed.packages()[, "Package"]
    missing_packages <- setdiff(required_packages, installed_packages)

    if (length(missing_packages) > 0) {
      install.packages(missing_packages)
    }
    ```  
- **Group Check-In:**  
  - Confirm that the app loads without errors.

---

### **5. Creating and Integrating a Module (15 minutes)**

**Objective:**  
- Create a simple module and integrate it into the Shiny app.  

**Activity:**  
- **Hands-on Coding:**  
  - Create a new file in the `functions` folder named `plotModule.R`:  
    ```r
    plotModuleUI <- function(id) {
      ns <- NS(id)
      tagList(
        h3("MTCARS Plot"),
        plotOutput(ns("car_plot"))
      )
    }

    plotModuleServer <- function(id) {
      moduleServer(id, function(input, output, session) {
        output$car_plot <- renderPlot({
          ggplot(mtcars, aes(x = mpg, y = hp)) + geom_point()
        })
      })
    }
    ```  
- **Integration Task:**  
  - Add `plotModuleUI("plot1")` to **`ui.R`**.  
  - Add `plotModuleServer("plot1")` to **`server.R`**.  
- **Test Run:**  
  - Run the app in **RStudio** to confirm the plot appears.

---

### **6. Committing and Pushing Changes with GitHub Desktop (15 minutes)**

**Objective:**  
- Use GitHub Desktop to commit and push changes.  

**Activity:**  
- **Hands-on Exercise:**  
  - Open **GitHub Desktop** and view the repository.  
  - **Stage and Commit Changes:**  
    - Enter a commit message (e.g., "Added plot module").  
    - Click **Commit to main**.  
  - **Push Changes:**  
    - Click **Push origin** to update the remote repository.  
- **Peer Review:**  
  - Pair up and verify each other’s changes on the GitHub website.

---

### **7. Branching, Pull Requests, and Merging (10 minutes)**

**Objective:**  
- Learn to collaborate using branches and pull requests.  

**Activity:**  
- **Branching:**  
  - In GitHub Desktop, click **Current Branch → New Branch** (name it `feature-plot`).  
  - Make a small edit (e.g., change the plot color) and **Commit** the change.  
- **Pull Request:**  
  - Click **Publish Branch** → **View on GitHub** → **New Pull Request**.  
  - Add a title, description, and **Create Pull Request**.  
- **Merging:**  
  - Review a partner’s pull request and **Merge** it.

---

### **8. Wrap-Up and Q&A (5 minutes)**

**Objective:**  
- Review key concepts and answer any remaining questions.  

**Activity:**  
- **Quick Recap:**  
  - Cloning, committing, pushing, branching, and pull requests.  
- **Final Run:**  
  - Launch the Shiny app in **RStudio**.  
- **Open Q&A:**  
  - Discuss additional learning resources and next steps.

---

### **Takeaways**

- Fully functional Shiny app built collaboratively.  
- Hands-on experience with GitHub Desktop workflows.  

**Post-Workshop Resources:**  
- GitHub Learning Lab  
- GitHub Desktop Documentation  
- RStudio Git Integration Guide
