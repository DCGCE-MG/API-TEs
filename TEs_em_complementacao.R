library(openssl)
library(jsonlite)
library(jose)
library(httr)
library(jsonlite)
library(dplyr)
library(WriteXLS)
library(openxlsx)
library(gmailr)
library(googledrive)
library(htmlTable)
library(tableHTML)
library(scales)
library(formattable)
library(gargle)

Sys.setenv(http_proxy = "http://m1578465:34423767Gb@proxycamg.prodemge.gov.br:8080")
Sys.setenv(https_proxy = "http://m1578465:34423767Gb@proxycamg.prodemge.gov.br:8080")


setwd <- "C:\\Users\\M1578465\\Desktop\\API TEs"

# URL base da API cnpj_beneficiario_plano_acao
base_url <- "https://api.transferegov.gestao.gov.br/transferenciasespeciais/plano_acao_especial?cnpj_beneficiario_plano_acao=eq.18715615000160"

# Fazer a requisição GET com os cabeçalhos necessários
resposta <- GET(
  base_url,
  add_headers(
    "accept" = "application/json",
    "Range-Unit" = "items"
  )
)

# Verificar o status da requisição
if (status_code(resposta) == 200) {
  # Converter a resposta para JSON e depois para data.frame
  conteudo <- content(resposta, "text", encoding = "UTF-8")
  dados <- fromJSON(conteudo)
  
  # Exibir as primeiras linhas do data.frame
  print(head(dados))
} else {
  print(paste("Erro na requisição:", status_code(resposta)))
}

colnames(dados) <- gsub("_", " ", colnames(dados))


#Criação do arquivo em XLSX
#write.xlsx(dados, "C:\\Users\\M1578465\\Desktop\\API TEs\\dados.xlsx", sep = ",", rowNames = FALSE, fileEncoding = "UTF-8", colNames = TRUE, overwrite = TRUE)

#Identificando id_plano_ação para gerar consulta dos planos de trabalho em complementação
#transformando id plano de ação em lista
lista_valores <- dados$`id plano acao`


#URLS base da API plano de trabalho
url_base <- "https://api.transferegov.gestao.gov.br/transferenciasespeciais/plano_trabalho_especial?id_plano_acao="

dados_plano_trabalho <- data.frame()  # Inicializa um dataframe vazio

# Criando um loop para iterar sobre cada valor da lista e chamar a API
for (valor in lista_valores) {
  url_completa <- paste0(url_base, "eq.", valor)
  # Exibe a URL para depuração
  print(paste("Requisitando a URL:", url_completa))
  
  #requisição GET
  resposta_plano_trabalho <- GET(
    url_completa,
    add_headers(
      "accept" = "application/json",
      "Range-Unit" = "items"
    )
  )
  # Verifica se a requisição foi bem-sucedida
  if (httr::status_code(resposta_plano_trabalho) == 200) {
    # Converte a resposta para um DataFrame
    dados_resposta <- jsonlite::fromJSON(httr::content(resposta_plano_trabalho, "text", encoding = "UTF-8"))
    
    # Exibe os dados da resposta para depuração
    print(paste("Dados recebidos para o ID", valor))
    print(dados_resposta)
    
    # Se a resposta contém dados, adiciona ao data frame principal
    if (length(dados_resposta) > 0) {
      dados_plano_trabalho <- rbind(dados_plano_trabalho, dados_resposta)  # Acrescenta os dados na tabela
    }
  } else {
    print(paste("Erro ao acessar:", url_completa, "Status:", httr::status_code(resposta_plano_trabalho)))
  }
}

#alterando nome das colunas
colnames(dados_plano_trabalho) <- gsub("_", " ", colnames(dados_plano_trabalho))

#URLS base da API executor especial
url_executor <- "https://api.transferegov.gestao.gov.br/transferenciasespeciais/executor_especial?id_plano_acao="

dados_executor_especial <- data.frame()  # Inicializa um dataframe vazio

# Criando um loop para iterar sobre cada valor da lista e chamar a API
for (valor in lista_valores) {
  url_completa_executor <- paste0(url_executor, "eq.", valor)
  # Exibe a URL para depuração
  print(paste("Requisitando a URL:", url_completa_executor))
  
  #requisição GET
  resposta_executor_especial <- GET(
    url_completa_executor,
    add_headers(
      "accept" = "application/json",
      "Range-Unit" = "items"
    )
  )
  # Verifica se a requisição foi bem-sucedida
  if (httr::status_code(resposta_executor_especial) == 200) {
    # Converte a resposta para um DataFrame
    dados_resposta_executor <- jsonlite::fromJSON(httr::content(resposta_executor_especial, "text", encoding = "UTF-8"))
    
    # Exibe os dados da resposta para depuração
    print(paste("Dados recebidos para o ID", valor))
    print(dados_resposta_executor)
    
    # Se a resposta contém dados, adiciona ao data frame principal
    if (length(dados_resposta_executor) > 0) {
      dados_executor_especial <- rbind(dados_executor_especial, dados_resposta_executor)  # Acrescenta os dados na tabela
    }
  } else {
    print(paste("Erro ao acessar:", url_completa_executor, "Status:", httr::status_code(resposta_executor_especial)))
  }
}

