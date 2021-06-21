library(shiny)

ui <- fluidPage(
  "Vários histogramas",
  selectInput(
    inputId = "variavel",
    label = "Selecione a variável",
    choices = names(mtcars)
  ),
  plotOutput("histograma")
)

server <- function(input, output, session) {

  output$histograma <- renderPlot({
    hist(mtcars[[input$variavel]])
  })

}

shinyApp(ui, server)
