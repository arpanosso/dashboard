library(shiny)
library(tidyverse)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  tabPanel(
    title = "Análise Descritiva",
    fluidRow(
      column(
        width = 3,
        selectInput(
          inputId = "variavel",
          label = "Selecione uma variável",
          choices = names(mtcars[,-1])
        )
      ),
      column(
        width = 9,
        plotOutput("grafico_disp")
      )
    ),
  ),
  navbarMenu(
    title= "resultados do modelo",
    tabPanel(
      title="Regressão Linear",
      "resultados da minha regressão linear",
      plotOutput("grafico_barras")
    ),
    tabPanel(
      title="Árvores de Decisão",
      "resultados da minha árvores"
    ),
    tabPanel(
      title="XGboost",
      "resultados da minha modela xgboost"
    )
  ),
  tabPanel(title = "Página 2")

)

server <- function(input, output, session) {
  output$grafico_disp <- renderPlot({
    mtcars |>
      ggplot(aes(x = .data[[input$variavel]],y=mpg)) +
      geom_point()
  })

  output$grafico_barras <- renderPlot({
    mtcars |>
      ggplot(aes(x = .data[[input$variavel]])) +
      geom_bar()
  })
}

shinyApp(ui, server)
