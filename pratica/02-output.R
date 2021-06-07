# inputes https://shiny.rstudio.com/gallery/widget-gallery.html
# extras https://shiny.rstudio.com/articles/building-inputs.html
library(shiny)
library(dplyr)
# UI SO TEM HTML
ui <- fluidPage( # criando o html
  "Um hitograma", # passei função
  plotOutput("histograma") # temos que identificar o out e os input
                     # o gráfico deve ser construído dentro do servidor.
)

server <- function(input,output,session){

  # preciso de lista output
  output$histograma <- renderPlot({  # agora sempre uso a render...sempre
    mtcars |>
      filter(cyl == 4) |>
      pull(mpg) |>
      hist()


    # hist(mtcars$mpg)

  })# final do render, que joga a tag img dentro do div, então
    # liga o hmlt e R e fazer uma lista pra o HTML interpretar.
    # shinydashboared é a DLC do shiny
    # as chaves são para criar os blocos de códigos

}

shinyApp(ui,server)
