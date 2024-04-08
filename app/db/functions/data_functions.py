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

def atualizar_datas():
    url = "app/data/01_raw_data/"

    lab = pd.read_excel(url + "laboratorio.xlsx")
    labrx = pd.read_excel(url + "laboratorio_raiox.xlsx")
    blend = pd.read_excel(url + "blend.xlsx")
    balanco = pd.read_excel(url + "balanco_de_massas.xlsx")
    carta = pd.read_excel(url + "carta_controle_pims.xlsx")
    reagentes = pd.read_excel(url + "reagentes.xlsx")

    date_lab = retornar_maior_data(lab)
    date_lab_rx = retornar_maior_data(labrx)
    date_blend = retornar_maior_data_blend(blend)
    date_balanco = retornar_maior_data(balanco)
    date_carta_controle = retornar_maior_data(carta)
    date_reagentes = retornar_maior_data_reagentes(reagentes)

    with open("infos.txt", "w") as arq:
        arq.write(date_lab)
        arq.write("\n")
        arq.write(date_lab_rx)
        arq.write("\n")
        arq.write(date_blend)
        arq.write("\n")
        arq.write(date_balanco)
        arq.write("\n")
        arq.write(date_carta_controle)
        arq.write("\n")
        arq.write(date_reagentes)
        arq.write("\n")