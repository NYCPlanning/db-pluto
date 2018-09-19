# GeoClient (DoITT)
# Running the address info retrieved by running each RPAD record through GeoClient BL funtion
# through GeoClient address function to return political boundaries

import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
"""
nyc_geoclient.api
"""

import requests
import urllib
from urllib import urlencode

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# load config file
with open('plutotest.config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']
# load necessary environment variables
app_id = config['GEOCLIENT_APP_ID']
app_key = config['GEOCLIENT_APP_KEY']
base_url = config[u'BASE_URL']

class Geoclient(object):
    """
    This object's methods provide access to the NYC Geoclient REST API.
    You must have registered an app with the NYC Developer Portal
    (http://developer.cityofnewyork.us/api/geoclient-api-beta), and make sure
    that you check off access to the Geoclient API for the application.  Take
    note of the Application's ID and key.  You will not be able to use the ID
    and key until DoITT approves you -- this could take several days, and you
    will receive an email when this happens.  There isn't any indication of
    your status on the dashboard, but all requests will return a 403 until you
    are approved.
    All methods return a dict, whether or not the geocoding succeeded.  If it
    failed, the dict will have a `message` key with information on why it
    failed.
    :param app_id:
        Your NYC Geoclient application ID.
    :param app_key:
        Your NYC Geoclient application key.
    """

    BASE_URL = base_url

    def __init__(self, app_id, app_key):
        if not app_key:
            raise Exception("Missing app_key")

        self.app_id = app_id
        self.app_key = app_key

    def _request(self, endpoint, **kwargs):
        kwargs.update({
            'app_id': self.app_id,
            'app_key': self.app_key
        })

        # Ensure no 'None' values are sent to server
        for k in kwargs.keys():
            if kwargs[k] is None:
                kwargs.pop(k)

        return requests.get(u'{0}{1}.json?{2}'.format(Geoclient.BASE_URL, endpoint, urlencode(kwargs))).json()[endpoint]

    def address(self, AddressNo, StreetName, Borough):
        """
        Given a valid address, provides blockface-level, property-level, and
        political information.
        :param houseNumber:
            The house number to look up.
        :param street:
            The name of the street to look up.
        :param borough:
            The borough to look within.  Must be 'Bronx', 'Brooklyn',
            'Manhattan', 'Queens', or 'Staten Island' (case-insensitive).
        :returns: A dict with blockface-level, property-level, and political
            information.
        """
        return self._request(u'address', AddressNo=AddressNo, StreetName=StreetName,
                             Borough=Borough)

    def address_zip(self, houseNumber, street, zip):
        """
        Like the above address function, except it uses "zip code" instead of borough
        :param houseNumber:
            The house number to look up.
        :param street:
            The name of the street to look up
        :param zip:
            The zip code of the address to look up.
        :returns: A dict with blockface-level, property-level, and political
            information.
        """
        return self._request(u'address', houseNumber=houseNumber, street=street, zip=zip)

    def bbl(self, borough, block, lot):
        """
        Given a valid borough, block, and lot provides property-level
        information.
        :param borough:
            The borough to look within.  Must be 'Bronx', 'Brooklyn',
            'Manhattan', 'Queens', or 'Staten Island' (case-insensitive).
        :param block:
            The tax block to look up.
        :param lot:
            The tax lot to look up.
        :returns: A dict with property-level information.
        """
        return self._request(u'bbl', borough=borough, block=block, lot=lot)

    def bin(self, bin):
        """
        Given a valid building identification number (BIN) provides
        property-level information.
        :param bin:
            The BIN to look up.
        :returns: A dict with property-level information.
        """
        return self._request(u'bin', bin=bin)

    def blockface(self, onStreet, crossStreetOne, crossStreetTwo, borough,
                 boroughCrossStreetOne=None, boroughCrossStreetTwo=None,
                 compassDirection=None):
        """
        Given a valid borough, "on street" and cross streets provides
        blockface-level information.
        :param onStreet:
            "On street" (street name of target blockface).
        :param crossStreetOne:
            First cross street of blockface.
        :param crossStreetTwo:
            Second cross street of blockface.
        :param borough:
            The borough to look within.  Must be 'Bronx', 'Brooklyn',
            'Manhattan', 'Queens', or 'Staten Island' (case-insensitive).
        :param boroughCrossStreetOne:
            (optional) Borough of first cross street. Defaults to value of
            borough parameter if not supplied.
        :param boroughCrossStreetTwo:
            (optional) Borough of second cross street. Defaults to value of
            borough parameter if not supplied.
        :param compassDirection:
            (optional) Used to request information about only one side of the
            street. Valid values are: N, S, E or W.
        :returns: A dict with blockface-level information.
        """
        return self._request(u'blockface', onStreet=onStreet,
                             crossStreetOne=crossStreetOne,
                             crossStreetTwo=crossStreetTwo,
                             borough=borough,
                             boroughCrossStreetOne=boroughCrossStreetOne,
                             boroughCrossStreetTwo=boroughCrossStreetTwo,
                             compassDirection=compassDirection)

    def intersection(self, crossStreetOne, crossStreetTwo, borough,
                    boroughCrossStreetTwo=None, compassDirection=None):
        """
        Given a valid borough and cross streets returns information for the
        point defined by the two streets.
        :param crossStreetOne:
            First cross street
        :param crossStreetTwo:
            Second cross street
        :param borough:
            Borough of first cross street or of all cross streets if no other
            borough parameter is supplied.  Must be 'Bronx', 'Brooklyn',
            'Manhattan', 'Queens', or 'Staten Island' (case-insensitive).
        :param boroughCrossStreetTwo:
            (optional) Borough of second cross street. If not supplied, assumed
            to be same as borough parameter.  Must be 'Bronx', 'Brooklyn',
            'Manhattan', 'Queens', or 'Staten Island' (case-insensitive).
        :param compassDirection:
            (optional) Optional. for most requests. Required for streets that
            intersect more than once. Valid values are: N, S, E or W.
        :returns: A dict with intersection-level information.
        """
        return self._request(u'intersection', crossStreetOne=crossStreetOne,
                             crossStreetTwo=crossStreetTwo,
                             borough=borough,
                             boroughCrossStreetTwo=boroughCrossStreetTwo,
                             compassDirection=compassDirection)

    def place(self, name, borough):
        """
        Same as 'Address' above using well-known NYC place name for input.
        :param name:
            Place name of well-known NYC location.
        :param borough:
            Must be 'Bronx', 'Brooklyn', 'Manhattan', 'Queens', or 'Staten
            Island' (case-insensitive).
        :returns: A dict with place-level information.
        """
        return self._request(u'place', name=name, borough=borough)

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))

