library(shiny)
library(shinydashboard)
library(ggplot2)

imdb <- readr::read_rds("../dados/imdb.rds")

ui <- dashboardPage(
  header=dashboardHeader(title = "Meu App!!!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais",tabName = "info"),
      menuItem("Orçamento",tabName = "orcamentos"),
      menuItem("Filmes",tabName = "filmes")
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
              label = "Escolha o gênero",
              choices = "Carregando..",
              width = "25%" #, # coupa um quarto do que tem em disposição
              #selected = "Comedy"
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
        tabName = "filmes",
        fluidRow(
          column(
            width = 12,
            h1("informações de cada filme")
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
                  label = "Selecione os diretores",
                  choices = sort(unique(imdb$diretor)),
                  selected = "Quantin Tarantino"
                )
              ),
              column(
                width = 8,
                selectInput(
                  inputId = "filmes_diretor",
                  label = "selecione um filme",
                  choices = "Carregando..."
                )
              )
            ),
            fluidRow(
              valueBoxOutput("vb_orcamento",width = 6),
              valueBoxOutput("vb_receita",width = 6)

            )
          )
        )
      )
    )
  ),
  title = "Meu App"
)


server <- function(input, output, session) {
  imdb <- readr::read_rds("../dados/imdb.rds")

  # pagina 01

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

  # página 2


  # output$ui_generos <- renderUI({
  #   generos <- imdb |>
  #     pull(generos) |>
  #     paste(collapse = "|") |>
  #     stringr::str_split("\\|") |>
  #     purrr::flatten_chr() |>
  #     unique()
  #
  #   selectInput(
  #     inputId = "orcamento_genero",
  #     label = "Escolha o gênero",
  #     choices = generos,
  #     width = "25%" #, # coupa um quarto do que tem em disposição
  #     #selected = "Comedy"
  #   )
  # })

  #observe não cria a função igual a reactive
  # ele faz um efeito colateral
  # observeEvent(input$botao,{})
  observe({ # so roda na inicializaçlão e unuca mais, pois naõ tem valor
    # Sys.sleep(3) # para a sessão por 3 segundos

      generos <- imdb |>
        pull(generos) |>
        paste(collapse = "|") |>
        stringr::str_split("\\|") |>
        purrr::flatten_chr() |>
        unique()

    updateSelectInput( # SEMPRE NO observeou ObserveEvent
      session, # sempre como primeiro argumento
      "orcamento_genero",
      choices = generos
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
  # estrutra de reatividade é escrita em JS, e as
  # char de reatividade são reproduzida no servidor

    # pagina 3

  observe({

    filmes <- imdb |>
      filter(diretor == input$diretor) |>
      pull(titulo)

    updateSelectInput(
      session,
      "filmes_diretor",
      choices = filmes
    )
  })

  output$vb_orcamento <- renderValueBox({
    valor <- imdb |>
      filter(titulo == input$filmes_diretor) |>
      pull(orcamento) |>
      scales::dollar()
    valueBox(
      value = valor,
      subtitle =  "orcamento em dolar",
    )
  })

  output$vb_receita <- renderValueBox({
    valor <- imdb |>
      filter(titulo == input$filmes_diretor) |>
      pull(receita) |>
      scales::dollar()
    valueBox(
      value = valor,
      subtitle =  "receita em dolar"
    )
  })

  }

shinyApp(ui, server)
