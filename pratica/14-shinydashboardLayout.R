library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  header=dashboardHeader(
    title = "Meu App!!!"
  ),
  sidebar=dashboardSidebar(
    sidebarMenu(
      menuItem("Item 1",tabName = "item1"),
      menuItem("Item 2",tabName = "item2")
    )
  ),
  body=dashboardBody(
    tabItems(
      tabItem(),
      tabItem()
    )
  ),
  title = "Meu App"
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
