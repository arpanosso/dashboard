library(shiny)
library(magrittr)

ui <- fluidPage(
  selectInput(
    "variavel",
    label = "selecione uma variavel",
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
    content = function(file) {
      # rmarkdown::render(input = "template.Rmd",
      #                   output_file = file,
      #                   params = list(cidade = input$cidade))
      mtcars %>%
        dplyr::select(input$variavel) %>%
        write.csv(file)
    }
  )

}

shinyApp(ui, server)
