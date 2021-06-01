library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  header=dashboardHeader(
    title = "Meu App!!!"
  ),
  sidebar=dashboardSidebar(
    sidebarMenu(
      menuItem("Infromações Gerais",tabName = "info"),
      menuItem("Orçamentos",tabName = "orcamentos")
    )
  ),
  body=dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow( # sempre usar com Colum, para não dar toque
          column(
            width = 12,
            h1("Informação gerais dos filmes"),
            selectInput("variavel",label = "selecione variável",choices = names(mtcars[,-1]))
          )
        )
      ),
      tabItem(
        tabName = "orcamentos",
        h1("Analisando os orçamentos")
      )
    )
  ),
  title = "Meu App"
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
