library(shiny)
library(readr)
library(dplyr)

imdb <- read_rds("../dados/imdb.rds") %>%
  filter(ano > 1950)

ui <- fluidPage(
  sliderInput(
    inputId = "periodo",
    label = "Selecione o intervalo de anos",
    min = min(imdb$ano, na.rm = TRUE),
    max = max(imdb$ano, na.rm = TRUE),
    value = c(2000, 2010),
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "tabela")
)

server <- function(input, output, session) {

  output$tabela <- renderTable({
    imdb %>%
      filter(ano %in% input$periodo[1]:input$periodo[2]) %>%
      select(titulo, ano, diretor, receita, orcamento) %>%
      mutate(lucro = receita - orcamento) %>%
      top_n(20, lucro) %>%
      arrange(desc(lucro)) %>%
      mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  })

}

shinyApp(ui, server)
