#!/bin/bash
# load config
DBNAME=postgres
DBUSER=postgres

# some final processing is done in Esri to create the Esri file formats
# please go to NYC Planning's Bytes of the Big Apple to download the offical versions of PLUTO and MapPLUTO
# https://www1.nyc.gov/site/planning/data-maps/open-data.page

echo "Exporting pluto csv and shapefile"
docker exec pluto psql -U $DBUSER -d $DBNAME  -c "\COPY ( SELECT * FROM pluto) TO 'output/pluto.csv' DELIMITER ',' CSV HEADER;"

# pgsql2shp -u $DBUSER -f pluto_build/output/mappluto $DBNAME "SELECT * FROM pluto WHERE geom IS NOT NULL"

# ogr2ogr -f "GeoJSON" pluto_build/output/mappluto_clipped.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM mappluto_clipped WHERE geom IS NOT NULL"