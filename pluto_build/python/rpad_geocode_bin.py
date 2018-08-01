# GeoClient (DoITT) 
# Running the BBL associated with each RPAD record through GeoClient BL funtion
# to return the Billing bbl, address (house number and street name), and number of buildings

import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
from nyc_geoclient import Geoclient

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# load config file
with open('pluto.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']
# load necessary environment variables
app_id = config['GEOCLIENT_APP_ID']
app_key = config['GEOCLIENT_APP_KEY']

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))

# read in rpad table
rpad = pd.read_sql_query("SELECT * FROM pluto_rpad_geo WHERE (giHighHouseNumber1 IS NULL OR giHighHouseNumber1 = 'none') AND buildingidentificationnumber IS NOT NULL AND buildingidentificationnumber <> '1000000';", engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(bin):
    geo = g.bin(bin)
    try:
        giHighHouseNumber2 = geo['giHighHouseNumber2']
    except:
        giHighHouseNumber2 = 'none'
    try:
        giStreetName2 = geo['giStreetName2']
    except:
        giStreetName2 = 'none'
    try:
        latitudeInternalLabel = geo['latitudeInternalLabel']
    except:
        latitudeInternalLabel = 'none'
    try:
        longitudeInternalLabel = geo['longitudeInternalLabel']
    except:
        longitudeInternalLabel = 'none'
    loc = pd.DataFrame({'giHighHouseNumber2' : [giHighHouseNumber2],
                        'giStreetName2' : [giStreetName2],
                        'latitudeInternalLabel' : [latitudeInternalLabel],
                        'longitudeInternalLabel' : [longitudeInternalLabel]                      
                        })
    return(loc)

locs = pd.DataFrame()
for i in range(len(rpad)):
    new = get_loc(rpad['buildingidentificationnumber'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# populate the rpad geom information

for i in range(len(rpad)):
    if locs['giHighHouseNumber2'][i] != 'none':
        upd = "UPDATE pluto_rpad_geo a SET giHighHouseNumber1 = '" + str(locs['giHighHouseNumber2'][i]) + "', giStreetName1 = '" + str(locs['giStreetName2'][i]) + "' WHERE buildingidentificationnumber = '" + rpad['buildingidentificationnumber'][i] + "';"
    elif (locs['latitudeInternalLabel'][i] != 'none') & (locs['longitudeInternalLabel'][i] != 'none'):
        upd = "UPDATE dcp_cpdb_agencyverified a SET geom = ST_SetSRID(ST_MakePoint(" + str(locs['longitudeInternalLabel'][i]) + ", " + str(locs['latitudeInternalLabel'][i]) + "), 4326) WHERE buildingidentificationnumber = '" + rpad['buildingidentificationnumber'][i] + "';"
    elif (locs['latitudeInternalLabel'][i] == 'none') & (locs['longitudeInternalLabel'][i] == 'none') & (locs['giHighHouseNumber2'][i] == 'none'):
        upd = "UPDATE dcp_cpdb_agencyverified a SET geom = NULL WHERE buildingidentificationnumber = '" + rpad['buildingidentificationnumber'][i] + "';"
    engine.execute(upd)


#need to add in number of buildings
#try:
#numBldgs = geo['numberOfExistingStructuresOnLot']
#except:
#numBldgs = 'none'
#'numBldgs' : [numBldgs]
#if (locs['numBldgs'][i] != 'none'):
#upd = "UPDATE pluto_rpad_geo a SET numBldgs = '" + str(locs['numBldgs'][i]) + "' WHERE boro = '" + rpad['boro'][i] + "' AND tb = '" + rpad['tb'][i] + "' AND tl = '" + rpad['tl'][i] + "' ;"

# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
