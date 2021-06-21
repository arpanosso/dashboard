library(magrittr)
library(ggplot2)
library(dplyr)
library(shiny)
library(shinydashboard)

imdb <- readr::read_rds("../dados/imdb.rds")

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Orçamentos", tabName = "orcamentos"),
      menuItem("Filmes", tabName = "filmes")
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
        ),
        # hr(style = "border-top: 1px solid black;"),
        br(),
        fluidRow(
          infoBoxOutput("num_filmes"),
          infoBoxOutput("num_dir"),
          valueBoxOutput("num_at")
        )
      ),
      tabItem(
        tabName = "orcamentos",
        fluidRow(
          column(
            width = 12,
            h1("Analisando os orçamentos"),
          )
        ),
        br(),
        fluidRow(
          box(
            width = 12,
            uiOutput("ui_generos")
            # selectInput(
            #   inputId = "orcamento_genero",
            #   label = "Escolha um gênero",
            #   choices = "Carregando...",
            #   width = "25%"
            # )
          )
        ),
        fluidRow(box(
          width = 6,
          title = "Série do orçamento",
          solidHeader = TRUE,
          status = "primary",
          plotOutput("serie_orcamento", height = "200px")
        ))
      ),
      tabItem(
        tabName = "filmes",
        fluidRow(
          column(
            width = 12,
            h1("Informações de cada filme"),
          )
        ),
        br(),
        fluidRow(
          box(
            width = 12,
            fluidRow(
              column(
                width = 4,
                selectInput(
                  inputId = "diretor",
                  label = "Selecione um diretor",
                  choices = sort(unique(imdb$diretor)),
                  selected = "Quentin Tarantino"
                )
              ),
              column(
                width = 8,
                selectInput(
                  inputId = "filmes_diretor",
                  label = "Selecione um filme",
                  choices = "Carregando..."
                )
              )
            ),
            fluidRow(
              valueBoxOutput("vb_orcamento", width = 6),
              valueBoxOutput("vb_receita", width = 6)
            )
          )
        )

      )
    )
  )
)

server <- function(input, output, session) {

  # pagina 1

  output$num_filmes <- renderInfoBox({
    num_linhas <- nrow(imdb)
    infoBox(
      title = "Número de filmes",
      value = num_linhas,
      icon = icon("film"),
      fill = TRUE,
      color = "purple"
    )
  })

  output$num_dir <- renderInfoBox({
    num_diretores <- dplyr::n_distinct(imdb$diretor)
    infoBox(
      title = "Número de diretores/diretoras",
      value = num_diretores,
      icon = icon("film"),
      fill = TRUE,
      color = "purple"
    )
  })

  output$num_at <- renderValueBox({
    num_atores_atrizes <- imdb %>%
      dplyr::select(dplyr::starts_with("ator")) %>%
      tidyr::pivot_longer(
        cols = dplyr::starts_with("ator"),
        values_to = "nome",
        names_to = "posicao"
      ) %>%
      dplyr::distinct(nome) %>%
      nrow()
    valueBox(
      subtitle = "Número de atores/atrizes",
      value = num_atores_atrizes,
      icon = icon("users"),
      color = "purple"
    )
  })

  # pagina 2

  output$ui_generos <- renderUI({

    generos <- imdb %>%
      pull(generos) %>%
      paste(collapse = "|") %>%
      stringr::str_split(pattern = "\\|") %>%
      purrr::flatten_chr() %>%
      unique()

    selectInput(
      inputId = "orcamento_genero",
      label = "Escolha um gênero",
      choices = generos,
      width = "25%",
      selected = "Comedy"
    )
  })

  # observe({
  #
  #   generos <- imdb %>%
  #     pull(generos) %>%
  #     paste(collapse = "|") %>%
  #     stringr::str_split(pattern = "\\|") %>%
  #     purrr::flatten_chr() %>%
  #     unique()
  #
  #
  #   updateSelectInput(
  #     session,
  #     "orcamento_genero",
  #     choices = generos
  #   )
  # })


  output$serie_orcamento <- renderPlot({
    req(input$orcamento_genero)
    # validate(need(
    #   isTruthy(input$orcamento_genero),
    #   "O app ainda está carregando..."
    # ))
    imdb %>%
      dplyr::filter(stringr::str_detect(generos, input$orcamento_genero)) %>%
      dplyr::group_by(ano) %>%
      dplyr::summarise(orcamento_medio = mean(orcamento, na.rm = TRUE)) %>%
      ggplot(aes(x = ano, y = orcamento_medio)) +
      geom_line()
  })

  # Página 3

  observe({

    filmes <- imdb %>%
      filter(diretor == input$diretor) %>%
      pull(titulo)

    updateSelectInput(
      session,
      "filmes_diretor",
      choices = filmes
    )
  })

  output$vb_orcamento <- renderValueBox({
    valor <- imdb %>%
      filter(titulo == input$filmes_diretor) %>%
      pull(orcamento)  %>%
      scales::dollar()
    valueBox(
      value = valor,
      subtitle = "orcamento em dolares"
    )
  })

  output$vb_receita <- renderValueBox({
    valor <- imdb %>%
      filter(titulo == input$filmes_diretor) %>%
      pull(receita) %>%
      scales::dollar()
    valueBox(
      value = valor,
      subtitle = "receita em dolares"
    )
  })

}

shinyApp(ui, server)
