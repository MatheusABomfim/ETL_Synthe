library(readr)
library (dplyr)

# Diretório onde estão os arquivos CSV
pasta <- "D:/Documentos/Startup/synthea_sample_data_csv_latest/"

# Dicionário dos datasets, com infos clínicas de acordo com o SNOMED-CT
#https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary

# Lista todos os arquivos CSV no diretório
arquivos <- list.files(path = pasta, pattern = "\\.csv$", full.names = TRUE)

# Extrai o nome base dos arquivos (sem extensão)
nomes <- tools::file_path_sans_ext(basename(arquivos))

# Lê os arquivos e armazena em uma lista nomeada
lista_dfs <- setNames(lapply(arquivos, read.csv), nomes)

# Extrair informações por dataset do lista_dfs, seguindo da compilação em um df 
# careplans:
head(lista_dfs[["careplans"]], n = 10)

df_ellion_careplans <- lista_dfs[["careplans"]] %>%
  select(Id, START, STOP, PATIENT, ENCOUNTER, CODE, DESCRIPTION)

df_ellion_careplans <- df_ellion_careplans %>%
  rename_with(~ paste0(., "_careplansDataSet"))

# claims:
head(lista_dfs[["claims"]], n = 10)

df_ellion_claims <- lista_dfs[["claims"]] %>%
  select(Id, PATIENTID, PROVIDERID, PATIENTDEPARTMENTID,
         DIAGNOSIS1, DIAGNOSIS2, DIAGNOSIS3, DIAGNOSIS4, 
         DIAGNOSIS5, DIAGNOSIS6, DIAGNOSIS7, DIAGNOSIS8,
         CURRENTILLNESSDATE, STATUS1, OUTSTANDINGP, HEALTHCARECLAIMTYPEID1)

df_ellion_claims <- df_ellion_claims %>%
  rename_with(~ paste0(., "_claimsDataSet"))

# claims_Transactions:
head(lista_dfs[["claims_transactions"]], n = 10)

df_ellion_claims_transactions <- lista_dfs[["claims_transactions"]] %>%
  select(ID, PATIENTID, TYPE, AMOUNT,
         METHOD, PROCEDURECODE, DEPARTMENTID, NOTES)

df_ellion_claims_transactions <- df_ellion_claims_transactions %>%
  rename_with(~ paste0(., "_claims_transactionDataSet"))

# conditions:
head(lista_dfs[["conditions"]], n = 10)

df_ellion_conditions <- lista_dfs[["conditions"]] %>%
  select(START, STOP, PATIENT, CODE, DESCRIPTION)

df_ellion_conditions<- df_ellion_conditions %>%
  rename_with(~ paste0(., "_conditionsDataSet"))

# encounters:
head(lista_dfs[["conditions"]], n = 10)

df_ellion_conditions <- lista_dfs[["conditions"]] %>%
  select(START, STOP, PATIENT, CODE, DESCRIPTION)

df_ellion_conditions<- df_ellion_conditions %>%
  rename_with(~ paste0(., "_conditionsDataSet"))

# encounters:
head(lista_dfs[["encounters"]], n = 10)

df_ellion_encounters <- lista_dfs[["encounters"]] %>%
  select(Id, START, STOP, PATIENT, PROVIDER,
         PAYER, ENCOUNTERCLASS, CODE, DESCRIPTION, 
         TOTAL_CLAIM_COST, PAYER_COVERAGE)

df_ellion_encounters<- df_ellion_encounters %>%
  rename_with(~ paste0(., "_encountersDataSet"))

# medications:
head(lista_dfs[["medications"]], n = 10)

df_ellion_medications <- lista_dfs[["medications"]] %>%
  select(START, STOP, PATIENT,PAYER, ENCOUNTER,
         CODE, DESCRIPTION, BASE_COST, PAYER_COVERAGE,
         DISPENSES, TOTALCOST)

df_ellion_medications<- df_ellion_medications %>%
  rename_with(~ paste0(., "_medicationsDataSet"))

# observations:
head(lista_dfs[["observations"]], n = 10)

df_ellion_observations <- lista_dfs[["observations"]] %>%
  select(PATIENT, ENCOUNTER, CODE, DESCRIPTION)

df_ellion_observations<- df_ellion_observations %>%
  rename_with(~ paste0(., "_observationsDataSet"))

# patients:
head(lista_dfs[["patients"]], n = 10)

df_ellion_patients <- lista_dfs[["patients"]] %>%
  select(Id, BIRTHDATE, DEATHDATE, SSN, PREFIX, FIRST, LAST,
         GENDER, CITY, STATE, ZIP)

df_ellion_patients<- df_ellion_patients %>%
  rename_with(~ paste0(., "_patientsDataSet"))

# organizations:
head(lista_dfs[["organizations"]], n = 10)

df_ellion_organizations <- lista_dfs[["organizations"]] %>%
  select(Id, NAME, ADDRESS, CITY, STATE, ZIP, PHONE)

df_ellion_organizations<- df_ellion_organizations %>%
  rename_with(~ paste0(., "_organizationsDataSet"))

# payers:
head(lista_dfs[["payers"]], n = 10)

df_ellion_payers <- lista_dfs[["payers"]] %>%
  select(Id, NAME, OWNERSHIP, AMOUNT_COVERED, AMOUNT_UNCOVERED,
         COVERED_ENCOUNTERS, UNCOVERED_ENCOUNTERS, COVERED_MEDICATIONS, 
         UNCOVERED_MEDICATIONS, COVERED_PROCEDURES, UNCOVERED_MEDICATIONS)

df_ellion_payers<- df_ellion_payers %>%
  rename_with(~ paste0(., "_payersDataSet"))

# procedures:
head(lista_dfs[["procedures"]], n = 10)

df_ellion_procedures <- lista_dfs[["procedures"]] %>%
  select(START, STOP, PATIENT, ENCOUNTER, CODE, DESCRIPTION)

df_ellion_procedures<- df_ellion_procedures %>%
  rename_with(~ paste0(., "_proceduresDataSet"))

# providers:
head(lista_dfs[["providers"]], n = 10)

df_ellion_providers <- lista_dfs[["providers"]] %>%
  select(Id, ORGANIZATION, NAME, SPECIALITY, ZIP, ENCOUNTERS, PROCEDURES)

df_ellion_providers<- df_ellion_providers %>%
  rename_with(~ paste0(., "_providersDataSet"))

# União dos dataframeso (Uni_Df)
uni_df <- ls(pattern = "^df_ellion_")
lista_uni_dfs <- mget(uni_df)
df_unificado <- bind_rows(lista_uni_dfs)

## Exportação dos DFs
# 1. Listar objetos e excluir alguns
todos_objetos <- ls()
objetos_para_exportar <- setdiff(todos_objetos, c("lista_dfs", "lista_uni_dfs"))

# 2. Filtrar dataframes
is_df <- function(obj_name) {
  is.data.frame(get(obj_name))
}
dfs_para_exportar <- objetos_para_exportar[sapply(objetos_para_exportar, is_df)]

# 3. Definir pasta de saída
diretorio_saida <- "D:\\Documentos\\Startup"  # Altere para o diretório desejado
if(!dir.exists(diretorio_saida)) {
  dir.create(diretorio_saida, recursive = TRUE)
}

# 4. Exportar os dataframes
for(nome_df in dfs_para_exportar) {
  df <- get(nome_df)
  caminho_arquivo <- file.path(diretorio_saida, paste0(nome_df, ".csv"))
  write.csv(df, file = caminho_arquivo, row.names = FALSE)
  message(paste("Exportado:", caminho_arquivo))
}


                                 