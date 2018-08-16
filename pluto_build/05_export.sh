#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/pluto.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/pluto.config.json | jq -r '.DBUSER')

# export full pluto table
# export map pluto
# export map pluto clipped

echo "Exporting pluto"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/exportdata.sql

pgsql2shp -u $DBUSER -f pluto_build/output/mappluto $DBNAME "SELECT * FROM pluto WHERE geom IS NOT NULL"
pgsql2shp -u $DBUSER -f pluto_build/output/mappluto_clipped $DBNAME "SELECT * FROM pluto WHERE geom IS NOT NULL"

ogr2ogr -f "GeoJSON" pluto_build/output/mappluto.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
-sql "SELECT * FROM pluto WHERE geom IS NOT NULL"

ogr2ogr -f "GeoJSON" pluto_build/output/mappluto_clipped.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
-sql "SELECT * FROM mappluto_clipped WHERE geom IS NOT NULL"