#alterando nome das colunas
colnames(dados_executor_especial) <- gsub("_", " ", colnames(dados_executor_especial))


#URLS base da API relatorio de gestao
url_relatorio_gestao <- "https://api.transferegov.gestao.gov.br/transferenciasespeciais/relatorio_gestao_especial?id_plano_acao="

dados_relatorio_gestao <- data.frame()  # Inicializa um dataframe vazio

# Criando um loop para iterar sobre cada valor da lista e chamar a API
for (valor in lista_valores) {
  url_completa_relatorio_gestao <- paste0(url_relatorio_gestao, "eq.", valor)
  # Exibe a URL para depuração
  print(paste("Requisitando a URL:", url_completa_relatorio_gestao))
  
  #requisição GET
  resposta_relatorio_gestao <- GET(
    url_completa_relatorio_gestao,
    add_headers(
      "accept" = "application/json",
      "Range-Unit" = "items"
    )
  )
  # Verifica se a requisição foi bem-sucedida
  if (httr::status_code(resposta_relatorio_gestao) == 200) {
    # Converte a resposta para um DataFrame
    dados_resposta_relatorio_gestao <- jsonlite::fromJSON(httr::content(resposta_relatorio_gestao, "text", encoding = "UTF-8"))
    
    # Exibe os dados da resposta para depuração
    print(paste("Dados recebidos para o ID", valor))
    print(dados_resposta_relatorio_gestao)
    
    # Se a resposta contém dados, adiciona ao data frame principal
    if (length(dados_resposta_relatorio_gestao) > 0) {
      dados_relatorio_gestao <- rbind(dados_relatorio_gestao, dados_resposta_relatorio_gestao)  # Acrescenta os dados na tabela
    }
  } else {
    print(paste("Erro ao acessar:", url_completa_relatorio_gestao, "Status:", httr::status_code(resposta_relatorio_gestao)))
  }
}


#alterando nome das colunas
colnames(dados_relatorio_gestao) <- gsub("_", " ", colnames(dados_relatorio_gestao))

#Escolhendo quais colunas manter em cada DF
dados1 <- dados[,c(1,2,3,5,6,7,9,10,11,12,13,14,15,16,20,24,25,26)]
dados_plano_trabalho1 <- dados_plano_trabalho[,c(1,2,7)]
dados_relatorio_gestao1 <- dados_relatorio_gestao[,c(2,3,4)]

#Tratando bases
#dados1
dados1$`valor TOTAL da emenda` <- dados1$`valor custeio plano acao` + dados1$`valor investimento plano acao` #Criando coluna de valor total da emenda
#dados_executor_especial
dados_executor_especial$`valor TOTAL recebido (Executor)` <- dados_executor_especial$`vl custeio executor` + dados_executor_especial$`vl investimento executor` #Criando coluna de valor total da emenda

#fazendo left_join das bases
consolidada <- left_join(dados1, dados_plano_trabalho1)
consolidada1 <- left_join(consolidada, dados_executor_especial)
consolidada2 <- left_join(consolidada1, dados_relatorio_gestao1)

#Tratamento da base consolidada
consolidada3 <- consolidada2 %>% #Realizando formatação de moeda nas colunas de valores
  mutate(
    across(c(`valor custeio plano acao`, `valor investimento plano acao`,`valor TOTAL da emenda`,`vl custeio executor`,`vl investimento executor`,
             `valor TOTAL recebido (Executor)`),~dollar(., prefix = "R$ ", big.mark = ".", decimal.mark = ",")
    )
  )
#Consolidando e organizando as colunas
consolidada_final <- consolidada3[,c(14,15,1,2,3,20,21,22,23,24,25,26,27,28,4,5,6,16,17,18,19,29,30)]

# Criando um workbook
wb <- createWorkbook()

# Adicionando uma aba
addWorksheet(wb, "Controle TEs")

