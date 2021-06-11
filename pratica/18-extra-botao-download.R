library(shiny)

ui <- fluidPage(
  selectInput(
    "variavel",
    label = "selecione uma variável",
    choices = names(mtcars)
  ),
  downloadButton(
    outputId = "download",
    label = "Download da base mtcars"
  )
)

server <- function(input, output, session) {

  output$download <- downloadHandler(
    filename = "mtcars.csv",
    content = function(file){
      # rmarkdown::rende(input = "template.rmd",
      #                  output_file = file,
      #                  params = list(cidade = input$cidade))

      mtcars |>
        dplyr::select(input$variavel) |>
        write.csv(file)

    }
  )
}

shinyApp(ui, server)
