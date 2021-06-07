# Reconstrua os apps dos exercícios 2.0, 2.1 e 2.2, agora utilizando
# o sidebarLayout.


# 2.0 ---------------------------------------------------------------------
# library(shiny)
# library(dplyr)
# library(ggplot2)
# library(readr)
# library(forcats)
#
# credito<-read_rds("../dados/credito.rds")
#
# ui <- fluidPage(
#   titlePanel("Explorando inputs"),
#   sidebarLayout(
#     sidebarPanel=sidebarPanel( # primeira
#       width = 3,
#       selectInput(inputId = "var1",
#                   label = "Selecione o Estado Civil",
#                   choices =  credito |>
#                     pull(estado_civil) |>
#                     as_factor() |>
#                     levels()),
#       selectInput(inputId = "var2",
#                   label = "Selecione o Tipo de Moradia",
#                   choices =  credito |>
#                     pull(moradia) |>
#                     as_factor() |>
#                     levels()),
#       selectInput(inputId = "var3",
#                   label = "Selecione o Trabalho",
#                   choices =  credito |>
#                     pull(trabalho) |>
#                     as_factor() |>
#                     levels()),
#       actionButton("atualizar", label = "Gerar gráfico"),
#     ),
#     mainPanel=mainPanel( # segunda, geralmente a saída
#       width = 9,
#       plotOutput("grafico")
#     )
#   )
# )
#
# server <- function(input, output, session) {
#   credito <- read_rds("../dados/credito.rds")
#   output$grafico <- renderPlot({
#     grafico()
#   })
#
#
#   grafico <- eventReactive(input$atualizar,{
#     credito |>
#       filter(estado_civil == input$var1,
#              moradia == input$var2,
#              trabalho == input$var3) |> # browser() |>
#       group_by(status) |>
#       summarise(
#         cont = n()
#       ) |>
#       ggplot(aes(x=status,y=cont))+
#       geom_col(color="black",fill="aquamarine4") +
#       theme_classic()
#   })
# }
#
# shinyApp(ui, server)


# 2.1 ---------------------------------------------------------------------

# library(shiny)
# library(dplyr)
# library(ggplot2)
# library(readr)
# library(forcats)
#
# pokemon<-"../dados/pkmn.rds" |>
#   read_rds()
#
# cor<-c("green","red","blue",
#        "lightgreen","pink","purple",
#        "yellow","coral4","darkorchid4",
#        "darkorange","lavender","grey61",
#        "mediumorchid4","lightblue","lightsalmon4",
#        "violetred4","gray","blue")
#
# tipo<-pokemon |>
#   pull(tipo_1) |>
#   as_factor() |>
#   levels()
#
# cores <- tibble(tipo,cor)
#
# ui <- fluidPage(
#  titlePanel("Explorando inputs POKEMON"),
#  sidebarLayout(
#    sidebarPanel=sidebarPanel( # primeira
#             width = 3,
#     selectInput(inputId = "var1",
#                 label = "Selecione um Tipo",
#                 choices =  pokemon |>
#                   pull(tipo_1) |>
#                   as_factor() |>
#                   levels()),
#     selectInput(inputId = "var2",
#                 label = "Selecione uma Geração",
#                 choices =  pokemon |>
#                   pull(id_geracao) |>
#                   as_factor() |>
#                   levels())
#     ),
#    mainPanel = mainPanel(
#     plotOutput("grafico")
#    )
#  )
# )
#
# server <- function(input, output, session) {
#   credito <- read_rds("../dados/credito.rds")
#   output$grafico <- renderPlot({
#     pokemon |>
#       filter(tipo_1 == input$var1,
#              id_geracao == input$var2) |>
#       ggplot(aes(x=defesa,y=ataque))+
#       geom_point(shape=22,size=5,color="black",
#                  fill= cores |> filter(tipo==input$var1) |> pull(cor)
#                  ,
#                  alpha=.8) +
#       theme_classic()
#   })
#
#
# }
#
# shinyApp(ui, server)


# 2.2 ---------------------------------------------------------------------


library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(forcats)
library(purrr)

ssp1<-"ssp.rds" |>
  readRDS()

ssp_nest <- ssp1 |>
  pivot_longer(cols = estupro:vit_latrocinio,
               names_to = "ocorrencia",
               values_to = "contagem") |>
  group_by(regiao_nome) |>
  nest() |> drop_na()

make_list <- function(df,col){
  df |> pull(col) |> unique()
}

ssp_nest <- ssp_nest |>
  mutate(
    lista_1 = map(data,make_list,"municipio_nome"),
    lista_2 = map(data,make_list,"delegacia_nome")
  )

names(ssp_nest$lista_1) <- ssp_nest$regiao_nome
names(ssp_nest$lista_2) <- ssp_nest$regiao_nome

ui <- fluidPage(
  titlePanel("Explorando inputs"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      width = 4,
      sliderInput(inputId = "ano",
                  label = "Selecione o ano",
                  min = 2002,
                  max = 2020,
                  value=2011,
                  step=1,
                  sep = ""),
      selectInput(inputId = "mes",
                  label = "Selecione o Mês",
                  choices = 1:12),
      selectInput(inputId = "regiao",
                  label = "Selecione a Regiao",
                  choices =  c("ALL", ssp1 |>
                                 pull(regiao_nome) |>
                                 as_factor() |>
                                 levels())),
      selectInput(inputId = "municipio",
                  label = "Selecione o Município",
                  choices = c("ALL", ssp_nest$lista_1)),
      selectInput(inputId = "delegacia",
                  label = "Selecione a Delegacia",
                  choices = c("ALL", ssp_nest$lista_2)),
    ),
    mainPanel = mainPanel(
      width = 8,
      actionButton("atualizar", label = "Gerar Tabela"),
      tableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {
  ssp <- reactive({readRDS("ssp.rds")})
  output$tabela <- renderTable({
    tabela()
  })
  tabela <- eventReactive(input$atualizar,{

    if(input$regiao == "ALL") {
      ssp_f <- ssp()
    }else{
      ssp_f <- ssp() |> filter(regiao_nome == input$regiao)
    }

    if(input$municipio == "ALL") {
      ssp_f <- ssp_f
    }else{
      ssp_f <- ssp_f |> filter(municipio_nome == input$municipio)
    }

    if(input$delegacia == "ALL") {
      ssp_f <- ssp_f
    }else{
      ssp_f <- ssp_f |> filter(delegacia_nome == input$delegacia)
    }

    ssp_f |>
      filter(ano==input$ano,mes==input$mes) |>
      pivot_longer(cols = estupro:vit_latrocinio,
                   names_to = "ocorrencia",
                   values_to = "contagem") |>
      group_by(ocorrencia) |>
      summarise(
        soma_ocorrencia = as.integer(sum(contagem))
      ) |>
      filter(soma_ocorrencia >0)
  })
}

shinyApp(ui, server)