# Criando um estilo para o cabeçalho (negrito)
header_style <- createStyle(
  fontName = "Tahoma",
  fontSize = 8,
  fontColour = "black",
  textDecoration = "bold", # Negrito
  halign = "center",       # Alinhamento horizontal centralizado
  valign = "center",       # Alinhamento vertical centralizado
  border = "TopBottomLeftRight",       # Borda em todos os lados
  borderColour = "black"
)
# Criando um estilo para os dados (sem negrito)
data_style <- createStyle(
  fontName = "Tahoma",
  fontSize = 8,
  fontColour = "black",
  halign = "left",  # Alinhamento horizontal à esquerda
  valign = "center", # Alinhamento vertical centralizado
  border = "TopBottomLeftRight",       # Borda em todos os lados
  borderColour = "black"
)

# Escrevendo o DataFrame na aba
writeData(wb, sheet = "Controle TEs", x = consolidada_final)

# Aplicando estilo ao cabeçalho (primeira linha)
addStyle(wb, sheet = "Controle TEs", style = header_style, rows = 1, cols = 1:(ncol(consolidada_final) + 1),
         gridExpand = TRUE)

# Aplicando estilo aos dados (linhas restantes)
addStyle(wb, sheet = "Controle TEs", style = data_style, rows = 2:(nrow(consolidada_final) + 1),
         cols = 1:(ncol(consolidada_final) + 1), gridExpand = TRUE)

# Ajustando largura das colunas automaticamente
setColWidths(wb, sheet = "Controle TEs", cols = 1:(ncol(consolidada_final) + 1), widths = 15)


#Cria o arquivo atualizado
nome_arquivo <- paste0("Base de controle Transferências Especiais",".xlsx")
saveWorkbook(wb, nome_arquivo, overwrite = TRUE)


#Criando data frame
TE_em_complementacao <- data.frame()

# Filtrando os planos de trabalho em complementação
em_complementacao <- subset(consolidada_final, `situacao plano trabalho` == "Em Complementação")

#Armazenando TE com situacao plano trabalho em complementação
if (nrow(em_complementacao) > 0) {
  TE_em_complementacao <- rbind(TE_em_complementacao, em_complementacao)
  TE_em_complementacao <- TE_em_complementacao %>% 
    distinct(`numero emenda parlamentar plano acao`, .keep_all = TRUE)
} else {
  print("Nenhum plano de trabalho em complementação")
}
#Criando arquivo em xlsx com a base de dados para a Ju
# base_TEs <- dados_plano_trabalho[,c(1, 2, 3, 5, 6, 7, 26, 27, 30, 38)]
# base_TEs <- rename(base_TEs,`Parlamentar`=`nome parlamentar emenda plano acao`,
#                             `Nº Emenda`=`numero emenda parlamentar plano acao`) 
# base_TEs <- base_TEs[, c(1, 2, 9, 7, 8, 3, 4, 5, 6, 10)]
# 
# write.xlsx(base_TEs, "C:\\Users\\M1578465\\Desktop\\API TEs\\Base de dados Transferências Especiais.xlsx", sep = ",", rowNames = FALSE, fileEncoding = "UTF-8", colNames = TRUE, overwrite = TRUE)

