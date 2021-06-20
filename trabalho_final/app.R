library(shiny)
library(shinydashboard)
library(fresh)
library(dplyr)
library(shinycssloaders)

meu_tema <- create_theme(
  adminlte_color(
    blue = "#4c51bd"
  )
)

ui <- dashboardPage(
  header = dashboardHeader(title = "Pokemon Dashboard"),
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Visão geral", tabName = "visao"),
      menuItem("Por tipo", tabName = "tipo"),
      menuItem("Comparando tipos", tabName = "comparando"),
      menuItem("Código", tabName = "codigo",
               badgeLabel = "NOVO", badgeColor = "red"),
      hr(style = "border-top: 1px solid white;"),
      withSpinner(uiOutput("ui_geracao"))
    ),
    actionButton("atualizar", "Incluir")
  ),

  body = dashboardBody(
    use_theme(meu_tema),
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "custom.css"
    ),
    ### Página 3 - comparando tipos
    tabItems(
      tabItem(
        tabName = "visao",
        tableOutput("tabela_visao")
      ),
      tabItem(
        tabName = "comparando",
        fluidRow(
          box(
            width = 12,
            fluidRow(
              column(
                width = 6,
                selectInput(
                  "tipo_1",
                  "Tipo 1",
                  choices = ""
                )
              ),
              column(
                width = 6,
                selectInput(
                    "tipo_2",
                    "Tipo 2",
                    choices = ""
                )
              )
            )
          )
        )
      ),
      ##### Página 04 - Com o Código
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
        includeHTML("code.html")
      )
    )
  ),
  title = "Pokemon Dashboard"
)

server <- function(input, output, session) {
  #Sys.sleep("2")


  pkmn <- "pkmn.rds" |> readr::read_rds() |>
    pivot_longer(cols = starts_with("tipo"),
                 names_to = "tipo_",
                 values_to = "tipo"
                 ) |>
    filter(!is.na(tipo))

  output$ui_geracao <- renderUI({
    geracoes <- pkmn |> filter(!is.na(id_geracao)) |>
      pull(id_geracao) |> unique()
    checkboxGroupInput(
    inputId = "geracao",
    label = "Gerações",
    inline=FALSE,
    choiceValues = geracoes,
    choiceNames = paste("Geração",geracoes),
    selected = 1)
  })

  output$tabela_visao <- renderTable({
    req(input$geracao)
    base_pkmn()
  })

  base_pkmn <- eventReactive(input$atualizar, ignoreNULL =FALSE,{
    pkmn |>
      filter( id_geracao %in% input$geracao)
  })

  observe({
    req(input$geracao)

    tipos<-base_pkmn() |>
      pull(tipo) |>
      sort() |>
      unique()

    updateSelectInput(
      session,
      "tipo_1",
      choices = tipos,
      selected = "água"
    )

    updateSelectInput(
      session,
      "tipo_2",
      choices = tipos,
      selected = "fogo"
    )
  })


}
shinyApp(ui, server)
