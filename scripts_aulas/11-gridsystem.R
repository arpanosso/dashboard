quadrado <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;",
    text
  )
}

quadrado_altao <- function(text = "") {
  div(
    style = "background: purple; height: 200px; text-align: center; color: white; font-size: 24px;",
    text
  )
}

library(shiny)

ui <- fluidPage(
  fluidRow(
    column(
      width = 2,
      quadrado("Q1 (width = 2)")
    ),
    column(
      width = 6,
      quadrado("Q3 (width = 6)")
    )
  ),
  fluidRow(
    column(
      width = 2,
      quadrado("Q2 (width = 2)")
    ),
    column(
      width = 10,
      quadrado("Q4 (width = 10)")
    )
  ),
  fluidRow(
    column(
      width = 6,
      quadrado("Q5 - (width = 6)")
    )
  ),
  fluidRow(
    column(
      width = 3,
      quadrado("quadrado normal")
    ),
    column(
      width = 3,
      quadrado_altao("quadrado altão")
    )
  ),
  fluidRow(
    column(
      width = 6,
      quadrado("coluna única")
    ),
    column(
      width = 6,
      fluidRow(
        column(
          width = 1,
          quadrado("1")
        ),
        column(
          width = 1,
          quadrado("1")
        ),
        column(
          width = 1,
          quadrado("1")
        ),
        column(
          width = 1,
          quadrado("1")
        ),
        column(
          width = 1,
          quadrado("1")
        ),
        column(
          width = 1,
          quadrado("1")
        )
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      p(
        style = "text-align: justify; color: orange;",
        "Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa coluna. Para criar colunas dentro de uma linha, utilizamos a função column(). Essa função tem dois argumentos: width e offset. O primeiro determina o comprimento da coluna (de 1 a 12). O segundo indica quanto espaço horizontal gostaríamos de antes de começar a nossa colunagagadgaggdagdagdagdagadgadgadgdagdagdgaa."
      )
    )
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
