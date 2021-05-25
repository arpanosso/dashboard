# Meu primeiro shiny app
#
# Faça um shiny app para visualizar histogramas da base diamonds
# e o coloque no shinyapps.io.
#
# Seu shiny deve ter um input e um output.
#
# - Input: variáveis numéricas da base diamonds.
# - Output: histograma da variável selecionada.
#
# Para acessar a base diamonds, carrege o pacote ggplot2
#
# library(ggplot2)
#
# ou rode
#
# ggplot2::diamonds

library(shiny)
library(dplyr)


## Minha UI
ui <- fluidPage(
  "Histograma - Base {ggplot2::diamonds}",
  selectInput(
    inputId = "variavel",
    label = "Selecione a variável",
    choices = ggplot2::diamonds |>
      select(where(is.numeric)) |>
      names()
  ),
  plotOutput("histograma")
)

#Função Server
server <- function(input, output, session) {
  output$histograma <- renderPlot({
    ggplot2::diamonds |>
      ggplot2::ggplot(ggplot2::aes_string(x=input$variavel)) +
      ggplot2::geom_histogram(bins=10,
                              color="black",
                              fill="lightblue")+
      ggplot2::theme_bw()
  })
}

#
shinyApp(ui, server)



# https://arpanosso.shinyapps.io/exercicios_resolvidos/

