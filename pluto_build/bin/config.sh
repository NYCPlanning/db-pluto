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
  name=$1
  filetype="FileGDB"
  args="-mapFieldType Integer64=Real -lco GEOMETRY_NAME=Shape -nln $name -nlt MULTIPOLYGON"
  extension="gdb"

  spatial_export "${name}" "${filetype}" "${extension}" "${args}"    
}
register 'export' 'gdb' 'export pluto.gdb' FGDB_export

function SHP_export {
  name=$1
  filetype="ESRI Shapefile"
  args=""
  extension="shp"

  spatial_export "${name}" "${filetype}" "${extension}" "${args}"
}

register 'export' 'shp' 'export pluto.shp' SHP_export

function spatial_export { 
  name=$1
  filetype=$2
  ext=$3
  args=$4

  urlparse $BUILD_ENGINE
  mkdir -p output/$name && 
    (cd output/$name
      ogr2ogr -progress -f "$filetype" $name.$ext \
          PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
          $args \
          $name
      rm -f $name.$ext.zip
      zip -9 $name.$ext.zip *
      ls | grep -v $name.$ext.zip | xargs rm -r
  )
}

function CSV_export {
  psql $BUILD_ENGINE  -c "\COPY (
    SELECT * FROM $@
  ) TO STDOUT DELIMITER ',' CSV HEADER;" > $@.csv
}

function imports_csv {
   cat data/$1.csv | psql $BUILD_ENGINE -c "COPY $1 FROM STDIN DELIMITER ',' CSV HEADER;"
}

function Upload {
  echo "running upload"
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

function get_version {
  name=$1
  version=${2:-latest}
  url=https://nyc3.digitaloceanspaces.com/edm-recipes
  version=$(curl -s $url/datasets/$name/$version/config.json | jq -r '.dataset.version')
  echo -e "🔵 $name version: $version"
}

function import_public {
  name=$1
  version=${2:-latest}
  get_version $1 $2
  target_dir=$(pwd)/.library/datasets/$name/$version

  # Download sql dump for the datasets from data library
  if [ -f $target_dir/$name.sql ]; then
    echo "✅ $name.sql exists in cache"
  else
    echo "🛠 $name.sql doesn't exists in cache, downloading ..."
    mkdir -p $target_dir && (
      cd $target_dir
      curl -ss -O $url/datasets/$name/$version/$name.sql
    )
  fi

  # Loading into Database
  psql $BUILD_ENGINE -v ON_ERROR_STOP=1 -q -f $target_dir/$name.sql
  psql -1 $BUILD_ENGINE -c "ALTER TABLE $name ADD COLUMN v text; UPDATE $name SET v = '$version';"
}

register 'import' 'dataset' 'import given dataset to BUILD_ENGINE' import_public
