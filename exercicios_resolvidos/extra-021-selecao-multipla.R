# Selecionando várias opções
#
# (a) Reproduza o seguinte Shiny app:
# https://cursodashboards.shinyapps.io/select-multiple/
#
# (b) Troque o selectInput pelo checkboxGroupInput().
#
# Para acessar a base utilizada, rode o código abaixo:

# install.packages("nycflights13")

voos<-nycflights13::flights

library(tidyverse)
library(shiny)
library(forcats)
library(lubridate)
ui <- fluidPage(
  h3("Reproduzindo app"),
  selectizeInput(inputId = "lista",
                 label = "Selecione uma ou mais empresas",
                 choices = voos |> arrange(carrier) |>
                   pull(carrier) |>
                   as_factor() |> levels(),
                 selected = NULL,
                 multiple = TRUE,
                 options = NULL),
  plotOutput("grafico")
)

server <- function(input, output, session) {

  voos<-nycflights13::flights

  output$grafico <- renderPlot({
    fun_graf()
  })

fun_graf <- eventReactive(input$lista,{
  voos |>
    mutate(
      data =make_date(year, month, day)
    ) |>
    filter( carrier %in% input$lista) |>
    group_by(data,carrier) |>
    summarise( n_voos = n()) |>
    ggplot(aes(x=data,y=n_voos,color=as_factor(carrier)))+
    geom_line()+
    labs(x="Data",y="Número de voos",color="carrier",
         title = "Número de voos por empresa ao longode 2013",
         font=2)+
    theme_minimal()
})


}

shinyApp(ui, server)
