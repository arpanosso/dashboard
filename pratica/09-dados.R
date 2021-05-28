library(shiny)
library(dplyr)
library(readr)

ui <- fluidPage(
  sliderInput(
    inputId = "periodo",
    label = "Selecione intervalo de anos",
    min = 1916,
    max=2016,
    value=c(2000,2010),
    step = 1,sep=""
  ),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {
  imdb <- read_rds("../dados/imdb.rds")

  output$tabela <- renderTable({
    imdb |>
      filter(ano %in% input$periodo[1]:input$periodo[2]) |>
      select(titulo, ano, diretor, receita, orcamento,nota_imdb) |>
      mutate(lucro= receita - orcamento) |>
      top_n(20, lucro) |>
      arrange(desc(lucro)) |>
      mutate_at(vars(lucro,receita,orcamento), ~scales::dollar(.x))
  })

}

shinyApp(ui, server)
