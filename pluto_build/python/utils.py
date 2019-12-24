import requests
import os
import json
from sqlalchemy import create_engine
from datetime import datetime
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

def ARCHIVE(dst_schema_name, 
            dst_version,
            src_version, 
            src_schema_name='public'):

    url = f'{os.environ["GATEWAY"]}/migrate'
    EDM_DATA = os.environ['EDM_DATA']
    BUILD_ENGINE = os.environ['BUILD_ENGINE']

    x = requests.post(url, json = 
                    {"src_engine": f"{BUILD_ENGINE}",
                    "dst_engine": f"{EDM_DATA}",
                    "src_schema_name": f"{src_schema_name}",
                    "dst_schema_name": f"{dst_schema_name}",
                    "src_version": f"{src_version}",
                    "dst_version": f"{dst_version}"})

    r = json.loads(x.text)
    if r['status'] == 'success':
        print(f'{src_schema_name}.{src_version} is loaded to {dst_schema_name}.{dst_version}...')
        CREATE_VIEW(EDM_DATA, 
            r['config']['dst_schema_name'], 
            r['config']['dst_version'])
    else: 
        print(f'{src_schema_name}.{src_version} failed to load ...')

def CREATE_VIEW(engine, schema_name, version):
    con = create_engine(engine)
    con.execute(f'DROP VIEW IF EXISTS {schema_name}.latest;')
    con.execute(f'CREATE VIEW {schema_name}.latest as (SELECT * from {schema_name}."{version}");')
    print(f'{schema_name}.{version} is tagged as latest ...')

VERSION = os.environ.get('VERSION', datetime.today().strftime("%Y/%m/%d"))