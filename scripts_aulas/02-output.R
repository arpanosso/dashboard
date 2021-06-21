library(shiny)
library(dplyr)

ui <- fluidPage(
  "Um histograma",
  plotOutput("histograma")
)

server <- function(input, output, session) {

  output$histograma <- renderPlot({
    mtcars %>%
      filter(cyl == 4) %>%
      pull(mpg) %>%
      hist()
  })

}

shinyApp(ui, server)
