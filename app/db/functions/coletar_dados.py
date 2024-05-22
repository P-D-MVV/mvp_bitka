import pandas as pd
import pyodbc
import datetime as dt
import os 

def adequar_reagentes():
    reagentes = pd.read_excel("app/data/01_raw_data/reagentes_pre.xlsx")
    colunas = [c for c in reagentes.columns.values]
    reagentes["DATA_HORA"] = pd.to_datetime(reagentes["DATA_HORA"])
    reagentes["DATA"] = reagentes["DATA_HORA"].dt.date
    reagentes["Horário"] = reagentes["DATA_HORA"].dt.time
    n_colunas = ["DATA", "Horário"] + colunas
    reagentes = reagentes[n_colunas]
    reagentes = reagentes.drop("DATA_HORA", axis=1)

    reagentes.to_excel("app/data/01_raw_data/reagentes_dados.xlsx", header=None, index=None)

    modelo_reagentes = pd.read_excel("app/data/01_raw_data/modelo_reagentes.xlsx", header=None)
    reagentes = pd.read_excel("app/data/01_raw_data/reagentes_dados.xlsx", header=None)

    df = pd.concat([modelo_reagentes, reagentes], axis=0, ignore_index=True)
    df.to_excel("app/data/01_raw_data/reagentes.xlsx", index=False, header=None)

