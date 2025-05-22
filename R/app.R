library(shiny)
library(RMySQL)
library(pool)
library(auth0)

options(shiny.port = 8080)

config <- config::get(config = "REMOTE") # Enable this when testing in AWS RDS


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("AWS Connection Test with Docker and Auth0"),

    fluidRow(
        column(
            width=10,
            tableOutput("table")
            ),
        column(width=2,
               actionButton("logout", "Logout", icon = icon("right-from-bracket"), class = "btn btn-danger")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
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
    
    observeEvent(input$logout, {
        # Logout the user
        auth0::logout()
    })

}

# Run the application 
shinyAppAuth0(ui = ui, server = server)
