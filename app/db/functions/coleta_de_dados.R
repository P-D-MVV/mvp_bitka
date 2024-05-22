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

# url <- paste("DRIVER={{ODBC Driver 17 for SQL Server}};SERVER="server";DATABASE="database";UID="username";PWD="password"; TrustedConnection = yes")
# con <- dbConnect(odbc::odbc(), .connection_string = url, timeout=6000)
# Ler a tabela do banco de dados
laboratorio <- dbReadTable(con, "LABORATORIO")
laboratorio_raiox <- dbReadTable(con, "LABORATORIO_RAIOX")
carta_controle_pims <- dbReadTable(con, "CARTA_CONTROLE_PIMS")
balanco_de_massas <- dbReadTable(con, "BALANCO_DE_MASSAS")
################
reagentes <- dbGetQuery(con, "SELECT DATA, CAL_MOINHO AS MOAGEM, CAL_CD AS CAL_CD, CAL_PB_12 AS [ALM. CHG], CAL_PB_03 AS [ALM. CL1], CAL_PB_06 AS [ALM. CL2], ESPUMANTE_CD AS ESPUMANTE_CD, ESPUMANTE_FC_001 AS FC-01, ESPUMANTE_FC_002 AS FC-02, ESPUMANTE_FC_003 AS FC-03, ESPUMANTE_FC_004 AS FC-04, ESPUMANTE_FC_005 AS FC-05, ESPUMANTE_FC_006 AS FC-06, ESPUMANTE_PB_03 AS [ALM.CL1], ESPUMANTE_PB_06 AS [ALM-CL2], ESPUMANTE_PB_05 AS [ALM-SCV], COLETOR_1_CD, COLETOR_1_FC_001, COLETOR_1_FC_002, COLETOR_1_FC_003, COLETOR_1_FC_004, COLETOR_1_FC_005, COLETOR_1_FC_006, COLETOR_1_PB_12 AS [COLETOR_1_ALM. CHG], COLETOR_1_PB_03 AS [COLETOR_1_ALM-CL2], COLETOR_1_PB_06 AS [COLETOR_1_ALM-SCV], COLETOR_2_MOINHO AS 2202-PB-001, COLETOR_2_FC_001, COLETOR_2_FC_002, COLETOR_2_FC_003, COLETOR_2_FC_004, COLETOR_2_FC_005, COLETOR_2_FC_006, COLETOR_2_PB_03, COLETOR_2_PB_06, COLETOR_2_PB_05, COLETOR_2_MOINHO AS [UNDER CY], CMC_CD, CMC_PB_03, CMC_PB_06, CMC_PB_05, FLOCULANTE_ESPESSADOR_CONC, FLOCULANTE_ESPESSADOR_REJ FROM CONTROLE_PROCESSOS")
################
dbDisconnect(con)


################################################################################

### TRATAMENTO DE DADOS 
################################################################################

laboratorio$DATA <- as.POSIXct(laboratorio$DATA, format = "%Y-%m-%d %H:%M")
laboratorio <- laboratorio[laboratorio$DATA >= "2023-06-01 00:00:00.000",]

laboratorio_raiox$DATA <- as.POSIXct(laboratorio_raiox$DATA, format = "%Y-%m-%d %H:%M")
laboratorio_raiox <- laboratorio_raiox[laboratorio_raiox$DATA >= "2023-06-01 00:00:00.000",]

carta_controle_pims$DATA <- as.POSIXct(carta_controle_pims$DATA, format = "%Y-%m-%d %H:%M")
carta_controle_pims <- carta_controle_pims[carta_controle_pims$DATA >= "2023-06-01 00:00:00.000",]

balanco_de_massas$DATA <- as.POSIXct(balanco_de_massas$DATA, format = "%Y-%m-%d %H:%M")
balanco_de_massas <- balanco_de_massas[balanco_de_massas$DATA >= "2023-06-01 00:00:00.000",]

writexl::write_xlsx(laboratorio, 'app/data/01_raw_data/laboratorio.xlsx')
writexl::write_xlsx(laboratorio_raiox, 'app/data/01_raw_data/laboratorio_raiox.xlsx')
writexl::write_xlsx(carta_controle_pims, 'app/data/01_raw_data/carta_controle_pims.xlsx')
writexl::write_xlsx(balanco_de_massas, 'app/data/01_raw_data/balanco_de_massas.xlsx')

writexl::write_xlsx(laboratorio, 'data/01_raw_data/laboratorio.xlsx')
writexl::write_xlsx(laboratorio_raiox, 'data/01_raw_data/laboratorio_raiox.xlsx')
writexl::write_xlsx(carta_controle_pims, 'data/01_raw_data/carta_controle_pims.xlsx')
writexl::write_xlsx(balanco_de_massas, 'data/01_raw_data/balanco_de_massas.xlsx')

#########
writexl::write_xlsx(reagentes, "app/data/01_raw_data/reagentes_pre.xlsx")
writexl::write_xlsx(reagentes, "data/01_raw_data/reagentes_pre.xlsx")
#########

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
DataFi <- format(DataFinal, "%Y/%m/%d")
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

blend <- blend[blend$Destino_Area_CM == "BRITADOR",]
writexl::write_xlsx(blend, 'app/data/01_raw_data/blend.xlsx')
writexl::write_xlsx(blend, 'data/01_raw_data/blend.xlsx')








