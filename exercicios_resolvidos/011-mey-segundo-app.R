# Meu segundo shiny app (agora importando uma base de dados)
#
# Escolha uma das bases da pasta dados ou use uma base própria.
#
# - Crie um shiny app com pelo menos um input e um output
# para visualizarmos alguma informação interessante da base.
#
# - Suba o app para o shinyapps.io.



library(shiny)
library(dplyr)
imdb <- readr::read_rds("dados/imdb.rds" )

ui <- fluidPage(
  "Base - IMDB",
  selectInput(
    inputId = "Coluna",
    label = "Selecione a variável",
    choices = names(imdb)
  ),
  plotOutput("histograma")
)

server <- function(input, output, session) {


}

shinyApp(ui, server)
