library(shiny)
library(shinydashboard)
library(ggplot2)


ui <- dashboardPage(
  header=dashboardHeader(title = "Meu App!!!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais",tabName = "info"),
      menuItem("Orçamento",tabName = "orcamentos"),
      menuItem("Receitas",tabName = "receitas")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow(
          column(
            width = 12,
            h1("Informações gerais dos filmes")
          )
        ), ## SEPRAÇÂO DE ELEMNTOS
        hr(style = "border-top: 1px solid black;"), # tag horizontal row style para mudar o css
        br(), # tag para puar uma linha, break
        fluidRow(
          infoBoxOutput("num_filmes"),
          infoBoxOutput("num_diretores"),
          valueBoxOutput("num_atores"),
        )
      ),
      tabItem(
        tabName = "orcamentos",
        fluidRow(
          column(
            width = 12,
            h1('Analisando as receitas'),
          )
        ),
        br(),
        fluidRow(
          box(
            width = 12,
            selectInput(
              inputId = "orcamento_genero",
              label = "Esoclha o gênero",
              choices = c("Action","Comedy",'Romance'),
              width = "25%" # coupa um quarto do que tem em disposição
            )
          )
        ),
        fluidRow(
          box(
            width = 4,
            title = "Série do Orçamento",
            solidHeader = TRUE, #cabeçalho colorido
            status = "primary",  # para mudar a cor igual do anterior
            plotOutput("serie_orcamento")
          )
        )
      ),
      tabItem(
        tabName = "receitas",

        )
    )
  ),
  title = "Meu App"
)


server <- function(input, output, session) {
  imdb <- readr::read_rds("../dados/imdb.rds")

  output$num_filmes <- renderInfoBox({
    n_linhas <- nrow(imdb)
    infoBox(
      title = "Número de filmes",
      subtitle = "teste de sub",
      value = n_linhas,
      icon = icon("film"),
      fill = TRUE,
      color="purple", # validColors {shinydashboard} algumas válidas na documentação
      width = 4 # já é padrão, não precisa de column
    )
  })


  output$num_diretores <- renderInfoBox({
    num_diretores <- imdb |>
      dplyr::pull(diretor) |>
      dplyr::n_distinct()

    infoBox(
      title = "Número de Diretores e Diretoras",
      value = num_diretores,
      icon = icon("film"),
      fill = TRUE,
      color="purple", # validColors {shinydashboard} algumas válidas na documentação
      width = 4 # já é padrão, não precisa de column
    )
  })

  output$num_atores <- renderValueBox({
    num_atores <- imdb |>
      dplyr::select(dplyr::starts_with("ator")) |>
      tidyr::pivot_longer(
        cols = dplyr::starts_with("ator"),
        values_to = "nome",
        names_to = "posicao"
      ) |>
      dplyr::distinct(nome) |>
      nrow()

    valueBox(
      subtitle = "Número de atores e atrizes",
      value = num_atores,
      icon = icon("users"),
      color="purple" # validColors {shinydashboard} algumas válidas na documentação
    )
  })

  output$serie_orcamento <- renderPlot({
    imdb |>
      dplyr::filter(stringr::str_detect(generos,input$orcamento_genero)) |>
      dplyr::group_by(ano) |>
      dplyr::summarise(orcamento_medio = mean(orcamento,na.rm=TRUE)) |>
      ggplot(aes(x=ano,y=orcamento_medio)) +
        geom_line()



  })


}

shinyApp(ui, server)