# read in rpad table
rpad = pd.read_sql_query('SELECT license_number, street_number, street_name, borough FROM dcp_retailfoodstores WHERE borough IS NOT NULL AND license_number IS NOT NULL AND street_number IS NOT NULL AND street_name IS NOT NULL AND geom IS NULL;', engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(AddressNo, StreetName, Borough):
    geo = g.address(AddressNo, StreetName, Borough)
    try:
        out_latitude = geo['out_latitude']
    except:
        out_latitude = 'none'
    try:
        out_longitude = geo['out_longitude']
    except:
        out_longitude = 'none'
    loc = pd.DataFrame({'out_latitude' : [out_latitude],
                        'out_longitude' : [out_longitude]})
    return(loc)

locs = pd.DataFrame()
for i in range(len(rpad)):
    new = get_loc(rpad['street_number'][i],
                  rpad['street_name'][i],
                  rpad['borough'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# populate the rpad geom information

for i in range(len(retail)):
    if (locs['out_latitude'][i] != 'none') & (locs['out_longitude'][i] != 'none'):
        upd = "UPDATE dcp_retailfoodstores a SET geom = ST_SetSRID(ST_MakePoint(" + str(locs['out_longitude'][i]) + ", " + str(locs['out_latitude'][i]) + "), 4326) WHERE a.license_number = '" + retail['license_number'][i] + "';"
    elif locs['lat'][i] == 'none':
        upd = "UPDATE dcp_retailfoodstores a SET geom = NULL WHERE a.license_number = '" + retail['license_number'][i] + "';"
    engine.execute(upd)

# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={
