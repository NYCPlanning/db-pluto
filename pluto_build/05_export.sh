#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
# some final processing is done in Esri to create the Esri file formats
# please go to NYC Planning's Bytes of the Big Apple to download the offical versions of PLUTO and MapPLUTO
# https://www1.nyc.gov/site/planning/data-maps/open-data.page

rm output/mappluto.zip
pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f output/mappluto $BUILD_DB "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
zip output/mappluto.zip output/mappluto*
rm -f output/mappluto.cpg
rm -f output/mappluto.shp
rm -f output/mappluto.prj
rm -f output/mappluto.dbf
rm -f output/mappluto.shx

# ogr2ogr -f "GeoJSON" pluto_build/output/mappluto_clipped.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM mappluto_clipped WHERE geom IS NOT NULL"