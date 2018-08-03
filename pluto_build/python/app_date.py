import datetime
import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json

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
rpad = pd.read_sql_query('SELECT * FROM pluto_rpad_geo WHERE ap_date IS NOT NULL AND length(ap_date) > 2 AND ap_datef IS NULL;', engine)

for i in range(len(rpad)):
    if rpad['ap_date'][i] != 'none':
    	upd = "UPDATE pluto_rpad_geo a SET ap_datef = '" + datetime.datetime.strptime(rpad['ap_date'], '%Y%j').strftime('%m/%d/%Y') + "' WHERE ap_date = '" + rpad['ap_date'][i] + "';"
    elif locs['ap_date'][i] == 'none':
    	upd = "UPDATE pluto_rpad_geo a SET ap_date = NULL WHERE ap_date = '" + rpad['ap_date'][i] + "';"
    engine.execute(upd)