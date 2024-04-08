import subprocess
import os
import pandas as pd 

def retornar_maior_data(dados: pd.DataFrame) -> pd.to_datetime:
    data = dados.loc[:, ["DATA"]].max()[0]
    try:
        data = pd.to_datetime(data).strftime("%d/%m/%Y às %H:%M")
    except:
        data = "Não foi possível identificar"
    return data

def retornar_maior_data_blend(dados: pd.DataFrame) -> pd.to_datetime:
    data = dados.loc[:, ["DataInicio"]].max()[0]
    try:
        data = pd.to_datetime(data).strftime("%d/%m/%Y às %H:%M")
    except:
        data = "Não foi possível verificar"
    return data

def retornar_maior_data_reagentes(dados: pd.DataFrame) -> pd.to_datetime:
    dados["Unnamed: 0"].iloc[5:] = pd.to_datetime(dados["Unnamed: 0"].iloc[5:])

    index = dados["Unnamed: 0"].iloc[5:].idxmax()

    dados = dados.iloc[index]

    data, hora = dados["Unnamed: 0"], dados["Unnamed: 1"]

    data = pd.to_datetime(data).strftime("%d/%m/%Y")
    hora = str(hora)[0:5]
    # .strftime("%d/%m/%Y")
    return f"{data} às {hora}"

def rodar():
    subprocess.run(["Rscript", 'app/db/functions/coleta_de_dados.R'])
    with open("infos.txt", "w+") as arq:
        data_lab = pd.read_excel("app/data/01_raw_data/laboratorio.xlsx")
        data_lab_rx = pd.read_excel("app/data/01_raw_data/laboratorio_raiox.xlsx")
        data_blend = pd.read_excel("app/data/01_raw_data/blend.xlsx")
        data_balanco_massa = pd.read_excel("app/data/01_raw_data/balanco_de_massas.xlsx")
        data_carta_controle = pd.read_excel("app/data/01_raw_data/carta_controle_pims.xlsx")
        data_reagentes = pd.read_excel("app/data/01_raw_data/reagentes.xlsx")

        date_lab = retornar_maior_data(data_lab)
        date_lab_rx = retornar_maior_data(data_lab_rx)
        date_blend = retornar_maior_data_blend(data_blend)
        date_balanco = retornar_maior_data(data_balanco_massa)
        date_carta_controle = retornar_maior_data(data_carta_controle)
        date_reagentes = retornar_maior_data_reagentes(data_reagentes)

        arq.write(f"{date_lab}\n")
        arq.write(f"{date_lab_rx}\n")
        arq.write(f"{date_blend}\n")
        arq.write(f"{date_balanco}\n")
        arq.write(f"{date_carta_controle}\n")
        arq.write(f"{date_reagentes}\n")
