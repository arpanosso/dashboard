library(shiny)
ui <- fluidPage(
  h1("Treinando a construção de módulos"),
  br(),
  fluidRow(
    column(
      width = 6,
      histograma_ui("hist")
    ),
    column(
      width = 6,
      dispersao_ui("disp")
    )
  )
)
server <- function(input, output, session) {
  histograma_server("hist")
  dispersao_server("disp")
}
shinyApp(ui, server)
