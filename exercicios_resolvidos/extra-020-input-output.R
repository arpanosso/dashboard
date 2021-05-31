# Boxplots da base diamonds
#
# Faça um shiny app para visualizarmos boxplots da base diamonds.
#
# O seu app deve ter dois inputs e um output:
#
#   1. o primeiro input deve ser uma caixa de seleção das variáveis
#     numéricas da base (será o eixo y do gráfico).
#
#   2. o segundo input deve ser uma caixa de seleção das variáveis
#    categóricas da base (será o eixo x do gráfico).
#
#   3. o output deve ser um gráfico com os boxplots da variável
#    escolhida em (1) para cada categoria da variável escolhida em (2).
#
# Para acessar a base diamonds, carrrege o pacote ggplot2
#

library(ggplot2)
library(tidyverse)


ui <- fluidPage(
  "Base ggplot2::diamonds",
  selectInput(
    inputId = "var_x",
    label = "Selecione a variável numérica",
    choices = diamonds |>
      select(where(is.numeric)) |>
      names()
  ),
  selectInput(
    inputId = "var_y",
    label = "Selecione a variável categórica",
    choices = diamonds |>
      select(!where(is.numeric)) |>
      names()
  ),
  plotOutput("boxplot")
)

server <- function(input, output, session) {
  output$boxplot <- renderPlot({

    diamonds |>
      ggplot(aes_string(y=input$var_x,fill=input$var_y)) +
      geom_boxplot()+
      theme_bw()

  })
}

shinyApp(ui, server)



