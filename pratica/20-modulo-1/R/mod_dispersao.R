dispersao_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 6,
        selectInput(
          inputId = ns("variavel_x"),
          label = "Selecione uma variável",
          choices = names(mtcars)
        ),
      ),
      column(
        width = 6,
        selectInput(
          inputId = ns("variavel_y"),
          label = "Selecione uma variável",
          choices = names(mtcars)
        ),
      ),
    ),
    fluidRow(
      column(
        width = 12,
        plotOutput(ns("grafico"))
      )
    )
  )
}

dispersao_server <- function(id){
  moduleServer(id, function(input, output, session){
    output$grafico <- renderPlot({
      plot(mtcars[[input$variavel_x]],mtcars[[input$variavel_y]])
    })
  })
}
