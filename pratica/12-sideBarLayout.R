library(shiny)

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout( # aqui dentro tem sempre dois
    position = "left",#"right",
    sidebarPanel=sidebarPanel( # primeira
      width = 3, #padrão ´4 já é coluna por trás não precisa criar colunas
      sliderInput(
        "num",
        "Número de observações:",
        min = 0,
        max = 1000,
        value = 500
      )
    ),
    mainPanel=mainPanel( # segunda, geralmente a saída
      width = 9, #padrão ´8 já é coluna por trás
      plotOutput("hist")
    )
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    amostra <- rnorm(input$num)
    hist(amostra)
  })
}

shinyApp(ui, server)
