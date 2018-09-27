import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
import requests
import urllib
from jsonpath_rw import parse
from urllib import urlencode

# If you get this error: requests.exceptions.ConnectionError: ('Connection aborted.', error(54, 'Connection reset by peer')) install below or try the other solutions in the link
# pip install pyopenssl idna (https://github.com/jakubroztocil/httpie/issues/351)

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# load config file
with open('plutotest.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']
# load necessary environment variables
# set variables with following command: export SECRET_KEY="somesecretvalue"
app_key = config['APP_KEY']
base_url = config[u'BASE_URL']

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))
# read in retail stores table
retail = pd.read_sql_query("SELECT boro||tb||tl as bbl, trim(leading '0' from housenum_lo) as housenum_lo, trim(street_name) as street_name, boro FROM pluto_rpad_geo WHERE borough IS NOT NULL AND tb IS NOT NULL AND housenum_lo IS NOT NULL AND street_name IS NOT NULL AND longitude IS NULL;", engine)
# get apt response and write values to database
for i in range(len(retail)):
    license_number = retail.iloc[i, 0]
    Borough = retail.iloc[i, 3]
    AddressNo = retail.iloc[i, 1]
    StreetName = retail.iloc[i, 2]
    key=app_key
    parameters = {"Borough": Borough, "AddressNo": AddressNo, "StreetName": StreetName, "key": key}
    response = requests.get(base_url, params=parameters)
    data = response.json()
    engine.execute("UPDATE pluto_rpad_geo a SET longitude = '" + str(data['display']['out_longitude']) + "', latitude = '" + str(data['display']['out_latitude']) + "' WHERE a.boro||a.tb||a.tl::text = '" + str(retail.iloc[i, 0])+ "';")