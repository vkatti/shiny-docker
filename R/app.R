#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(RMySQL)
library(pool)

config <- config::get(config = "REMOTE") # Enable this when testing in AWS RDS

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("AWS Connection Test with Docker"),

    fluidRow(
        tableOutput("table")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$table <- renderTable({
        # Create a connection pool
        pool <- dbPool(
            drv = RMySQL::MySQL(),
            dbname = config$dbname,
            host = config$host,
            username = config$user,
            password = config$password
        )
        
        # Query the database
        query <- "SELECT * FROM vw_branch"  # Replace with your actual query
        result <- dbGetQuery(pool, query)
        
        # Close the connection pool
        poolClose(pool)
        
        # Return the result as a table
        result
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
