import subprocess
import os

def rodar():
    # os.system('Rscript install.packages("dplyr")')
    # os.system('Rscript install.packages("readxl")')
    # os.system('Rscript install.packages("writexl")')
    # os.system('Rscript install.packages("DBI")')
    # os.system('Rscript install.packages("odbc")')
    # os.system("Rscript app/db/functions/coleta_de_dados.R")
    subprocess.run(["Rscript", 'install.packages("dplyr")'])
    subprocess.run(["Rscript", 'install.packages("readxl")'])
    subprocess.run(["Rscript", 'install.packages("writexl")'])
    subprocess.run(["Rscript", 'install.packages("DBI")'])
    subprocess.run(["Rscript", 'install.packages("odbc")'])
    subprocess.run(["Rscript", 'app/db/functions/coleta_de_dados.R'])
