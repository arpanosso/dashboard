library(shiny)

ui <- fluidPage(
  "Histograma da distribuição normal",
  sliderInput(
    inputId = "num",
    label = "Selecione o tamanho da amostra",
    min = 1,
    max = 1000,
    value = 100,
  ),
  textInput(inputId = "titulo", label = "Título do gráfico"),
  actionButton("atualizar", "Gerar gráfico"),
  plotOutput(outputId = "hist"),
  "Tabela com sumário",
  tableOutput(outputId = "sumario")
)

server <- function(input, output, session) {

  dados <- readr::read_rds("../dados/cetesb.rds")

  amostra <- reactive({
    rnorm(input$num)
  })

  titulo <- eventReactive(input$atualizar, ignoreNULL = FALSE, {
    input$titulo
  })

  output$hist <- renderPlot({
    hist(amostra(), main = titulo())
  })

  output$sumario <- renderTable({
    data.frame(
      media = mean(amostra()),
      dp = sd(amostra()),
      min = min(amostra()),
      max = max(amostra())
    )
  })

}

shinyApp(ui, server)
