# Date input
#
# Reproduza o seguinte Shiny app:
# https://cursodashboards.shinyapps.io/select-date/
#
# Para acessar a base utilizada, rode o código abaixo:

library(tidyverse)
library(shiny)
library(forcats)
library(lubridate)

voos<-nycflights13::flights

inicio_fim<-voos |> mutate(
  data=make_date(year,month,day)
) |> pull(data) |> range()

ui <- fluidPage(
  h3("Reproduzindo app"),
  dateInput(inputId = "data",
            label = "Escolha o dia",
            value = inicio_fim[1],
            min = inicio_fim[1],
            max = inicio_fim[2],
            format = "dd-mm-yyyy",),
  tableOutput("tabela"),
  plotOutput("grafico")
)

server <- function(input, output, session) {

  voos<-nycflights13::flights

  output$tabela <- renderTable({
    voos |>
      mutate(data=make_date(year,month,day)) |>
      filter(data==input$data) |>
      mutate(dep_delay = ifelse(dep_delay<0,0,dep_delay),
             arr_delay = ifelse(arr_delay<0,0,arr_delay))  |>
      summarise(
        `Número de voos` = n(),
        `Atraso médio de partida (min)`=mean(dep_delay,na.rm=TRUE),
        `Atraso médio de chegada (min)`=mean(arr_delay,na.rm=TRUE)
      )
  })

  output$grafico <- renderPlot({
    voos |>
      mutate(data=make_date(year,month,day)) |>
      filter(data==input$data) |>
      group_by(carrier) |>
      summarise(
        n_voos = n()
      ) |>
      ggplot(aes(x=carrier,y=n_voos,fill=as_factor(carrier)))+
      geom_col() +
      theme_minimal()+
      theme(legend.position = "none")+
      labs(x="Empresa",y="Número de voos",
           title="Número de voos por empresa")
  })



}

shinyApp(ui, server)
