#!/bin/sh
# load config
DBNAME=postgres
DBUSER=postgres

# some final processing is done in Esri to create the Esri file formats
# please go to NYC Planning's Bytes of the Big Apple to download the offical versions of PLUTO and MapPLUTO
# https://www1.nyc.gov/site/planning/data-maps/open-data.page

echo "Exporting pluto csv and shapefile"
docker exec pluto psql -U $DBUSER -d $DBNAME  -c "\COPY (SELECT * FROM pluto) TO 'output/pluto.csv' DELIMITER ',' CSV HEADER;"

rm output/pluto.zip
zip output/pluto.zip output/pluto.csv
rm -f output/pluto.csv

rm output/mappluto.zip
docker exec pluto pgsql2shp -u $DBUSER -f output/mappluto $DBNAME "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
zip output/mappluto.zip output/mappluto*
rm -f output/mappluto.cpg
rm -f output/mappluto.shp
rm -f output/mappluto.prj
rm -f output/mappluto.dbf
rm -f output/mappluto.shx


# ogr2ogr -f "GeoJSON" pluto_build/output/mappluto_clipped.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM mappluto_clipped WHERE geom IS NOT NULL"