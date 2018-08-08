#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/pluto.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/pluto.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "Starting to build PLUTO"

psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create_rpad_geo.sql

echo 'Geocoding RPAD...'
source activate py2
python $REPOLOC/pluto_build/python/rpad_geocode_address.py
# getting address if address in RPAD did not geocode
python $REPOLOC/pluto_build/python/rpad_geocode_bbl.py
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocode_billbbl.sql
python $REPOLOC/pluto_build/python/rpad_geocode_billbbl.py
python $REPOLOC/pluto_build/python/rpad_geocode_bin.py
# using GeoClient address to get spatial attributes
python $REPOLOC/pluto_build/python/rpad_geocode_addresspt2.py
source deactivate

psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocode_nones.sql

echo 'Reporting records that did not get geocoded...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocode_notgeocoded.sql

echo 'Making DCP edits to RPAD...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zerovacantlots.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/lotarea.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/primebbl.sql
python $REPOLOC/pluto_build/python/app_date.py


echo 'Creating table that aggregates condo data and is used to build PLUTO...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create_allocated.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/yearbuilt.sql


# create the table
echo 'Creating base PLUTO table'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/bbl.sql

# populate RPAD data
echo 'Adding on RPAD data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/allocated.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocodes.sql

psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/numericfields.sql


# add on CAMA data attributes
echo 'Adding on CAMA data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_bsmttype.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_lottype.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_proxcode.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_bldgarea.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_easements.sql

# populate other fields from misc sources
echo 'Adding on data attributes from other sources'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/landuse.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/lpc.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/far.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/edesignation.sql

echo 'Transform RPAD data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/irrlotcode.sql
##psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/colp.sql

##psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/ipis.sql