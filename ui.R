library(shiny)
library(ggplot2)

shinyUI(fluidPage(
    titlePanel("Shot Plot"),
    
    sidebarLayout(
        sidebarPanel(
            p("Mark where the shot took place"),
            textInput("team", "Enter Team Name", value = "Team 1"),
            actionButton("clearButton", "Clear Shots"),
            # uiOutput("playerNameInput"),
            # uiOutput("timeInput"),
            # actionButton("addButton", "Add Shot")
        ),
        
        mainPanel(
            plotOutput("pitch", click = "plot_click"),
            br(),
            p("Shots Data:"),
            tableOutput("dataTable")
        )
    )
))
