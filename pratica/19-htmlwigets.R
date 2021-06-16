library(htmlwidgets)
library(plotly)
library(leaflet)
library(reactable)
library(shiny)
library(shinydashboard)
library(tidyverse)
# Solução para cnoexão entre R e JS, que é mais utilizada na internet
# é um pacote motor de todos os pacotes de conexão com R e JS
# ele trouxe uma explosaõ de iniciativas no R, pois podemso ficar
# tranquilos qunt a impelemntaçao de novas bibliotecas, que deve
# estar sendo implementada em R, uma comuidade ativa muito grande, que
# se traduz no R.

# https://www.htmlwidgets.org/
# desenvolvido atualemnte pelo time da RStudio
# http://gallery.htmlwidgets.org/ é  o cara

# sempre teremos funções output e render


#########################
# REACTABLE
#########################

# htmlwidget pode ser usado em markdow ou em boock down, pois ele é
# feito para rodar em html
# https://glin.github.io/reactable/articles/shiny-demo.html
#############################################
# https://glin.github.io/reactable/ #########
#############################################

#########################
# PLOTELY
#########################
# disponibiliza pactoes para acessar o motor de criar gráficos
# em JS, R e py, para gerar os mesmo gráficos
# tutoriais extremamente extensivos
# https://plotly.com/r/
# Pílula Azul
# p <- mtcars |>
#   ggplot(aes(x=mpg, y=disp)) +
#   geom_point()+theme_bw()
# p
#
# ggplotly(p)


# Pilula vermelha cria na mão
# plot_ly # sem o overhead do ggplot


#########################
# LEAFLET
#########################
# faz camada, primeiro colocar as tiles
# e depois as camadas de dados com marcadores bolinhas, shapes, por
# exemplo, no curso de visualização tem
#

# leaflet(height = 300) |>
#   addTiles() |>
#   addMarkers(
#     lng=-46.6623969, lat= -23.5583664,
#     popup = "Curo R mora aqui"
#   )


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações Gerais",tabName = "info"),
      menuItem("Bilheteria",tabName = "bilheteria"),
      menuItem("Filmes",tabName = "filmes")
    )
  ),
  dashboardBody(
    tabItems(
      # tab 1
      tabItem(
        "info",
        h1("informações gerais para filme"),
        br(),
        fluidRow(
          infoBoxOutput(
            outputId = "num_filmes",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_diretores",
            width = 4
          ),
          infoBoxOutput(
            outputId = "num_atores",
            width = 4
          )
        ),
        h3("Top 10 lucros"),
        br(),
        fluidRow(
          column(
            width = 12,
            reactableOutput("tabela_infos_gerais")
          )
        )
      ),
      # tab 2
      tabItem(
        tabName = "bilheteria",
        h1("Analisando os orçamentos"),
        br(),
        fluidRow(
          box(
            width = 12,
            uiOutput("ui_genero")
          )
        ),
        fluidRow(
          box(
            width = 6,
            title = "Série do orçamento",
            solidHeader = TRUE,
            status = "primary",
            plotOutput("serie_orcamento")
          ),
          box(
            width = 6,
            title = "Série da receita",
            solidHeader = TRUE,
            status = "primary",
            plotlyOutput("serie_receita")
          )
        )
      )

      # tab 3

    )
  )
)

server <- function(input, output, session) {
  imdb <- readr::read_rds("imdb.rds")

  # infoboxes ----
  output$num_filmes <- renderInfoBox(
    infoBox(
      title = "Número de filmes",
      value = nrow(imdb),
      icon = icon("film"),
      fill=TRUE
    )
  )

  output$num_diretores <- renderInfoBox(
    infoBox(
      title = "Número de diretoresk",
      value = dplyr::n_distinct(imdb$diretor),
      icon = icon("hand-point-right"),
      fill=TRUE
    )
  )


  num_atores <- imdb |>
    select(starts_with("ator")) |>
    pivot_longer( cols = ator_1:ator_3) |>
    distinct(value) |>
    nrow()


  output$num_atores <- renderInfoBox(
    infoBox(
      title = "Número de atores",
      value = num_atores,
      icon = icon("user-friends"),
      fill=TRUE
    )
  )

  output$tabela_infos_gerais <- renderReactable({

    imdb |>
      mutate(
        lucro = receita - orcamento
      ) |>
      top_n(200,lucro) |>
      select(titulo, diretor, ano , lucro) |>
      arrange(desc(lucro)) |>
      # ruim pois forma em texto
      # mutate(lucro = scales::dollar(lucro)) |>
      reactable(
        columns = list(
          lucro = colDef(
            "Lucro",format = colFormat(
              prefix = "",
              locales = "pt-BR",
              separators = TRUE,
              currency = "BRL"
            )
          ),
          diretor = colDef(
            "Diretor",
            align = "center"
          )
        ),
        striped = TRUE,
        highlight = TRUE,
        defaultPageSize = 20
      )
  })

  output$ui_genero <- renderUI({
    generos <- imdb$generos |>
      paste(collapse = "|") |>
      str_split("\\|") |>
      unlist() |>
      as.character() |>
      unique() |>
      sort()

    selectInput(
      inputId = "genero_orcamento",
      label="Selecione um gênero",
      choices = generos,
      width = "25%"
    )
  })

  output$serie_orcamento <- renderPlot({

    req(input$genero_orcamento)

    imdb |>
      filter(str_detect(generos, input$genero_orcamento)) |>
      group_by(ano) |>
      summarise(
        orcamento_medio = mean(orcamento, na.rm=TRUE)
      ) |>
      filter(!is.na(orcamento_medio)) |>
      ggplot(aes(x=ano, y = orcamento_medio)) +
      geom_line()
  })

  output$serie_receita <- renderPlotly({
    req(input$genero_orcamento)
    p<-imdb |>
      filter(str_detect(generos, input$genero_orcamento)) |>
      group_by(ano) |>
      summarise(
        receita_medio = mean(receita, na.rm=TRUE)
      ) |>
      filter(!is.na(receita_medio)) |>
      ggplot(aes(x=ano, y = receita_medio)) +
      geom_line()

    ggplotly(p)
  })
}

shinyApp(ui, server)
