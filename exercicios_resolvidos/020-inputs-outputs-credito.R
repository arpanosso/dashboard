# Explorando inputs
#
# Utilizando a base de crédito, faça um Shiny app que permite escolher
# o estado civil, tipo de moradia e/ou trabalho e mostra uma visualização
# representando a proporção de clientes "bons" e "ruins" da base.
library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(forcats)

credito<-read_rds("../dados/credito.rds")

ui <- fluidPage(
  "Explorando inputs",
  selectInput(inputId = "var1",
              label = "Selecione o Estado Civil",
              choices =  credito |>
                pull(estado_civil) |>
                as_factor() |>
                levels()),
  selectInput(inputId = "var2",
              label = "Selecione o Tipo de Moradia",
              choices =  credito |>
                pull(moradia) |>
                as_factor() |>
                levels()),
  selectInput(inputId = "var3",
              label = "Selecione o Trabalho",
              choices =  credito |>
                pull(trabalho) |>
                as_factor() |>
                levels()),
  actionButton("atualizar", label = "Gerar gráfico"),
  plotOutput("grafico")
)


server <- function(input, output, session) {
  credito <- read_rds("../dados/credito.rds")
  output$grafico <- renderPlot({
    grafico()
  })


  grafico <- eventReactive(input$atualizar,{
    credito |>
       filter(estado_civil == input$var1,
              moradia == input$var2,
              trabalho == input$var3) |> # browser() |>
      group_by(status) |>
      summarise(
        cont = n()
      ) |>
      ggplot(aes(x=status,y=cont))+
      geom_col(color="black",fill="aquamarine4") +
      theme_classic()
  })
}

shinyApp(ui, server)
