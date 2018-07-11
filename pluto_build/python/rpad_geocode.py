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
rpad = pd.read_sql_query('SELECT * FROM pluto_rpad_geo WHERE geom IS NULL AND borough IS NOT NULL;', engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(borough, block, lot):
    geo = g.bbl(borough, block, lot)
    try:
        lat = geo['latitudeInternalLabel']
    except:
        lat = 'none'
    try:
        lon = geo['longitudeInternalLabel']
    except:
        lon = 'none'
    try:
        bbl = geo['bbl']
    except:
        bbl = 'none'
    try:
        billingbbl = geo['condominiumBillingBbl']
    except:
        billingbbl = 'none'
    try:
        giHighHouseNumber = geo['giHighHouseNumber1']
    except:
        giHighHouseNumber = 'none'
    try:
        giStreetCode = geo['giStreetCode1']
    except:
        giStreetCode = 'none'
    try:
        rpadBldgClass = geo['rpadBuildingClassificationCode']
    except:
        rpadBldgClass = 'none'
    loc = pd.DataFrame({'lat' : [lat],
                        'lon' : [lon],
                        'bbl' : [bbl],
                        'billingbbl' : [billingbbl],
                        'giHighHouseNumber' : [giHighHouseNumber],
                        'giStreetCode' : [giStreetCode],
                        'rpadBldgClass' : [rpadBldgClass]
                        })
    return(loc)

locs = pd.DataFrame()
for i in range(len(rpad)):
    new = get_loc(rpad['boro'][i],
                  rpad['tb'][i],
                  rpad['tl'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# populate the rpad geom information

for i in range(len(rpad)):
    if (locs['lat'][i] != 'none') & (locs['lon'][i] != 'none'):
        upd = "UPDATE pluto_rpad_geo a SET geom = ST_SetSRID(ST_MakePoint(" + str(locs['lon'][i]) + ", " + str(locs['lat'][i]) + "), 4326), bbl = str(locs['bbl'][i]), billingbbl = str(locs['billingbbl'][i]), giHighHouseNumber = str(locs['giHighHouseNumber'][i]), giStreetCode = str(locs['giStreetCode'][i]), rpadBldgClass = str(locs['rpadBldgClass'][i]) WHERE boro = '" + rpad['boro'][i] + "' AND tb = '" + rpad['tb'][i] + "' AND tl = '" + rpad['tl'][i] + "' ;"
    elif (locs['lat'][i] == 'none') & (locs['lon'][i] == 'none'):
        upd = "UPDATE pluto_rpad_geo a SET geom = NULL;"
    engine.execute(upd)


# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
