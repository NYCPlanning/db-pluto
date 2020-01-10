from dotenv import load_dotenv, find_dotenv
import requests
import os
import json 
import os
import sys
import pandas as pd
from sqlalchemy import create_engine
from multiprocessing import Pool, cpu_count

load_dotenv(find_dotenv())

def ETL(schema_name, version='latest'):
    url=f'{os.environ["GATEWAY"]}/import'
    BUILD_ENGINE=os.environ['BUILD_ENGINE']

    x = requests.post(url, data = json.dumps(
        {'connection': {
            'build_engine': BUILD_ENGINE
            }, 
        'config':{
            'schema_name': schema_name, 
            'version': version
            }
        }))
    print(f'{schema_name} {x.text}')

if __name__ == "__main__":
    con = create_engine(os.getenv('BUILD_ENGINE'))
    os.system('echo "loading pluto_input_research ..."')
    df = pd.read_csv('https://raw.githubusercontent.com/NYCPlanning/db-pluto/future/pluto_build/data/pluto_input_research.csv', 
                        index_col=False, dtype=str)
    df.columns = [i.lower() for i in df.columns]
    df.to_sql(con=con, name='pluto_input_research', 
                if_exists='replace', index=False)
    
    os.system('echo "loading pluto_corrections ..."')
    df = pd.read_csv('https://raw.githubusercontent.com/NYCPlanning/db-pluto/future/pluto_build/output/pluto_corrections.csv', 
                        index_col=False, dtype=str)
    df.columns = [i.lower() for i in df.columns]
    df.to_sql(con=con, name='pluto_corrections', 
                if_exists='replace', index=False)

    tables = ['dcp_edesignation', 
            'dcas_facilities_colp', 
            'lpc_historic_districts', 
            'lpc_landmarks', 

            # for spatial joins
            'dcp_cdboundaries', 
            'dcp_censustracts', 
            'dcp_censusblocks', 
            'dcp_school_districts', 
            'dcp_councildistricts', 
            'doitt_zipcodeboundaries', 
            'dcp_firecompanies', 
            'dcp_policeprecincts', 
            'dcp_healthareas', 
            'dcp_healthcenters', 
            'dsny_frequencies', 
            'dcp_pluto', 
            'dcp_mappluto', 

            # Other_datasets - PULLING FROM FTP or PLUTO GitHub repo
            'dcp_zoning_maxfar', 
            'pluto_input_bsmtcode', 
            'pluto_input_landuse_bldgclass', 
            'pluto_input_condo_bldgclass', 
            'pluto_pts', 
            'pluto_input_geocodes',

             # raw CAMA data from DOF
            'pluto_input_cama_dof', 

            # raw Digital Tax Map from DOF
            'dof_dtm', 

            # raw NYC shoreline file from DOF
            'dof_shoreline', 

            # raw DOF condo table
            'dof_condo', 

            # DCP zoning datasets~
            'dcp_commercialoverlay', 
            'dcp_limitedheight', 
            'dcp_zoningdistricts', 
            'dcp_specialpurpose', 
            'dcp_specialpurposesubdistricts', 
            'dcp_zoningmapamendments', 
            'dcp_zoningmapindex', 

            # FEMA 2007 and preliminary 2015 100 year flood zones 
            'fema_firms2007_100yr', 
            'fema_pfirms2015_100yr', 
            'pluto_input_condolot_descriptiveattributes']

    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, tables)