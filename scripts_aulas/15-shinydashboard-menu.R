library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  header = dashboardHeader(
    title = "Meu app!!!"
  ),
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamentos", icon = icon("dollar-sign")),
      menuItem(
        "Receitas",
        menuItem(
          "Visão geral",
          menuSubItem("visão geral 1", tabName = "visao_geral_1"),
          menuSubItem("visão geral 1", tabName = "visao_geral_2")
        ),
        menuSubItem("Por direção", tabName = "receita_por_direcao"),
        menuSubItem("Por período", tabName = "receita_por_periodo")
      )
    )
  ),
  body = dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow(
          column(
            width = 12,
            h1("Informações gerais dos filmes"),
            selectInput("variavel", label = "Selecione variável", choices = names(mtcars))
          )
        )
      ),
      tabItem(
        tabName = "orcamentos",
        h1("Analisando os orçamentos")
      ),
      tabItem(
        tabName = "receita_visao_geral",
        h1("Receitas - Visão geral")
      ),
      tabItem(
        tabName = "receita_por_direcao",
        h1("Receitas - Por direção")
      ),
      tabItem(
        tabName = "receita_por_periodo",
        h1("Receitas - Por período")
      )
    )
  ),
  title = "Meu app"
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
