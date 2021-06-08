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
<<<<<<< HEAD

readr::read_rds("dados/imdb.rds")
=======
library(readr)


dados <- readRDS("../dados/imdb.rds")
>>>>>>> 63c4975928a8b3376f369e7e7eb00e22ad78c6ce

ui <- fluidPage(
  "Base - IMDB",
  selectInput(
<<<<<<< HEAD
    inputId = "Coluna",
    label = "Selecione a variável",
    choices = readr::read_rds("dados/imdb.rds") |>
=======
    inputId = "var_string",
    label = "Selecione a variável fator",
    choices = dados |>
      select(-where(is.numeric)) |>
>>>>>>> 63c4975928a8b3376f369e7e7eb00e22ad78c6ce
      names()
  ),
  selectInput(
    inputId = "var_numerica",
    label = "Selecione a variável numérica",
    choices = dados |>
      select(where(is.numeric)) |>
      names()
  ),
  tableOutput("tabela")
)

server <- function(input, output, session) {
  output$tabela <- renderTable({
    dados |>
       arrange(desc(input$var_string)) |>
       select(input$var_string,input$var_numerica) |>
       head(20)
  })
}

shinyApp(ui, server)
