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
  mkdir -p output/$@.gdb &&
  (cd output/$@.gdb
    docker run \
      -v $(pwd):/data\
      --user $UID\
      --rm webmapp/gdal-docker:latest ogr2ogr -f "FileGDB" $@.gdb \
        PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
        -nlt MULTIPOLYGON $@
      rm -f $@.gdb.zip
      echo "$VERSION" > version.txt
      zip -r $@.gdb.zip $@.gdb
      rm -rf $@.gdb
    )
}

function SHP_export {
  mkdir -p output/$@ &&
    (cd output/$@
      pgsql2shp -u $BUILD_USER -h $BUILD_HOST -p $BUILD_PORT -P $BUILD_PWD -f $@ $BUILD_DB \
        "SELECT * from $@"
        rm -f $@.zip
        echo "$VERSION" > version.txt
        zip $@.zip *
        ls | grep -v $@.zip | xargs rm
      )
}

function CSV_export {
  psql $BUILD_ENGINE  -c "\COPY (
    SELECT * FROM $@
  ) TO STDOUT DELIMITER ',' CSV HEADER;" > $@.csv
}

function Upload {
  mc rm -r --force spaces/edm-publishing/db-pluto/$@
  mc cp -r output spaces/edm-publishing/db-pluto/$@
}

# Set Environmental variables
set_env .env version.env

# Parse URL
urlparse $BUILD_ENGINE

# Set Date
DATE=$(date "+%Y-%m-%d")
