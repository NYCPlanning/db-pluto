from multiprocessing import Pool, cpu_count
from utils.exporter import exporter
from geosupport import Geosupport, GeosupportError
from sqlalchemy import create_engine
from datetime import date
import pandas as pd
import json
import os 

g = Geosupport()
engine = create_engine(os.getenv('RECIPE_ENGINE'))

def get_address(bbl):
    try:
        geo = g['BL'](bbl=bbl)
        addresses = geo.get('LIST OF GEOGRAPHIC IDENTIFIERS', '')
        filter_addresses = [d for d in addresses if d['Low House Number'] != '' and d['5-Digit Street Code'] != '']
        address = filter_addresses[0]
        b5sc = address.get('Borough Code', '0')+address.get('5-Digit Street Code', '00000')
        sname = get_sname(b5sc)
        numberOfExistingStructures = geo.get('Number of Existing Structures on Lot', '')
        hnum = address.get('Low House Number', '')
        return dict(sname=sname, hnum=hnum, numberOfExistingStructures=numberOfExistingStructures)
    except:
        return dict(sname='', hnum='', numberOfExistingStructures='')

def get_sname(b5sc): 
    try:
        geo = g['D'](B5SC=b5sc)
        return geo.get('First Street Name Normalized', '')
    except:
        return ''

def geocode(inputs):
    boro = inputs.pop('boro')
    block = inputs.pop('block')
    lot = inputs.pop('lot') 
    ease = ''

    bbl = boro+block+lot
    address = get_address(bbl)

    sname = address.get('sname', '')
    hnum = address.get('hnum', '')
    numberOfExistingStructures = address.get('numberOfExistingStructures', '')
    borough = boro

    try: 
        geo1 = g['1A'](street_name=sname, house_number=hnum, borough=borough, mode='regular')
        geo2 = g['1E'](street_name=sname, house_number=hnum, borough=borough, mode='regular')
        geo = {**geo1, **geo2}
        geo = parse_output(geo)
        geo.update(borough = borough, block = block, lot = lot, 
                    easement = ease, input_hnum=hnum, input_sname=sname, 
                    numberOfExistingStructures=numberOfExistingStructures)
        return geo
    except GeosupportError: 
        try: 
            geo = g['1B'](street_name=sname, house_number=hnum, borough=borough, mode='regular')
            geo = parse_output(geo)
            geo.update(borough = borough, block = block, lot = lot, 
                        easement = ease, input_hnum=hnum, input_sname=sname,
                        numberOfExistingStructures=numberOfExistingStructures)
            return geo
        except GeosupportError as e1:
            try:
                geo = g['BL'](bbl=bbl)
                geo = parse_output(geo)
                geo.update(borough = borough, block = block, lot = lot, 
                            easement = ease, input_hnum=hnum, input_sname=sname,
                            numberOfExistingStructures=numberOfExistingStructures)
                return geo
            except GeosupportError as e2:
                geo = parse_output(e1.result)
                geo.update(borough = borough, block = block, lot = lot, 
                            easement = ease, input_hnum=hnum, input_sname=sname,
                            numberOfExistingStructures=numberOfExistingStructures)
                return geo

def parse_output(geo):
    return dict(
        billingbbl = geo.get('Condominium Billing BBL', ''),
        bbl = geo.get('BOROUGH BLOCK LOT (BBL)', '').get('BOROUGH BLOCK LOT (BBL)', ''),
        communityDistrict = geo.get('COMMUNITY DISTRICT', {}).get('COMMUNITY DISTRICT', ''),
        censusTract2010 = geo.get('2010 Census Tract', ''),
        censusBlock2010 = geo.get('2010 Census Block', ''),
        communitySchoolDistrict = geo.get('Community School District', ''),
        cityCouncilDistrict = geo.get('City Council District', ''),
        zipCode = geo.get('ZIP Code', ''),
        
        fireCompanyNumber = geo.get('Fire Company Type', '')+\
                            geo.get('Fire Company Number', ''), # e.g E219
        
        policePrecinct = geo.get('Police Precinct', ''),
        healthCenterDistrict = geo.get('Health Center District', ''),
        healthArea = geo.get('Health Area', ''),
        sanitationDistrict = geo.get('Sanitation District', ''),
        sanitationCollectionScheduling = geo.get('Sanitation Collection Scheduling Section and Subsection', ''),
        boePreferredStreetName = geo.get('BOE Preferred Street Name', ''),
        # numberOfExistingStructures = geo.get('Number of Existing Structures on Lot', ''),
        taxMapNumberSectionAndVolume = geo.get('Tax Map Number Section & Volume', ''),
        sanbornMapIdentifier = geo.get('SBVP (SANBORN MAP IDENTIFIER)', {}).get('SBVP (SANBORN MAP IDENTIFIER)', ''),

        latitude = geo.get('Latitude', ''),
        longitude = geo.get('Longitude', ''),
        XCoord = '',
        YCoord = '', 
        grc = geo.get('Geosupport Return Code (GRC)', ''), 
        grc2 = geo.get('Geosupport Return Code 2 (GRC 2)', ''),
        msg = geo.get('Message', ''),
        msg2 = geo.get('Message 2', ''),
    )

if __name__ == '__main__':
    df = pd.read_sql('''SELECT DISTINCT ON (boro, block, lot) boro, block, lot 
                        from pluto_pts.latest''',
                    con=engine)
    # get the row number
    records = df.to_dict('records')
    
    print('geocoding begins here ...')
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 100000)
    
    print('geocoding finished ...')
    result = pd.DataFrame(it)
    print(result.head())

    table_name = f'pluto_input_geocodes.\"{date.today().strftime("%Y/%m/%d")}\"'
    exporter(result, table_name, con=engine, sep='~', null='')

    engine.execute(f'''
        ALTER TABLE {table_name}
            ADD wkb_geometry geometry(Geometry,4326);

        UPDATE {table_name}
        SET wkb_geometry = ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION,
                            latitude::DOUBLE PRECISION), 4326),
            xcoord = ST_X(ST_TRANSFORM(wkb_geometry, 2263)),
            ycoord = ST_Y(ST_TRANSFORM(wkb_geometry, 2263));
    ''')
    engine.execute(f'''DROP VIEW IF EXISTS pluto_input_geocodes.latest CASCADE;''')
    engine.execute(f'''CREATE VIEW pluto_input_geocodes.latest as (
                        SELECT '{date.today().strftime("%Y/%m/%d")}' as v, * 
                        FROM {table_name};''')