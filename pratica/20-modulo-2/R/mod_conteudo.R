pokemon <- readr::read_rds("pkmn.rds")

conteudo_ui <- function(id) {
  ns <- NS(id)

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
          "Selecione um pokemon",
          choices = c("Carregando..." = "")
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

conteudo_server <- function(id, tipo) {
  moduleServer(id, function(input, output, session) {

    cor <- pokemon %>%
      filter(tipo_1 == tipo) %>%
      pull(cor_1) %>%
      first()

    tab_pokemon_tipo <- pokemon %>%
      filter(tipo_1 == tipo)

    output$titulo <- renderUI({
      h2(
        glue::glue("Pokémon do tipo {tipo}"),
        style = glue::glue("color: {cor};")
      )
    })

    observe({
      pkmns <- tab_pokemon_tipo %>%
        pull(pokemon)

      updateSelectInput(
        session,
        "pokemon",
        choices = pkmns
      )

    })

    output$imagem <- renderUI({
      url <- tab_pokemon_tipo %>%
        filter(pokemon == input$pokemon) %>%
        pull(url_imagem)

      img(src = url, width = "300px")
    })

    output$grafico_habilidades <- renderPlot({

      tab_pokemon_escolhido <- tab_pokemon_tipo %>%
        filter(pokemon == input$pokemon) %>%
        tidyr::pivot_longer(
          names_to = "habilidade",
          values_to = "valor",
          cols = ataque:velocidade
        )

      tab_pokemon_tipo %>%
        tidyr::pivot_longer(
          names_to = "habilidade",
          values_to = "valor",
          cols = ataque:velocidade
        ) %>%
        ggplot(aes(y = habilidade, x = valor, fill = habilidade)) +
        ggridges::geom_density_ridges(
          show.legend = FALSE,
          alpha = 0.8
        ) +
        geom_point(
          aes(x = valor, y = habilidade),
          data = tab_pokemon_escolhido,
          shape = 4,
          show.legend = FALSE,
          alpha = 0.9,
          size = 5
        ) +
        labs(y = "Habilidade", x = "Valor") +
        theme_minimal()

    })

    output$grafico_freq <- renderPlot({
      tab_pokemon_tipo %>%
        count(id_geracao) %>%
        ggplot(aes(x = id_geracao, y = n)) +
        geom_col(fill = cor) +
        theme_minimal()
    })




  })
}
