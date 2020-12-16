from multiprocessing import Pool, cpu_count
from utils.exporter import exporter
from geosupport import Geosupport, GeosupportError
import requests
from sqlalchemy import create_engine
from datetime import datetime
import pandas as pd
import json
import os
import requests
from io import StringIO

g = Geosupport()
engine = create_engine(os.getenv("RECIPE_ENGINE"))

def get_bbl(inputs):
    BIN = inputs["bin"]
    try:
        geo = g["BN"](bin=BIN)
    except GeosupportError as e1:
        try:
            geo = g["BN"](bin=BIN, mode="tpad")
        except GeosupportError as e2:
            geo = e2.result

    bbl = geo["BOROUGH BLOCK LOT (BBL)"]["BOROUGH BLOCK LOT (BBL)"]
    return {"bin": BIN, "bbl": bbl}

def get_bins():
    # https://data.cityofnewyork.us/Housing-Development/Building-Footprints/nqwf-w8eh
    url='https://data.cityofnewyork.us/resource/isce-xy3b.csv'
    headers = {'X-App-Token':os.environ['API_TOKEN']}
    params = {
                '$select':'bin', 
                '$limit':5000000000000
            }
    r = requests.get(f"{url}", headers=headers, params=params)
    return pd.read_csv(StringIO(r.text), index_col=False, dtype=str)

if __name__ == "__main__":
    df = get_bins()
    v = datetime.today().strftime("%Y/%m/%d")

    with Pool(processes=cpu_count()) as pool:
        it = pool.map(get_bbl, df.to_dict("records"), 100000)

    dff = pd.DataFrame(it)
    table_name = f'pluto_input_numbldgs."{v}"'
    exporter(dff, table_name, con=engine, sep="~", null="")
    
    engine.execute(f"""DROP VIEW IF EXISTS pluto_input_numbldgs.latest;""")
    engine.execute(
        f"""CREATE VIEW pluto_input_numbldgs.latest as (
                        SELECT '{v}' as v, bbl, count(*) 
                        FROM {table_name}
                        WHERE bbl IS NOT NULL
                        GROUP BY bbl);"""
    )
