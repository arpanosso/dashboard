library(shiny)

ui <- fluidPage(
  sliderInput(
    inputId = "ano",
    label = "selecione ano",
    min = 1916, max = 2016, value = 2000,
    sep=""
  ),
  selectInput(
    inputId = "filmes",
    label = "selecione um filme",
    choices = ""
  )
)

server <- function(input, output, session) {
  imdb <- readr::read_rds("imdb.rds")

  observe({

    filmes <- imdb |> filter(
      ano == input$ano
    ) |> pull(titulo)

    updateSelectInput(
      session,
      inputId = "filmes",
      choices = filmes
    )
  })
}

shinyApp(ui, server)
