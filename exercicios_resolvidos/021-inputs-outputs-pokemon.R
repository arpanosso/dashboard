# Explorando inputs
#
# Utilizando a base de pokemon, faça um Shiny app que permite escolher
# um tipo (tipo_1) e uma geração e faça um gráfico de dispersão do ataque
# vs defesa para os pokemon com essas características.

library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(forcats)

pokemon<-"../dados/pkmn.rds" |>
  read_rds()

cor<-c("green","red","blue",
      "lightgreen","pink","purple",
      "yellow","coral4","darkorchid4",
      "darkorange","lavender","grey61",
      "mediumorchid4","lightblue","lightsalmon4",
      "violetred4","gray","blue")

tipo<-pokemon |>
  pull(tipo_1) |>
  as_factor() |>
  levels()

cores <- tibble(tipo,cor)

ui <- fluidPage(
  "Explorando inputs POKEMON",
  selectInput(inputId = "var1",
              label = "Selecione um Tipo",
              choices =  pokemon |>
                pull(tipo_1) |>
                as_factor() |>
                levels()),
  selectInput(inputId = "var2",
              label = "Selecione uma Geração",
              choices =  pokemon |>
                pull(id_geracao) |>
                as_factor() |>
                levels()),
  plotOutput("grafico")
)

server <- function(input, output, session) {
  credito <- read_rds("../dados/credito.rds")
  output$grafico <- renderPlot({
    pokemon |>
      filter(tipo_1 == input$var1,
             id_geracao == input$var2) |>
      ggplot(aes(x=defesa,y=ataque))+
      geom_point(shape=22,size=5,color="black",
                 fill= cores |> filter(tipo==input$var1) |> pull(cor)
                 ,
                 alpha=.8) +
      theme_classic()
  })


}

shinyApp(ui, server)


