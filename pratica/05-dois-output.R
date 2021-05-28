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
  plotOutput(outputId = "histograma"),
  "Tabela com Sumário",
  tableOutput("sumario")

)

server <- function(input, output, session) {
  # A função reactive()
  data <- reactive({
    rnorm(input$num)
  }) # data é uma função


  output$histograma <- renderPlot({
    # amostra<-rnorm(input$num)
    # hist(amostra)
    tibble(x=data()) |>
      ggplot(aes(x)) +
      geom_histogram(bins=13,color="black",fill="lightblue")+
      theme_bw() +
      labs(title = input$titulo) +
      theme(plot.title = element_text(hjust = 0.5))
  })

  output$sumario <- renderTable({
    amostra <-data()
    data.frame(
      media = mean(amostra),
      dp = sd(amostra),
      min = min(amostra),
      max = max(amostra))
  })



}

shinyApp(ui, server)
