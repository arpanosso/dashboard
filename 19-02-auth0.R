# auth0::use_auth0() # cria o arquivo _auth0.yml de configuração

# não se coloa os códigos diretamente as senhas nesse arquivo, não fazer isso
# para limitar o acesso, se perder é inseguro
# guarda então variaveis de ambiente

usethis::edit_r_environ("project") # Renviron, e colocar a variaveis de ambiente
# temos que substituir no utl por us.auth0.com
# trowue a função de aplicativo no app para shinyAppAuth0

#
