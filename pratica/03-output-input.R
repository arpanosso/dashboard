# escrever shinyapp e apertar TAB
library(shiny)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  "Vários histogramas",
  selectInput(  # cada input tem diferentes parâmetros, label e a opções
    inputId = "variavel",
    label = "Selecione a variável",
    choices = names(mtcars)
              ),
  plotOutput("histograma")


)

server <- function(input, output, session) {
  output$histograma <- renderPlot({

    # hist(mtcars[[input$variavel]],
    #      main=input$variavel,las=1,
    #      xlab=input$variavel) # técnica do R base
    # box()

    mtcars |>
      ggplot(aes_string(x=input$variavel))+
      geom_histogram(bins=15,color="black",fill="lightblue")

  })


}

shinyApp(ui, server)
