import subprocess
import os

def rodar():
    os.system('Rscript install.packages("dplyr")')
    os.system('Rscript install.packages("readxl")')
    os.system('Rscript install.packages("writexl")')
    os.system('Rscript install.packages("DBI")')
    os.system('Rscript install.packages("odbc")')
    os.system("Rscript app/db/functions/coleta_de_dados.R")
