library(shiny)
library(ggplot2)
source("HalfpitchCreate.R")

shinyServer(function(input, output, session) {
    data <- reactiveVal(data.frame(x = numeric(0), y = numeric(0), team = character(0)))
    
    observeEvent(input$plot_click, {
        showModal(modalDialog(
            title = "Add Shot",
            textInput("playerName", "Player Name:"),
            numericInput("shotTime", "Time (in minutes):", min = 0, value = 0),
            radioButtons("isGoal", "Goal?", choices = c("Yes", "No"), selected = "No"),
            footer = tagList(
                actionButton("addShot", "Add Shot"),
                modalButton("Cancel")
            )
        ))
    })
    
    observeEvent(input$addShot, {
        player_name <- input$playerName
        time <- input$shotTime
        click <- input$plot_click
        is_goal <- input$isGoal  # Get the selected goal status
        
        if (!is.null(click$x) && click$x <= 50) {
            new_data <- data.frame(
                shot = as.integer(round(nrow(data()) + 1)),
                x = click$x, 
                y = click$y, 
                team = input$team, 
                player = player_name, 
                time = time,
                is_goal = is_goal  # Add the goal status to the data frame
            )
            data(rbind(data(), new_data))
        }
        removeModal()
    })
    # player_name <- reactiveVal("")
    # time <- reactiveVal(0)
    # 
    # observeEvent(input$plot_click, {
    #     click <- input$plot_click
    #     if (!is.null(click$x) && click$x <= 50) {  # Allowing marking shots only on one half of the pitch
    #         new_data <- data.frame(x = click$x, y = click$y, team = input$team)
    #         data(rbind(data(), new_data))
    #     }
    # })
    
    observeEvent(input$clearButton, {
        data(data.frame(x = numeric(0), y = numeric(0), team = character(0)))
    })
    
    output$pitch <- renderPlot({
        shots_data <- data()  # Assuming this function retrieves your shot data
        
        if (!is.null(shots_data) && 'x' %in% colnames(shots_data) && 'y' %in% colnames(shots_data) && 'shot' %in% colnames(shots_data)) {
            pitch <- create_StatsBomb_ShotMap("darkgreen", "white", "black", "grey")
            dots <- geom_point(data = shots_data, aes(x = x, y = y), size = 4, color = "blue")
            
            labels <- geom_text(data = shots_data, aes(x = x, y = y, label = as.character(shot)), 
                                size = 4, fontface = "bold", color = "white", vjust = -0.5)
            
            
            plot <- pitch + dots + labels
            plot + coord_fixed(ratio = 3.75/4)
        } else {
            pitch <- create_StatsBomb_ShotMap("darkgreen", "white", "black", "grey")
            pitch + coord_fixed(ratio = 3.75/4)  # Return the pitch without shots
        }
    })
    
    observeEvent(input$addButton, {
        player_name(player_name())
        time(as.numeric(input$timeInput))
    })
    
    output$dataframeTitle <- renderText({
        "Shot Data:"  # Set the desired title for your dataframe
    })
    
    output$dataTable <- renderTable({
        shots_data <- data()
        if (!is.null(shots_data)) {
            # Exclude x and y columns from the table
            shots_data <- shots_data[, !names(shots_data) %in% c("x", "y")]
        }
        shots_data
    })
    
    output$playerNameInput <- renderUI({
        textInput("playerNameInput", "Player Name:", value = player_name())
    })
    
    output$timeInput <- renderUI({
        numericInput("timeInput", "Time:", value = time())
    })
})
