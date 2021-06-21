library(shiny)
library(tidyverse)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  tabPanel(
    title = "Análise descritiva",
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
    )
  ),
  navbarMenu(
    title = "Resultado dos modelos",
    tabPanel(
      title = "Regressão Linear",
      "Resultados da minha regressão linear",
      plotOutput("grafico_barras")
    ),
    tabPanel(
      title = "Árvores de decisão",
      "Resultados das árvores de decisão"
    ),
    tabPanel(
      title = "XGBoost",
      "Resultados do meu xgboost"
    )
  )
)

server <- function(input, output, session) {

  output$grafico_disp <- renderPlot({
    mtcars %>%
      ggplot(aes(x = .data[[input$variavel]], y = mpg)) +
      geom_point()
  })

  output$grafico_barras <- renderPlot({
    mtcars %>%
      ggplot(aes(x = .data[[input$variavel]])) +
      geom_bar()
  })

}

shinyApp(ui, server)
