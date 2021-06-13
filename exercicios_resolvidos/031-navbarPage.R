# navbarPage
#
# Utilizando a base cetesb, faça um shiny app que tenha duas abas:
#
# - a primeira com uma série temporal da média diária do ozônio (O3),
# permitindo a escolha do intervalo de dias em que o gráfico é gerado
#
# - a segunda com a série temporal da média diária do último mês da base
# permitindo a escolha do poluente.

library(shiny)
library(shinydashboard)
library(tidyverse)
library(readr)
library(forcats)

cetesb <- read_rds("../dados/cetesb.rds")
limites <- cetesb |> pull(data) |> range()
poluentes <- cetesb |> pull(poluente) |> as_factor() |> levels()

ui <- dashboardPage(
  header=dashboardHeader(
    title = "Exercício 031"
  ),
  sidebar=dashboardSidebar(
    sidebarMenu(
      menuItem("Série Temporal - Ozônio", tabName = "ozonio"),
      menuItem("Série Temporal - Poluentes",tabName = "poluentes")
    )
  ),
  body=dashboardBody(
    tabItems(
      tabItem(
        tabName = "ozonio",
        fluidRow( # sempre usar com Colum, para não dar toque
          column(width = 12,h1("Média diária (O3)")),
          column(
            width = 5,
            dateInput(inputId = "inicio",
                      label = "Selecione data Inicial",
                      min = limites[1],
                      max = limites[2],
                      value = limites[1],
                      format = "dd-mm-yyyy")
            ),
          column(
            width = 5,
            dateInput(inputId = "fim",
                      label = "Selecione data Final",
                      min = limites[1],
                      max = limites[2],
                      value = limites[2],
                      format = "dd-mm-yyyy")
          ),
          column(
            width = 8,
            actionButton("atualizar", label = "Gerar Gráfico")
          ),
          column(
            width = 10,
            plotOutput("grafico1")
          )
        )
      ),
      tabItem(
        tabName = "poluentes",
        fluidRow( # sempre usar com Colum, para não dar toque
          column(width = 12,h1("Média diária - Mês dezembro de 2020")),
          column(
            width = 8,
            selectInput(inputId = "poluente",
                      label = "Selecione o Poluente",
                      choices = poluentes)
          ),
          column(
            width = 8,
            actionButton("atualizar2", label = "Gerar Gráfico")
          ),
          column(
            width = 10,
            plotOutput("grafico2")
          )
        )
      )
    )
  )
)


server <- function(input, output, session) {
  cetesb <- reactive({read_rds("../dados/cetesb.rds")})
  output$grafico1<-renderPlot({grafico1()})
  grafico1 <- eventReactive(input$atualizar,{
    cetesb() |>
      filter(data >= input$inicio & data <= input$fim, poluente=="O3") |>
      group_by(data) |>
      summarise(
        media_ozonio = mean(concentracao,na.rm=TRUE)
      ) |>
      ggplot(aes(x=data,y=media_ozonio)) +
      geom_line()+
      theme_bw()
  })


  output$grafico2<-renderPlot({grafico2()})
  grafico2 <- eventReactive(input$atualizar2,{
    cetesb()|>
      filter(poluente==input$poluente, data > "2020-01-01" & data <= "2020-12-31") |>
      group_by(data) |>
      summarise(
        media_poluente = mean(concentracao,na.rm=TRUE)
      ) |>
      ggplot(aes(x=data,y=media_poluente)) +
      geom_line()+
      theme_bw()
  })

}

shinyApp(ui, server)
