library(dplyr)
library(readxl)
library(DBI)
library(odbc)

# Definir as credenciais de conexão

server <- "srt-srv-04\\serrotedbprd"
database <- "PCP_PLANTA"
username <- "pcp.planta"
password <- "Planta@pcp2021"

# Criar a string de conexão
con <- dbConnect(odbc::odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = server,
                 Database = database,
                 UID = username,
                 PWD = password)

# Ler a tabela do banco de dados
laboratorio <- dbReadTable(con, "LABORATORIO")
laboratorio_raiox <- dbReadTable(con, "LABORATORIO_RAIOX")
carta_controle_pims <- dbReadTable(con, "CARTA_CONTROLE_PIMS")
balanco_de_massas <- dbReadTable(con, "BALANCO_DE_MASSAS")
# Visualizar os dados da tabela
# print(laboratorio)

# Fechar a conexão com o banco de dados
dbDisconnect(con)


################################################################################

### TRATAMENTO DE DADOS 
################################################################################

laboratorio$DATA <- as.POSIXct(laboratorio$DATA, format = "%Y-%m-%d %H:%M")
laboratorio<-laboratorio[laboratorio$DATA >= "2023-06-01 00:00:00.000",]


laboratorio_raiox$DATA <- as.POSIXct(laboratorio_raiox$DATA, format = "%Y-%m-%d %H:%M")
laboratorio_raiox<-laboratorio_raiox[laboratorio_raiox$DATA >= "2023-06-01 00:00:00.000",]


carta_controle_pims$DATA <- as.POSIXct(carta_controle_pims$DATA, format = "%Y-%m-%d %H:%M")
carta_controle_pims<-carta_controle_pims[carta_controle_pims$DATA >= "2023-06-01 00:00:00.000",]


carta_controle_pims$DATA <- as.POSIXct(carta_controle_pims$DATA, format = "%Y-%m-%d %H:%M")
carta_controle_pims<-carta_controle_pims[carta_controle_pims$DATA >= "2023-06-01 00:00:00.000",]


balanco_de_massas$DATA <- as.POSIXct(balanco_de_massas$DATA, format = "%Y-%m-%d %H:%M")
balanco_de_massas<-balanco_de_massas[balanco_de_massas$DATA >= "2023-06-01 00:00:00.000",]


writexl::write_xlsx(laboratorio, 'app/data/01_raw_data/laboratorio.xlsx')
writexl::write_xlsx(laboratorio_raiox, 'app/data/01_raw_data/laboratorio_raiox.xlsx')
writexl::write_xlsx(carta_controle_pims, 'app/data/01_raw_data/carta_controle_pims.xlsx')
writexl::write_xlsx(balanco_de_massas, 'app/data/01_raw_data/balanco_de_massas.xlsx')

writexl::write_xlsx(laboratorio, 'data/01_raw_data/laboratorio.xlsx')
writexl::write_xlsx(laboratorio_raiox, 'data/01_raw_data/laboratorio_raiox.xlsx')
writexl::write_xlsx(carta_controle_pims, 'data/01_raw_data/carta_controle_pims.xlsx')
writexl::write_xlsx(balanco_de_massas, 'data/01_raw_data/balanco_de_massas.xlsx')


# Instale e carregue a biblioteca odbc se ainda não estiver instalada
# install.packages("odbc")
library(odbc)

# Crie uma conexão com o banco de dados
con <- dbConnect(odbc::odbc(), 
                 driver = "ODBC Driver 17 for SQL Server",  # Substitua pelo nome do driver adequado
                 server = "192.168.5.249",
                 database = "mining_control_mvv",
                 uid = "user_bi",
                 pwd = "rXV7aWUd4Uq9yWpW")

# Defina os parâmetros
DataIn <- '2023-06-01'
# DataFi <- '2024-03-04'
DataFinal <- Sys.Date()
DataFi <- format(DataFinal, "%d/%m/%Y")
ListEquips <- '1,2,3'  # Substitua pelos IDs reais dos equipamentos

# Crie a consulta SQL
sql_query <- paste("EXECUTE [dbo].[rpt_qualidade_movimentacao_detalhada]",
                   "@DataIn = '", DataIn, "',",
                   "@DataFi = '", DataFi, "',",
                   "@ListEquips = '", ListEquips, "'")

# Execute a consulta
blend <- dbGetQuery(con, sql_query)

# Feche a conexão
dbDisconnect(con)

# Exiba o resultado
# print(blend)

blend<-blend[blend$Destino_Area_CM == "BRITADOR",]
writexl::write_xlsx(blend, 'app/data/01_raw_data/blend.xlsx')
writexl::write_xlsx(blend, 'data/01_raw_data/blend.xlsx')
