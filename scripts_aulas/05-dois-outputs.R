library(shiny)

ui <- fluidPage(
  "Histograma da distribuição normal",
  sliderInput(
    inputId = "num",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100
  ),
  textInput(inputId = "titulo", label = "Título do gráfico"),
  plotOutput(outputId = "histograma"),
  "Tabela com sumário",
  tableOutput("sumario")
)

server <- function(input, output, session) {



  output$histograma <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra, main = input$titulo)
  })

  output$sumario <- renderTable({
    amostra <- rnorm(input$num)
    data.frame(
      media = mean(amostra),
      dp = sd(amostra),
      min = min(amostra),
      max = max(amostra)
    )
  })

}

shinyApp(ui, server)
