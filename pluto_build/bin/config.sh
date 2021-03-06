#!/bin/bash
function set_env {
  for envfile in $@
  do
    if [ -f $envfile ]
      then
        export $(cat $envfile | sed 's/#.*//g' | xargs)
      fi
  done
}
# Set Environmental variables
set_env .env version.env

# Set Date
DATE=$(date "+%Y-%m-%d")

# Set Bucket info
s3_endpoint=https://nyc3.digitaloceanspaces.com
s3_bucket=edm-recipes

function urlparse {
    proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url=$(echo $1 | sed -e s,$proto,,g)
    userpass="$(echo $url | grep @ | cut -d@ -f1)"
    BUILD_PWD=`echo $userpass | grep : | cut -d: -f2`
    BUILD_USER=`echo $userpass | grep : | cut -d: -f1`
    hostport=$(echo $url | sed -e s,$userpass@,,g | cut -d/ -f1)
    BUILD_HOST="$(echo $hostport | sed -e 's,:.*,,g')"
    BUILD_PORT="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
    BUILD_DB="$(echo $url | grep / | cut -d/ -f2-)"
}

function FGDB_export {
  urlparse $BUILD_ENGINE
  mkdir -p output/$@.gdb &&
  (cd output/$@.gdb
    docker run \
      -v $(pwd):/data\
      --user $UID\
      --rm webmapp/gdal-docker:latest ogr2ogr -progress -f "FileGDB" $@.gdb \
        PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
        -mapFieldType Integer64=Real\
        -lco GEOMETRY_NAME=Shape\
        -nln $@\
        -nlt MULTIPOLYGON $@
    docker run \
      -v $(pwd):/data\
      --user $UID\
      --rm webmapp/gdal-docker:latest ogr2ogr -progress -f "FileGDB" $@.gdb \
        PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
        -mapFieldType Integer64=Real\
        -update -nlt NONE\
        -nln NOT_MAPPED_LOTS unmapped
      rm -f $@.gdb.zip
      zip -r $@.gdb.zip $@.gdb
      rm -rf $@.gdb
    )
}
register 'export' 'gdb' 'export pluto.gdb' FGDB_export

function SHP_export {
  urlparse $BUILD_ENGINE
  mkdir -p output/$@ &&
    (cd output/$@
      ogr2ogr -progress -f "ESRI Shapefile" $@.shp \
          PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
          -nlt MULTIPOLYGON $@
        rm -f $@.zip
        zip $@.zip *
        ls | grep -v $@.zip | xargs rm
      )
}
register 'export' 'shp' 'export pluto.shp' SHP_export

function CSV_export {
  psql $BUILD_ENGINE  -c "\COPY (
    SELECT * FROM $@
  ) TO STDOUT DELIMITER ',' CSV HEADER;" > $@.csv
}

function imports_csv {
   cat data/$1.csv | psql $BUILD_ENGINE -c "COPY $1 FROM STDIN DELIMITER ',' CSV HEADER;"
}

function Upload {
  mc rm -r --force spaces/edm-publishing/db-pluto/$@
  mc cp -r output spaces/edm-publishing/db-pluto/$@
}

function run {
  psql $BUILD_ENGINE -f $1
}
register 'run' 'sql' 'run pluto sql script' run

function get_latest_version {
  name=$1
  latest_version=$(curl -s $s3_endpoint/$s3_bucket/datasets/$1/latest/config.json |  jq -r '.dataset.version')
}

function import {
  name=$1
  get_latest_version $name
  url="$s3_endpoint/$s3_bucket/datasets/$name/$latest_version/$name.sql"
  curl -s -O $url
  psql --quiet $BUILD_ENGINE -f $name.sql
  psql -1 $BUILD_ENGINE -c "ALTER TABLE $name ADD COLUMN v text; UPDATE $name SET v = '$latest_version';"
  rm $name.sql
}
register 'import' 'dataset' 'import given dataset to BUILD_ENGINE' import
