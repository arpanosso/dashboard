# Dicas - https://htmlcolorcodes.com/color-chart/

library(shiny)


# A UI é a interefae contrúida dentro do Shiny dentro do R mas no
# fundo ela é HTML CSS e JS.
ui <- fluidPage("Olá, mundo!") # objeto que recebe

# tags <div> <\div> as funções retornam essas tags em HTML
# além disso a fluidPage retorna um bloco div.
# "container-fluid" gerada pela função dá características para
# o olá mundo, é uma classe de HTML

server <- function(input, output, session){ # minha função server
  # Códigos em R que alimentam as visualizações
  # input e output são listas
  # input tem todas as formas que demos para o usuariso se
  # comunkjcar com o app, a informação chga no input
  # output é o contrário, tudo que ser mostrado e construido dentro
  # do server estará nessa lista
  # session - importante pos guarda informações relevantes
  # para utilização dentro do servidor.
  # app funciona se mo sassion, mas não vale a pena fazer sem
  # pois conforme vamos para outro app, vamos precisar dele.
  # no exemplo dos pinguins inputs entradas 2, e 1 output
  # utpu images, graficos, tabelas e outras coisas
  # FAMILIA de função OUTPUT image, plot, table, textOutput
  # outros pacotes trazem MAPAS, por exemplo
  # a função prima da output é a render_() é usado no servidor
  # para construir, preciso do grafico dentro do render,
  # isso por causa da reatividade, pois esse gráfico é reativo, pois
  # quem usar o app, muda o input e o gráfico depende do valore,
  # o código deve rodar toda vez que o valro de inoput foor mudado
  # e quem cria a reatividade é o render, que pega a saída do codigo
  # do gráfico, ggplot, por exemplo e trasnforma em HTML, se se mudar um input
  # ela atualizar, refaz o codigo. UI - SERVER é output e render

}

shinyApp(ui,server) # Segredo é montar UI e o Server pra funfar
# observe uqe apareceu na aba o Run App, o RStudio identificou e
# colocou o RunApp
# a roda a sessão trava e pra destravar STOP ou Esc, ela para de servir o
# app



