#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
if [ -f versions.env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
# URL="$GATEWAY/upload"
# DATE=$(date "+%Y-%m-%d")
apt update 
apt install -y zip
mkdir -p output

source ./url_parse.sh $BUILD_ENGINE
# mappluto
mkdir -p output/mappluto &&
  (cd output pgsql2shp -u $BUILD_USER -h $BUILD_HOST -p $BUILD_PORT -f mappluto $BUILD_DB 
      "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
    (cd mappluto rm -f mappluto_$VERSION.zip
      zip mappluto_$VERSION.zip mappluto.*
      rm -f mappluto.*
      )
    )

# Pluto
mkdir -p output/pluto &&
        (cd output/pluto
          rm -f pluto_$VERSION.zip
          psql $BUILD_ENGINE -c "\COPY (SELECT * FROM pluto) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto.csv
          zip pluto_$VERSION.zip pluto.csv
          rm -f pluto.csv
        )