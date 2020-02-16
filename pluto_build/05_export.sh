#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

URL="$GATEWAY/upload"
DATE=$(date "+%Y-%m-%d")

# mappluto
mkdir -p $(pwd)/output/mappluto && 
        cd $(pwd)/output {
#           pgsql2shp -u $BUILD_USER -h $BUILD_HOST -p $BUILD_PORT -f mappluto $BUILD_DB "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
          ogr2ogr -f "ESRI Shapefile" mappluto PG:"dbname='$BUILD_DB' user='$BUILD_USER' host='$BUILD_HOST' port='$BUILD_PORT'"\
                  -sql "SELECT ST_Transform(geom, 2263), bbl FROM pluto WHERE geom IS NOT NULL"\
                  -a_srs 'EPSG:2263'\
                  -nln 'mappluto'
          cd mappluto {
            rm -f mappluto_$VERSION.zip
            zip mappluto_$VERSION.zip mappluto.*
            curl -X POST $GATEWAY/upload\
                  -F file=@mappluto_$VERSION.zip\
                  -F key=$DATE/mappluto_$VERSION.zip\
                  -F acl=public-read
            rm -f mappluto.*
        cd ..;}
      cd ..;}

# Pluto
mkdir -p $(pwd)/output/pluto &&
        cd $(pwd)/output/pluto {
          rm -f pluto_$VERSION.zip
          psql $BUILD_ENGINE -c "\COPY (SELECT * FROM pluto) TO '$(pwd)/pluto.csv' DELIMITER ',' CSV HEADER;"
          zip pluto_$VERSION.zip pluto.csv
          curl -X POST $GATEWAY/upload\
                -F file=@pluto_$VERSION.zip\
                -F key=$DATE/pluto_$VERSION.zip\
                -F acl=public-read
          rm -f pluto.csv
        cd ..;}