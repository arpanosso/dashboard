# Modulos são usados quanto o código fica muito grande
# são adaptações do uso de funções
# código é quebrado em varios lugares
# ganhamos em reprodutibilidade
# e usamos várias funções em varios lugares
# e ganhamos organizações

# Estrutura -
# 1-Móduilos sao funções
# 2-cada módulo é um mini shiny, dividimos o app em partes (Megazord)
#   cada modulo tera ui e um server, as vezes vazio, as vezes não
# 3-regras para deixar ID únicos, próprio módulo recebe ID, no desenvolvumento
# do app, os ID são [unicos] e dentro dew cada modico, input e output
# serão únicos, não precisa ser unico entre modulos.

#### Boas Práticas
# ns() faz isso e a gente pode usar ddentro dos m[odulos]
# a) id é sempre o primeiro argumento
# b) nomes terminam com ui e server underlane (snake_case) ou camelCase
# c) ns <- NS(id) sempre começar assim, ele cria afunção ns que é usada
#    para pegar o ID e colar no começo de um nome concatena a strings dos modulos
#    para ter objetos unicos dentro de um especifico modulo
#    todo inputID e outputID tem que estar encapsulo no ns()
# d) associado temos o server do múdulo moduleServer
# e) a tagList é o embrulho para o módulo devolver tudo e não somente a última
#    linha como costumeiro na função.
# f) o múdulo deve bater com o server e a ui.
# Se tiver mais que uma visão no app, vale a pena fazer o módulo
# g) pode ter mais argumentos, são parametrizaveis
# h) o ideal é evitar que um múdulo receba algo de outro modulo, tem que
#    o mais encapsula possivel.



























