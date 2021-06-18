library(shiny)
library(dplyr)
library(ggplot2)

ui <- navbarPage(
  title = "Pokémon",
  id = "menu",
  # tabPanel(
  #   "Água",
  #   conteudo_ui("id_agua")
  # ),
  # tabPanel(
  #   "Fogo",
  #   conteudo_ui("id_fogo")
  # ),
  # tabPanel(
  #   "Grama",
  #   conteudo_ui("id_grama")
  # )
)

server <- function(input, output, session) {

  tipos <- pokemon %>%
    pull(tipo_1) %>%
    unique()

  purrr::walk(
    tipos,
    ~ appendTab(
      "menu",
      tabPanel(
        title = stringr::str_to_title(.x),
        conteudo_ui(glue::glue("id_{.x}"))
      ),
      select = ifelse(.x == "grama", TRUE, FALSE)
    )
  )

  purrr::walk(
    tipos,
    ~ conteudo_server(glue::glue("id_{.x}"), tipo = .x)
  )

  # conteudo_server("id_agua", tipo = "água")
  # conteudo_server("id_fogo", tipo = "fogo")
  # conteudo_server("id_grama", tipo = "grama")

}

shinyApp(ui, server)
