library(shiny)

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout(

    position = "right",
    sidebarPanel = sidebarPanel(
      width = 3,
      sliderInput(
        inputId = "num",
        label = "Número de observações:",
        min = 1,
        max = 1000,
        value = 500
      )
    ),
    mainPanel = mainPanel(
      width = 9,
      plotOutput("histograma")
    )
  )
)

server <- function(input, output, session) {
  output$histograma <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra)
  })
}

shinyApp(ui, server)
