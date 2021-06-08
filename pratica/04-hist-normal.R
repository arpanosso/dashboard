library(tidyverse)
library(shiny)
options(shiny.reactlog=TRUE)


ui <- fluidPage(
  "Histograma Distribuição Normal",
  sliderInput(
    inputId = "num",# passa numerico
    label = "Selecione tamanho da amostra",
    min = 1,
    max = 1000,
    value=100
    ),
  plotOutput(outputId = "histograma")

)

server <- function(input, output, session) {
  output$histograma <- renderPlot({
     amostra<-rnorm(input$num)
     hist(amostra)
     tibble(x=rnorm(input$num)) |>
       ggplot(aes(x)) +
       geom_histogram(color="black",fill="lightblue")+
       theme_bw()

# TENTAR COLOCAR O GGPLOT
# valores reativos, tudo que muda vindo da UI, apessoa muda slider e o valores
# muda conforme açaõ da UI
# Funcoes reativas recebem valores reativos, pois valor reativo so usa em
     # funços reativas, pois elas foram preparadas para receber os reativos
     # isso indica que por elas serem reativas isso significa que shiny vai
     # olohar e recalcularas funçeos sempre que algo no app reativos for mu
     # dado.

  })
}

shinyApp(ui, server)
