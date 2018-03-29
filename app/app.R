library(shiny)
library(shiny)

#runApp(list(
#  ui=pageWithSidebar(headerPanel("Adding entries to table"),
#                 sidebarPanel(textInput("text1", "Column 1"),
#                              textInput("text2", "Column 2"),
#                 mainPanel(tableOutput("table1"))),
#server=function(input, output, session) {
#}))

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
      actionButton("update", "Add row"),
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

  newEntry <- observe({
    if(input$update > 0) {
      newLine <- isolate(c(input$text1, input$text2, input$result))
      isolate(values$df[nrow(values$df) + 1,] <- c(input$text1, input$text2, input$result))
    }
  })
  output$table1 <- renderTable({values$df})

  output$rank <- renderText({ 
    sprintf("Your current rating is %s (mu = %s, phi = %s)", input$mu - (2.5 * input$phi), input$mu, input$phi) 
  })

  # function to compute rankings
  muphi <- eventReactive(input$compute, { 
    list(mu=1922, phi=121) 
  })

  output$newranking <- renderText({ 
    mu = muphi()$mu
    phi = muphi()$phi
    sprintf("After the games below your rating would be %s (mu = %s, phi = %s).", mu - (2.5*phi), mu, phi)
  })

}


shinyApp(ui = ui, server = server)
