pokemon<- readr::read_rds("pkmn.rds")

conteudo_ui <- function(id){
  ns<-NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        uiOutput(ns("titulo"))
      )
    ),
    fluidRow(
      column(
        width = 4,
        selectInput(
          ns("pokemon"),
          "selecione um pokemon",
          choices = c("Carregando..." = "") # mostra uma coisa e recebe outra
        ),
        uiOutput(ns("imagem"))
      ),
      column(
        width = 8,
        plotOutput(ns("grafico_habilidades"))
      )
    ),
    fluidRow(
      column(
        width = 12,
        plotOutput(ns("grafico_freq"))
      )
    )
  )
}


conteudo_server <- function(id, tipo){
  moduleServer(id, function(input, output, session){

    cor <- pokemon |>
      filter(tipo_1 == tipo) |>
      pull(cor_1) |>
      first()

    tab_pokemon_tipo <- pokemon |>
      filter(tipo_1 == tipo)


    ouput$titulo <- renderUI({
      h2(
        glue::glue("Pokémon do tipo {tipo}"),
        style = glue::glue("color: {cor};")
        )
    })

    observe({
      pkmns <- tab_pokemon_tipo |>
        pull |>
        unique()
      updateSelectInput(
        session,
        "pokemon",#" sem ns"
        choices =  pkmns
      )
    })

    output$imagem <- renderUI({

      url <- tab_pokemon_tipo |>
        filter(pokemon == input$pokemon) |>
        pull(url_imagem)

      img(src = url, width = "300px")

    })

    output$grafico_habilidaes <- renderPlot({

    })

    output$grafico_freq <- renderPlot({

      tab_pokemon_tipo |>
        count(id_geracao) |>
        ggplot(aes(x=id_geracao, y=n)) +
        geom_col(fill=cor) +
        theme_minimal()
    })


  })
}
