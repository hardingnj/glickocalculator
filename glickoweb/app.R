library(shiny)
library(reticulate)
use_python("/usr/bin/python3")
source_python("compute.py")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel("Glicko calculator"),

  sidebarLayout(
    sidebarPanel(
      helpText("Add your starting mu and phi values below."),
      numericInput("mu", "player mu", value=1500, min=0, max=3000, step=50),
      numericInput("phi", "player phi", value=350, min=10, max=350, step=10),
      helpText("Add your opponents' mu and phi values and the result below. Click the button to add to the table on the right. To reset, refresh the page."),
      numericInput("text1", "Opponent mu", value=1500, min=0, max=3000, step=50),
      numericInput("text2", "Opponent phi", value=350, min=10, max=350, step=10),
      radioButtons("result", "Result", choices = list("Win" = 1, "Loss" = 0, "Draw" = 0.5), selected = 0.5),
      fluidRow(
        splitLayout(
          actionButton("update", "Add result"),
          actionButton("clear", "Clear table")
        )
      ),
      tags$hr(),
      actionButton("compute", h3("Compute ranking"))
    ),

    mainPanel(
      h4(textOutput("rank")),
      h4(textOutput("newranking")),
      tableOutput("table1")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  
  values <- reactiveValues()

  colClasses = c("numeric", "numeric", "numeric")
  col.names = c("Opponent_mu", "Opponent_phi", "Result")

  values$df <- read.table(
    text = "", colClasses = colClasses, col.names = col.names)

  # add rows
  newEntry <- observe({
    if(input$update > 0) {
      isolate(values$df[nrow(values$df) + 1,] <- c(input$text1, input$text2, input$result))
    }
  })

  # function to clear table 
  newEntry <- observe({
    if(input$clear > 0) {
      values$df <- read.table(text = "", colClasses = colClasses, col.names = col.names)
    }
  })

  output$table1 <- renderTable({values$df})

  # function to compute rankings
  muphi <- eventReactive(input$compute, { 
    if (nrow(values$df) > 0) {
      compute(p_mu=input$mu, p_phi=input$phi, table=as.matrix(values$df))
    }
  })

  output$rank <- renderText({ 
    sprintf("Your current rating is %.1f (mu = %.1f, phi = %.1f)", input$mu - (2.5 * input$phi), input$mu, input$phi) 
  })

  output$newranking <- renderText({ 
    mu = muphi()$mu
    phi = muphi()$phi
    sprintf("After the games below your rating would be %.1f (mu = %.1f, phi = %.1f).", mu - (2.5*phi), mu, phi)
  })
}

shinyApp(ui = ui, server = server)
