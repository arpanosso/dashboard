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
  actionButton(inputId = "atualizar_grafico", label = "Gerar gráfico"),
  plotOutput(outputId = "histograma"),
  "Tabela com sumário",
  tableOutput("sumario")
)

server <- function(input, output, session) {

  amostra <- reactive({
    rnorm(input$num)
  })

  grafico <- eventReactive(input$atualizar_grafico, {
    histt(amostra(), main = input$titulo)
  })

  output$histograma <- renderPlot({
    grafico()
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