#Condicional para enviar o e-mail
if(nrow(TE_em_complementacao)>0){
  
  #Buscando informações dos PTs em complementação
  PT_complementacao <- TE_em_complementacao[,c(1, 2, 21)]
  PT_complementacao <- rename(PT_complementacao,`Parlamentar`=`nome parlamentar emenda plano acao`,
                              `Nº Emenda`=`numero emenda parlamentar plano acao`)  
  #Tratando tabela visualmente
  row.names(PT_complementacao) <- NULL
  
  
  #Criando texto de TE
  assunto <- "PLANO DE TRABALHO TRANSFERENCIAS ESPECIAIS"
  texto1 = "Prezados (as),"
  texto2 = "Identificamos que a situação do(s) Plano(s) de Trabalho proveniente(s) de Transferências Especiais foi alterada para 'Em Complementação' no TransfereGov. Isso indica que o concedente solicitou ajustes no Plano de Trabalho, os quais devem ser atendidos para a continuidade do processo. Dessa forma, solicitamos que acessem o TransfereGov, no módulo de Transferências Especiais, e realizem as alterações necessárias no(s) Plano(s) de Trabalho(s) abaixo:"
  tabela = tableHTML(PT_complementacao)
  #texto3 = "MESMO QUE A(S) PROPOSTA(S) ACIMA TENHA(M) SIDO ANALISADA(S) OU ESTEJA(M) EM ANÁLISE PELO CONCEDENTE, vocês devem nos enviar a pré-qualificação em até 5 dias, conforme o simples passo a passo constante no arquivo anexo.."
  texto4="Ressaltamos que, caso as adequações solicitadas no(s) Plano(s) de Trabalho não sejam realizadas dentro do prazo estabelecido pelo concedente, o órgão/entidade poderá ficar impossibilitado de receber novas indicações de Transferências Especiais"
  
  texto8 = "Esta é uma comunicação automática, gentileza não responder este e-mail. 
Quaisquer dúvidas, entrem em contato pelo e-mail dcgce@casacivil.mg.gov.br"
  
  texto9="Diretoria Central de Gestão de Convênios de Entrada - DCGCE"
  texto10="Superintendência Central de Gestão e Captação de Recursos - SCGCR"
  texto11="Subsecretaria de Relações Institucionais"
  texto12="Secretaria de Estado de Casa Civil - SCC"
  texto13="Governo do Estado de Minas Gerais"
  #texto14 = "Emails dos destinat?rios:"
  
  texto_linha = ""
  html_bod = paste(texto1,texto_linha,texto2,texto_linha,tabela,texto_linha,texto4,texto_linha, texto8,texto_linha,texto_linha,texto9,texto10,texto11,texto12,texto13,texto_linha, texto_linha, sep = "

<br>")
  
  file.exists("C:\\Users\\M1578465\\Desktop\\API TEs\\json.json")
  #json_path <- "C:\\Users\\M1578465\\Desktop\\API TEs\\json.json" #caminho para as credenciais
  #custom_token_cache_dir <- "C:\\Users\\M1578465\\Desktop\\API TEs\\auth_cache"
  
  #options(gargle_oauth_cache = "C:/Users/M1578465/Desktop/API TEs/auth_cache")
  
  gm_auth_configure(path = "C:/Users/M1578465/Desktop/API TEs/json.json")
  
  gm_auth(email = "dcgce.seplag@gmail.com",
          cache = TRUE)
  
  #gargle::gargle_oauth_sitrep()
  
  #token_path <- "C:\\Users\\M1578465\\Desktop\\API TEs\\token.rds"
  #gm_auth(token = gm_token_read(path = token_path))
  #gm_deauth()  # Remove a autenticação atual
  #gm_auth(email = "seuemail@gmail.com", cache = TRUE, new_user = TRUE)
  
  #Criando caminho da base de dados
  file_path <- "C:\\Users\\M1578465\\Desktop\\API TEs\\Base de controle Transferências Especiais.xlsx"
  file.exists(file_path)
  PQ_email <-
    gm_mime() %>%
    gm_to("dcgce@casacivil.mg.gov.br") %>%
    gm_from("dcgce.seplag@gmail.com") %>%
    gm_subject(assunto) %>%
    gm_html_body(html_bod) %>% 
    gm_attach_file(file_path, type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  
  # Verify it looks correct
  #gm_create_draft(PQ_email)
  #gmailr::gm_scopes()
  #gmailr::gm_auth(scopes = "https://www.googleapis.com/auth/gmail.send")
  
  
  # If so, send it
  gm_send_message(PQ_email)
  #gm_create_draft(PQ_email)
  
}else {
  
  #criando texto de "sem Plano de Trabalho em complementação"
  assunto <- "PLANO DE TRABALHO TRANSFERENCIAS ESPECIAIS"
  texto15 <- "Prezados (as)"
  texto16 <- "No momento, nenhum plano de trabalho está com a situação 'Em complementação'"
  texto8 = "Esta é uma comunicação automática, gentileza não responder este e-mail. 
Quaisquer dúvidas, entrem em contato pelo e-mail dcgce@casacivil.mg.gov.br"
  
  texto9="Diretoria Central de Gestão de Convênios de Entrada - DCGCE"
  texto10="Superintendência Central de Gestão e Captação de Recursos - SCGCR"
  texto11="Subsecretaria de Relações Institucionais"
  texto12="Secretaria de Estado de Casa Civil - SCC"
  texto13="Governo do Estado de Minas Gerais"
  texto_linha = ""
  html_bod2 <- paste(texto15, texto_linha, texto16, texto_linha, texto8, texto_linha, texto_linha, texto9, texto10, 
                     texto11, texto12, texto13, texto_linha, texto_linha, sep = "
<br>")
  
  gm_auth_configure(path = "C:/Users/M1578465/Desktop/API TEs/json.json")
  
  gm_auth(email = "dcgce.seplag@gmail.com",
          cache = TRUE)
  file_path <- "C:\\Users\\M1578465\\Desktop\\API TEs\\Base de controle Transferências Especiais.xlsx"
  file.exists(file_path)
  PQ_email2 <- 
    gm_mime() %>%
    gm_to("dcgce@casacivil.mg.gov.br") %>%
    gm_from("dcgce.seplag@gmail.com") %>%
    gm_subject(assunto) %>%
    gm_html_body(html_bod2)
  gm_attach_file(file_path, type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  gm_send_message(PQ_email2)
}
