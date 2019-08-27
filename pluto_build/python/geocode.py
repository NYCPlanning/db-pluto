from multiprocessing import Pool, cpu_count
from geosupport import Geosupport, GeosupportError
from sqlalchemy import create_engine
import pandas as pd
import json
import os 

g = Geosupport()

def get_address(bbl):
    try:
        geo = g['BL'](bbl=bbl)
        addresses = geo.get('LIST OF GEOGRAPHIC IDENTIFIERS', '')
        filter_addresses = [d for d in addresses if d['Low House Number'] != '' and d['5-Digit Street Code'] != '']
        address = filter_addresses[0]
        b5sc = address.get('Borough Code', '0')+address.get('5-Digit Street Code', '00000')
        sname = get_sname(b5sc)
        hnum = address.get('Low House Number', '')
        return dict(sname=sname, hnum=hnum)
    except:
        return dict(sname='', hnum='')

def get_sname(b5sc): 
    try:
        geo = g['D'](B5SC=b5sc)
        return geo.get('First Street Name Normalized', '')
    except: 
        return ''

def geocode(input):
    boro = input.pop('boro')
    block = input.pop('block')
    lot = input.pop('lot') 
    ease = input.pop('ease')

    bbl = boro+block+lot
    address = get_address(bbl)

    sname = address.get('sname', '')
    hnum = address.get('hnum', '')
    borough = boro

    try: 
        geo = g['1B'](street_name=sname, house_number=hnum, borough=borough, mode='regular')
        geo = parse_output(geo)
        geo.update(borough = borough, block = block, lot = lot, ease = ease, input_hnum=hnum, input_sname=sname)
        return geo
    except GeosupportError as e1:
        try:
            geo = g['BL'](bbl=bbl)
            geo = parse_output(geo)
            geo.update(borough = borough, block = block, lot = lot, ease = ease, input_hnum=hnum, input_sname=sname)
            return geo
        except GeosupportError as e2:
            geo = parse_output(e1.result)
            geo.update(borough = borough, block = block, lot = lot, ease = ease, input_hnum=hnum, input_sname=sname)
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
        numberOfExistingStructures = geo.get('Number of Existing Structures on Lot', ''),
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
    # read in housing table
    conn = create_engine(os.environ.get('BUILD_ENGINE', ''))
    df = pd.read_sql('SELECT boro, block, lot, ease FROM pluto_pts', con=conn)
    #get the row number
    records = df.to_dict('records')
    
    print('geocoding begins here ...')
    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)
    
    print('geocoding finished ...')
    result = pd.DataFrame(it)
    print(result.head())

    result.to_csv('geo_result.csv', 
                columns=['borough', 'block', 'lot', 'input_hnum', 'input_sname', 'easement', 
                'billingbbl', 'bbl', 'communityDistrict', 'censusTract2010', 'censusBlock2010', 
                'communitySchoolDistrict', 'cityCouncilDistrict', 'zipCode', 
                'fireCompanyNumber', 'policePrecinct', 'healthCenterDistrict', 
                'healthArea', 'sanitationDistrict', 'sanitationCollectionScheduling', 
                'boePreferredStreetName', 'numberOfExistingStructures', 
                'taxMapNumberSectionAndVolume', 'sanbornMapIdentifier', 
                'XCoord', 'YCoord', 'longitude', 'latitude', 'grc', 'grc2', 'msg', 'msg2'],
                index=False)