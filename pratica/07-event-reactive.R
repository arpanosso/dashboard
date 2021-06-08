library(tidyverse)
library(shiny)
options(shiny.reactlog=TRUE) # roda contrl F3

ui <- fluidPage(
  "Histograma Distribuição Normal",
  sliderInput(
    inputId = "num",# passa numerico
    label = "Selecione tamanho da amostra",
    min = 1,
    max = 1000,
    value=100
  ),
  textInput(inputId = "titulo",
          label = "Título do Gráfico"),
  actionButton("atualizar", label = "Gerar gráfico"),
  plotOutput(outputId = "histograma"),
  "Tabela com Sumário",
  tableOutput("sumario")
)

server <- function(input, output, session) {
  # Botão reativo criar uma função reativa
  titulo <- eventReactive(input$atualizar,# orimeiro argumento é meu gatilho
                          ignoreNULL = FALSE, # botão zero nulo, coloca falso e ele roda de primeira
                          {
    input$titulo
  })


  output$histograma <- renderPlot({
    # amostra<-rnorm(input$num)
    # hist(amostra)
      grafico()
  })

  output$sumario <- renderTable({
    dados <- amostra() # so dentro de reativo, pq é reativo
    data.frame(
      media = mean(dados),
      dp = sd(dados),
      min = min(dados),
      max = max(dados))
  })

  # A função reactive() não imperativo, shiny é declarativo
  # diagrama de reatividade é idela pra vermos
  amostra <- reactive({
    rnorm(input$num)
  }) # data é uma função
  # browser() par achar erros
  grafico <- eventReactive(input$atualizar, {
    tibble(x=amostra()) |>
      ggplot(aes(x)) +
      geom_histogram(bins=13,color="black",fill="lightblue")+
      theme_bw() +
      labs(title = input$titulo) +
      theme(plot.title = element_text(hjust = 0.5))
  })

}

shinyApp(ui, server)



