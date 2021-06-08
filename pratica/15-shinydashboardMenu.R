library(shiny)
library(shinydashboard)
# https://fontawesome.com/


##shiny::includeMarkdown("caminho do arquivo") # COPIA EM HTML DENTRO DO MARCKDONW

ui <- dashboardPage(
  header=dashboardHeader(
    title = "Meu App!!!"
  ),
  sidebar=dashboardSidebar(
    sidebarMenu(
      menuItem("Infromações Gerais",tabName = "info",icon = icon("twitter-square")),
      menuItem("Orçamentos",tabName = "orcamentos",icon = icon("dollar-sign")),
      menuItem("Receitas",
               menuItem("visão 01",tabName = "visao_1"),
               menuItem("visão 02",tabName = "visao_2",
                        menuSubItem("Visao 02",tabName = "vis22"),
                        menuSubItem("Visao 02",tabName = "vis22")))
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
      ),
      tabItem(
        tabName = "visao_1",
        h1("visão 01")
      ),
      tabItem(
        tabName = "visao_2",
        h1("visão 02")
      )
    )
  ),
  title = "Meu App"
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
