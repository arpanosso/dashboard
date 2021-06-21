library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  header = dashboardHeader(
    title = "Meu app!!!"
  ),
  sidebar = dashboardSidebar(),
  body = dashboardBody(),
  title = "outro titulo"
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
