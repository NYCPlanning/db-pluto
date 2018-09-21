import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
import usaddress
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
retail = pd.read_sql_query('SELECT license_number, trim(street_number) as street_number, trim(street_name) as street_name, boroughcode FROM dcp_retailfoodstores WHERE borough IS NOT NULL AND license_number IS NOT NULL AND street_number IS NOT NULL AND street_name IS NOT NULL AND geom IS NULL;', engine)
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
    engine.execute("UPDATE dcp_retailfoodstores a SET longitude = '" + str(data['display']['out_longitude']) + "', latitude = '" + str(data['display']['out_latitude']) + "' WHERE a.license_number::text = '" + str(retail.iloc[i, 0])+ "';")