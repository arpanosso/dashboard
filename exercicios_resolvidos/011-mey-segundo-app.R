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
library(readr)
library(DT)

dados <- readRDS("c:\\github\\dashboard\\dados\\imdb.rds")

ui <- fluidPage(
  "Base - IMDB",
  selectInput(
    inputId = "var_string",
    label = "Selecione a variável fator",
    choices = dados |>
      select(-where(is.numeric)) |>
      names()
  ),
  selectInput(
    inputId = "var_numerica",
    label = "Selecione a variável numérica",
    choices = dados |>
      select(where(is.numeric)) |>
      names()
  ),
  dataTableOutput("tabela")
)

server <- function(input, output, session) {
  output$tabela <- renderDataTable({
     # tab<-dados |>
     #  arrange(desc(input$var_string)) |>
     #  select(input$var_string,input$var_numerica) |>
     #  head(20)
    datatable(dados)
  })
}

shinyApp(ui, server)
