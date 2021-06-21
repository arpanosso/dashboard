library(shiny)

googlesheets4::gs4_auth(
  email = "wamorim@curso-r.com",
  cache = "../.secrets"
)

ui <- fluidPage(
  selectInput(
    inputId = "variavel",
    label = "escolha a variável",
    choices = "mpg"
  ),
  shinyWidgets::addSpinner(plotOutput("grafico"))
  # shinycssloaders::withSpinner(
  #   plotOutput("grafico"),
  #   type = 8
  # )
)

server <- function(input, output, session) {

  dados <- googlesheets4::read_sheet(
    "1xy8ItoAIr1M6P-MG_Nzg91yGPd7XT1_pKmsbIGmfC-s"
  )

  output$grafico <- renderPlot({
    hist(dados[[input$variavel]])
  })
}

shinyApp(ui, server)
