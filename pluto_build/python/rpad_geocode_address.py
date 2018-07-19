# GeoClient (DoITT)
# Running the address info retrieved by running each RPAD record through GeoClient BL funtion
# through GeoClient address function to return political boundaries
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
rpad = pd.read_sql_query('SELECT * FROM pluto_rpad_geo WHERE giHighHouseNumber1 <> '"none"' AND borough IS NOT NULL AND cd IS NULL;', engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(num, street, borough):
    geo = g.bbl(num, street, borough)
    try:
        cd = geo['communityDistrict']
    except:
        cd = 'none'
    try:
        ct2010 = geo['censusTract2010']
    except:
        ct2010 = 'none'
    try:
        cb2010 = geo['censusBlock2010']
    except:
        cb2010 = 'none'
    try:
        council = geo['cityCouncilDistrict']
    except:
        council = 'none'
    try:
        zipcode = geo['zipCode']
    except:
        zipcode = 'none'
    try:
        firecomp = geo['fireCompanyNumber']
    except:
        firecomp = 'none'
    try:
        policeprct = geo['policePrecinct']
    except:
        policeprct = 'none'
    try:
        healthcenterdistrict = geo['healthCenterDistrict']
    except:
        healthcenterdistrict = 'none'
    try:
        healtharea = geo['healthArea']
    except:
        healtharea = 'none'
    try:
        sanitdistrict = geo['sanitationDistrict']
    except:
        sanitdistrict = 'none'
    try:
        sanitsub = geo['sanitationCollectionSchedulingSectionAndSubsection']
    except:
        sanitsub = 'none'

    loc = pd.DataFrame({'cd' : [cd],
                        'ct2010' : [ct2010],
                        'cb2010' : [cb2010],
                        'council' : [council],
                        'zipcode' : [zipcode],
                        'firecomp' : [firecomp],
                        'policeprct' : [policeprct],
                        'healthcenterdistrict' : [healthcenterdistrict],
                        'healtharea' : [healtharea],
                        'sanitdistrict' : [sanitdistrict],
                        'sanitsub' : [sanitsub]
                        })
    return(loc)

locs = pd.DataFrame()
for i in range(len(rpad)):
    new = get_loc(rpad['giHighHouseNumber1'][i],
                  rpad['giStreetName1'][i],
                  rpad['borough'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# populate the rpad geom information

for i in range(len(rpad)):
    if (locs['cd'][i] != 'none'):
        upd = "UPDATE pluto_rpad_geo a SET cd = " + str(locs['cd'][i]) + " WHERE boro = '" + rpad['boro'][i] + "' AND tb = '" + rpad['tb'][i] + "' AND tl = '" + rpad['tl'][i] + "' ;"
    elif (locs['cd'][i] == 'none'):
        upd = "UPDATE pluto_rpad_geo a SET cd = NULL;"
    engine.execute(upd)

# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
