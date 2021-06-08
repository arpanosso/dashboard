library(shiny)
library(shinydashboard)
# https://fontawesome.com/


##shiny::includeMarkdown("caminho do arquivo") # COPIA EM HTML DENTRO DO MARCKDONW

ui <- dashboardPage(
  header=dashboardHeader( # ARG1
    title = "Meu App!!!"
  ),
  sidebar=dashboardSidebar( # ARG2
    sidebarMenu(
      menuItem("Infromações Gerais",tabName = "info",icon = icon("twitter-square")),
      menuItem("Orçamentos",tabName = "orcamentos",icon = icon("dollar-sign")),
      menuItem(
        "Receitas",
         menuItem("Visão geral",
                  menuSubItem("visão geral 1", tabName = "visao_1"),
                  menuSubItem("visão geral 2",tabName = "visao_2")
                  ),
         menuSubItem("Por diretor",tabName = "por_diretor_receitas"),
         menuSubItem("Por Periodo",tabName = "por_periodo_receitas")
      )
    )
  ),
  body=dashboardBody( # ARG3
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow( # sempre usar com Colum, para não dar toque
          column(
            width = 12,
            h1("Informação gerais dos filmes"),
            selectInput("variavel",label = "selecione variável",choices = names(mtcars))
          )
        )
      ),
      tabItem(
        tabName = "orcamentos",
        h1("Analisando os orçamentos")
      ),
      tabItem(
        tabName = "visao_geral_receitas",
        h1("Receita - Visão Geral")
      ),
      tabItem(
        tabName = "por_diretor_receitas",
        h1("Receita - Por diretor")
      ),
      tabItem(
        tabName = "por_periodo_receitas",
        h1("Receita - Por Período")
      )
    )
  ),
  title = "Meu App" # ARG4
)


server <- function(input, output, session) {

}

shinyApp(ui, server)
