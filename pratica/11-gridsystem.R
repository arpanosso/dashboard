quadrado <- function(text = ""){
  div(
    style="background: purple; height: 100px; text-align: center; color: white;
    font-size: 24px;",
    text
  )
}


quadrado_altao <- function(text = ""){
  div(
    style="background: purple; height: 200px; text-align: center; color: white;
    font-size: 24px;" ,
    text
  )
}
# sempre usar fludRow e colum juntos...nunca somente o coloum, apra alinhar
# de deixar responsivo

library(shiny)

ui <- fluidPage(
  fluidRow(
    column(
      width = 2,
      quadrado("Q1 - tamanho2")
    ),
    column(
      width = 6,
      quadrado("Q3 - tamanho2")
    )
  ),
  fluidRow(
    column(
      width = 2,
      quadrado("Q2- tamanho2")
    ),
    column(
      width = 10,
      quadrado("Q4- tamanho 10")
    )
  ),
  fluidRow(
    column(
      width = 6,
      quadrado("Q5 - tamamnho 6")
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
        "Atualmente o RStudio é considerado o melhor IDE para quem programa em R. Além de ... Ao tentarmos criar um vetor com tipos de dados heterogêneos, o R ... Outras funções que frequentemente utilizamos no R são as que geram ... Seus componentes são indexados pelo índice da linha e da coluna correspondente.
        Atualmente o RStudio é considerado o melhor IDE para quem programa em R. Além de ... Ao tentarmos criar um vetor com tipos de dados heterogêneos, o R ... Outras funções que frequentemente utilizamos no R são as que geram ... Seus componentes são indexados pelo índice da linha e da coluna correspondente."
      )
    )
  )
)



server <- function(input, output, session) {

}

shinyApp(ui, server)
