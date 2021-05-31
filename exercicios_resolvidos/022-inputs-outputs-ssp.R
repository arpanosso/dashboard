# Explorando inputs
#
# Utilizando a base de criminalidade, faça um Shiny app que, dado um
# mês/ano escolhido pelo usuário, mostre uma tabela com o número de ocorrências
# de cada tipo que aconteceram naquele mês.
# O nível territorial (Estado, região, município ou delegacia) também pode
# ser um filtro.


library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(forcats)

ssp<-"../dados/ssp.rds" |>
  read_rds()

ui <- fluidPage(
  "Explorando inputs",
  sliderInput(inputId = "ano",
              label = "Selecione o ano",
              min = 2002,
              max = 2020,
              value=2011,
              step=1,
              sep = ""),
  selectInput(inputId = "mes",
              label = "Selecione o Mês",
              choices = 1:12 ),
  selectInput(inputId = "regiao",
              label = "Selecione a Regiao",
              choices =  c("ALL", ssp |>
                pull(regiao_nome) |>
                as_factor() |>
                levels())),
  selectInput(inputId = "municipio",
              label = "Selecione o Município",
              choices = c("ALL", ssp |>
                pull(municipio_nome) |>
                as_factor() |>
                levels())),
  selectInput(inputId = "delegacia",
              label = "Selecione a Delegacia",
              choices = c("ALL", ssp |>
                pull(delegacia_nome) |>
                as_factor() |>
                levels())),
  actionButton("atualizar", label = "Gerar Tabela"),
  tableOutput("tabela")
)

server <- function(input, output, session) {
  ssp <- reactive({read_rds("../dados/ssp.rds")})
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
