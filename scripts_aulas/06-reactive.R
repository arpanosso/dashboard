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

  amostra <- reactive({
    rnorm(input$num)
  })

  output$histograma <- renderPlot({
    hist(amostra(), main = input$titulo)
  })

  output$sumario <- renderTable({
    dados <- amostra()
    data.frame(
      media = mean(dados),
      dp = sd(dados),
      min = min(dados),
      max = max(dados)
    )
  })


}

shinyApp(ui, server)
