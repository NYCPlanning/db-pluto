from sql import mismatch_sql, aggregate_sql, null_sql
from sqlalchemy import create_engine
import os

def run_mismatch(v1, v2, engine, condo):
    if condo == 'TRUE':
            sql = mismatch_sql.format(v1, v2, condo, "WHERE right(bbl, 4) LIKE '75%%'")
    else:
        sql = mismatch_sql.format(v1, v2, condo, '')

    engine.execute(f'''
        DELETE FROM dcp_pluto.qaqc_mismatch WHERE pair = '{v1} - {v2}' AND CONDO::boolean = {condo}; 
        {sql};
    ''')

def run_null(v, engine, condo):
    # Finalize SQL query
    if condo == 'TRUE':
        sql = null_sql.format(v, condo, "WHERE right(bbl, 4) LIKE '75%%'")
    else:
        sql = null_sql.format(v, condo, '')
    
    engine.execute(f'''
    DELETE FROM dcp_pluto.qaqc_null WHERE v = '{v}' AND CONDO::boolean = {condo}; 
    {sql};
    ''')

def run_aggregate(v, engine, condo): 
    # Finalize SQL query
    if condo == 'TRUE':
        sql = aggregate_sql.format(v, condo, "WHERE right(bbl, 4) LIKE '75%%'")
    else:
        sql = aggregate_sql.format(v, condo, '')
    
    engine.execute(f'''
    DELETE FROM dcp_pluto.qaqc_aggregate WHERE v = '{v}' AND CONDO::boolean = {condo}; 
    {sql};
    ''')

if __name__ == "__main__":
    EDM_DATA = os.environ.get('EDM_DATA', '')
    engine = create_engine(EDM_DATA)

    v1 = os.environ.get('VERSION', '')
    v2 = os.environ.get('VERSION_PREV', '')

    # For all
    run_mismatch(v1, v2, engine, condo='FALSE')
    run_aggregate(v1, engine, condo='FALSE')
    run_null(v1, engine, condo='FALSE')

    # For condo
    run_mismatch(v1, v2, engine, condo='TRUE')
    run_aggregate(v1, engine, condo='TRUE')
    run_null(v1, engine, condo='TRUE')