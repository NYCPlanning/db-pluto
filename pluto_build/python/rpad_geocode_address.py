# GeoClient (DoITT)
# Running the address info retrieved by running each RPAD record through GeoClient BL funtion
# through GeoClient address function to return political boundaries
# https://api.cityofnewyork.us/geoclient/v1/address.json?houseNumber=314&street=west 100 st&borough=manhattan&app_id=de39a958&app_key=66e5acfdfefa705283602f21eec10083

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
rpad = pd.read_sql_query('SELECT * FROM pluto_rpad_geo WHERE gihighhousenumber1 IS NOT NULL AND cd IS NULL;', engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(num, street, borough):
    geo = g.address(num, street, borough)
    try:
        communityDistrict = geo['communityDistrict']
    except:
        communityDistrict = 'none'
    loc = pd.DataFrame({'communityDistrict' : [communityDistrict]})
    return(loc)

locs = pd.DataFrame()
for i in range(len(rpad)):
    new = get_loc(rpad['gihighhousenumber1'][i],
                  rpad['gistreetname1'][i],
                  rpad['borough'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# populate the rpad geom information

for i in range(len(rpad)):
    if locs['communityDistrict'][i] != 'none':
        upd = "UPDATE pluto_rpad_geo a SET cd = '" + str(locs['communityDistrict'][i]) + "' WHERE borough = '" + rpad['borough'][i] + "' AND tb = '" + rpad['tb'][i] + "' AND tl = '" + rpad['tl'][i] + "' ;"
    elif locs['communityDistrict'][i] == 'none':
        upd = "UPDATE pluto_rpad_geo a SET cd = NULL;"
    engine.execute(upd)

# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
