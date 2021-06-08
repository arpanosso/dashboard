# Gráfico de dispersão da base mtcars
#
# Faça um Shiny app para mostrar um gráfico de dispersão (pontos)
# das variáveis da base mtcars.
#
# O seu app deve:
#
#   - Ter dois inputs: a variável a ser colocada no eixo e a variável
#     a ser colocada no eixo y
#
#   - Um output: um gráfico de dispersão

library(shiny)
library(tidyverse)


ui <- fluidPage(
  "Base mtcars",
  selectInput(
    inputId = "var_x",
    label = "Selecione a variável para o eixo x",
    choices = mtcars |>
      select(where(is.numeric)) |>
      names()
  ),
  selectInput(
    inputId = "var_y",
    label = "Selecione a variável para o eixo y",
    choices = mtcars |>
      select(where(is.numeric)) |>
      names()
  ),
  plotOutput("dispersao")
)

server <- function(input, output, session) {
  output$dispersao <- renderPlot({

    mtcars |>
      ggplot(aes_string(x=input$var_x,y=input$var_y)) +
      geom_point()+
      theme_bw()

  })
}

shinyApp(ui, server)



