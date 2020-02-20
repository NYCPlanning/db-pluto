#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
if [ -f version.env ]
then
  export $(cat version.env | sed 's/#.*//g' | xargs)
fi

apt update 
apt install -y zip

source ./url_parse.sh $BUILD_ENGINE
# mappluto
mkdir -p output/mappluto &&
  (cd output/mappluto
    pgsql2shp -u $BUILD_USER -h $BUILD_HOST -p $BUILD_PORT -f mappluto $BUILD_DB \
      "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
      rm -f mappluto_$VERSION.zip
      zip mappluto_$VERSION.zip mappluto.*
      rm -f mappluto.*
    )

# Pluto
mkdir -p output/pluto &&
  (cd output/pluto
    rm -f pluto_$VERSION.zip
    psql $BUILD_ENGINE -c "\COPY (SELECT * FROM pluto) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto.csv
    zip pluto_$VERSION.zip pluto.csv
    rm -f pluto.csv
  )

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc

DATE=$(date "+%Y-%m-%d")
./mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
./mc cp -r output spaces/edm-publishing/db-pluto/latest
./mc cp -r output spaces/edm-publishing/db-pluto/$DATE