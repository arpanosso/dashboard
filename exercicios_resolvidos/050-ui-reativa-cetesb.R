# UI reativa
#
# Construa um shiny app que possua um filtro de
# poluente que depende de um filtro de estação de monitoramento.
#
# Como output, faça uma série temporal diária da concentração do poluente.

# UI reativa
#
# Construa um shiny app que possua um filtro de
# pokemon que dependa de um filtro de tipo 1 e um filtro de tipo 2.
#
# Como output, faça um gráfico de dispersão do ataque vs defesa dos
# pokemon selecionados.


# UI reativa
#
# Construa um shiny app que possua um filtro de delegacia
# que depende de um filtro de município
# que depende de um filtro de região.
#
# Como output, faça uma série temporal do número de furtos.

library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(lubridate)

cetesb <- readr::read_rds("../dados/cetesb.rds")

ui <- dashboardPage(
  header = dashboardHeader(title = "Exercício 05"),
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("CETESB", tabName = "cetesb"),
      menuItem("POKEMON", tabName = "pokemon"),
      menuItem("SSP", tabName = "ssp"),
      menuItem("Código em R", tabName = "code")
    )
  ),
  body = dashboardBody(
    tabItems(
      #Página 1
      tabItem(
        tabName = "cetesb",
        fluidRow(
          column(
            width = 12,
            h1("Exercício - 050 - Cebesb")
          )
        ),
        hr(style = "border-top: 1px solid black;"), # tag horizontal row style para mudar o css
        br(),
        fluidRow(
          box(
            width = 8,
            fluidRow(
              column(
                width = 6,
                selectInput(
                  inputId = "estacao",
                  label = "Selecione uma estação",
                  choices = cetesb |>
                    pull(estacao_cetesb) |>
                    unique() |>
                    sort()
                )
              ),
              column(
                width = 6,
                selectInput(inputId = "poluente",
                            label = "Selecione um poluente",
                            choices ="Carregando...")
              )
            )
          )
        ),
        fluidRow(
          box(
            width = 8,
            plotOutput("graf_cetesb")
          )
        )
      ),
      # Página 2
      tabItem(
        tabName = "pokemon",
        fluidRow(
          column(
            width = 12,
            h1("Exercício - 051 - Pokemon")
          )
        ),
        hr(style = "border-top: 1px solid black;"), # tag horizontal row style para mudar o css
        br(),
        fluidRow(
          box(
            width = 8,
            fluidRow(
              column(
                width = 6,
                uiOutput("ui_tipo_1")
              )
            ),
            fluidRow(
              column(
                width = 6,
                uiOutput("ui_tipo_2")
              )
            )
          ),
          box(
            width = 8,
            fluidRow(
              column(
                width = 12,
                plotOutput("graf_pkm")
              )
            )
          )
        )
      ),
      # Página 3
      tabItem(
        tabName = "ssp",
        fluidRow(
          column(
            width = 12,
            h1("Exercício 052 - SSP")
          )
        ),
        hr(style = "border-top: 1px solid black;"), # tag horizontal row style para mudar o css
        br(),
        fluidRow(
          box(
            width = 6,
            fluidRow(
              column(
                width = 12,
                uiOutput("ui_regiao"),
                uiOutput("ui_municipio"),
                uiOutput("ui_delegacia")
              )
            )
          )
        ),
        fluidRow(
          column(
            width = 4,
            actionButton("atualizar", "Gerar Série")
          )
        ),
        br(),
        fluidRow(
          box(
            width = 6,
            title = "Série do número de furtos",
            solidHeader = TRUE, #cabeçalho colorido
            status = "primary",  # para mudar a cor igual do anterior
            plotOutput("serie_furtos")
          )
        )
      ),
      tabItem(
        tabName = "code",
        fluidRow(
          column(
            width = 12,
            h1("Código em R")
          )
        ),
        hr(style = "border-top: 1px solid black;"), # tag horizontal row style para mudar o css
        br(),
        includeHTML("../05_code.html")
      )
    )
  ),
  title = "Dashoboard - Curso R"
)

server <- function(input, output, session) {
  cetesb <- readr::read_rds("../dados/cetesb.rds")
  #pagina 01
  observe({
    poluentes <- cetesb |>
      filter(estacao_cetesb == input$estacao) |>
      pull(poluente) |> unique() |> sort()

    updateSelectInput(
      session,
      inputId = "poluente",
      choices = poluentes
    )

  })

  output$graf_cetesb <- renderPlot({
    req(input$poluente)
    cetesb |>
      filter(estacao_cetesb == input$estacao,
             poluente == input$poluente) |>
      group_by(data) |>
      summarise(media = mean(concentracao,na.rm=TRUE)) |>
      ggplot(aes(x=data,y=media)) +
      geom_line() +
      theme_minimal()
  })

  #página 2
  pokemon <- readr::read_rds("../dados/pkmn.rds")
  output$ui_tipo_1 <- renderUI({
    selectInput(
      "tipo_1",
      "Selecione o tipo 01",
      choices = pokemon |> pull(tipo_1) |> unique() |> sort(),
      selected = "aço"
    )
  })

  output$ui_tipo_2 <- renderUI({
    req(input$tipo_1)
    selectInput(
      "tipo_2",
      "Selecione o tipo 02",
      choices = pokemon |> filter(tipo_1 == input$tipo_1) |>
        pull(tipo_2) |> unique() |> sort(),
      selected = "Carregando..."
    )
  })

  output$graf_pkm <- renderPlot({
    req(input$tipo_1)
    req(input$tipo_2)

    pokemon |>
      filter(tipo_1 == input$tipo_1, tipo_2 == input$tipo_2) |>
      ggplot(aes(x=defesa,y=ataque)) +
      geom_point()
  })
  #página 3
  output$ui_regiao <- renderUI({
    ssp <- readr::read_rds("../dados/ssp.rds")
      selectInput(
        "regiao",
        "Selecione a região",
        choices = ssp |> pull(regiao_nome) |> unique() |> sort(),
        selected = "Araçatuba"
      )
    })

    output$ui_municipio <- renderUI({
      req(input$regiao)
      selectInput(
        "municipio",
        "Selecione o município",
        choices = ssp |> filter(regiao_nome == input$regiao) |>
          pull(municipio_nome) |> unique() |> sort(),
        selected = "Carregando..."
      )
    })

    output$ui_delegacia <- renderUI({
      req(input$regiao)
      req(input$municipio)
      selectInput(
        "delegacia",
        "Selecione a delegacia",
        choices = ssp |> filter(regiao_nome == input$regiao,
                                municipio_nome == input$municipio) |>
          pull(delegacia_nome) |> unique() |> sort(),
        selected = "Carregando..."
      )
    })

    output$serie_furtos <- renderPlot({
      graf_furtos()
    })


    graf_furtos <- eventReactive(input$atualizar,{
      ssp |> filter(regiao_nome == input$regiao,
                    municipio_nome == input$municipio,
                    delegacia_nome == input$delegacia) |>
        mutate(
          data = make_date(year = ano, month = mes)
        ) |>
        group_by(data) |>
        summarise(
          furtos = furto_outros + furto_veiculos
        ) |>
        ggplot(aes(x=data,y=furtos))+
        geom_line()
    })

}

shinyApp(ui, server)





