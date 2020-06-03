#!/bin/bash
source $(pwd)/bin/cli.sh

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
      -m 3g\
      --memory-swap -1\
      --rm webmapp/gdal-docker:latest ogr2ogr -progress -f "FileGDB" $@.gdb \
        PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
        -geomfield geom\
        -a_srs "EPSG:2263"\
        -mapFieldType Integer64=Real\
        -sql "
          SELECT
            \"Borough\",
            \"Block\",
            CAST(\"Lot\" AS smallint) as \"Lot\",
            CAST(\"CD\" AS smallint) as \"CD\",
            \"CT2010\",
            \"CB2010\",
            \"SchoolDist\",
            CAST(\"Council\" AS smallint) as \"Council\",
            \"ZipCode\",
            \"FireComp\",
            CAST(\"PolicePrct\" AS smallint) as \"PolicePrct\",
            CAST(\"HealthCenterDistrict\" AS smallint) as \"HealthCenterDistrict\",
            CAST(\"HealthArea\" AS smallint) as \"HealthArea\",
            \"Sanitboro\",
            \"SanitDistrict\",
            \"SanitSub\",
            \"Address\",
            \"ZoneDist1\",
            \"ZoneDist2\",
            \"ZoneDist3\",
            \"ZoneDist4\",
            \"Overlay1\",
            \"Overlay2\",
            \"SPDist1\",
            \"SPDist2\",
            \"SPDist3\",
            \"LtdHeight\",
            \"SplitZone\",
            \"BldgClass\",
            \"LandUse\",
            CAST(\"Easements\" AS smallint) as \"Easements\",
            \"OwnerType\",
            \"OwnerName\",
            \"LotArea\",
            \"BldgArea\",
            \"ComArea\",
            \"ResArea\",
            \"OfficeArea\",
            \"RetailArea\",
            \"GarageArea\",
            \"StrgeArea\",
            \"FactryArea\",
            \"OtherArea\",
            \"AreaSource\",
            \"NumBldgs\",
            \"NumFloors\",
            \"UnitsRes\",
            \"UnitsTotal\",
            \"LotFront\",
            \"LotDepth\",
            \"BldgFront\",
            \"BldgDepth\",
            \"Ext\",
            \"ProxCode\",
            \"IrrLotCode\",
            \"LotType\",
            \"BsmtCode\",
            \"AssessLand\",
            \"AssessTot\",
            \"ExemptTot\",
            CAST(\"YearBuilt\" AS smallint) as \"YearBuilt\",
            CAST(\"YearAlter1\" AS smallint) as \"YearAlter1\",
            CAST(\"YearAlter2\" AS smallint) as \"YearAlter2\",
            \"HistDist\",
            \"Landmark\",
            \"BuiltFAR\",
            \"ResidFAR\",
            \"CommFAR\",
            \"FacilFAR\",
            \"BoroCode\",
            \"BBL\",
            \"CondoNo\",
            \"Tract2010\",
            \"XCoord\",
            \"YCoord\",
            \"ZoneMap\",
            \"ZMCode\",
            \"Sanborn\",
            \"TaxMap\",
            \"EDesigNum\",
            \"APPBBL\",
            \"APPDate\",
            \"PLUTOMapID\",
            \"FIRM07_FLAG\",
            \"PFIRM15_FLAG\",
            \"Version\",
            \"DCPEdited\",
            \"Latitude\",
            \"Longitude\",
            \"Notes\",
            \"Shape_Leng\",
            \"Shape_Area\",
            geom
          FROM $@"\
        -nlt MULTIPOLYGON\
        -nln $@
    docker run \
      -v $(pwd):/data\
      --user $UID\
      --rm webmapp/gdal-docker:latest ogr2ogr -progress -f "FileGDB" $@.gdb \
        PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
        -mapFieldType Integer64=Real\
        -update -nlt NONE\
        -sql "
          SELECT
            \"Borough\",
            \"Block\",
            CAST(\"Lot\" AS smallint) as \"Lot\",
            CAST(\"CD\" AS smallint) as \"CD\",
            \"CT2010\",
            \"CB2010\",
            \"SchoolDist\",
            CAST(\"Council\" AS smallint) as \"Council\",
            \"ZipCode\",
            \"FireComp\",
            CAST(\"PolicePrct\" AS smallint) as \"PolicePrct\",
            CAST(\"HealthCenterDistrict\" AS smallint) as \"HealthCenterDistrict\",
            CAST(\"HealthArea\" AS smallint) as \"HealthArea\",
            \"Sanitboro\",
            \"SanitDistrict\",
            \"SanitSub\",
            \"Address\",
            \"ZoneDist1\",
            \"ZoneDist2\",
            \"ZoneDist3\",
            \"ZoneDist4\",
            \"Overlay1\",
            \"Overlay2\",
            \"SPDist1\",
            \"SPDist2\",
            \"SPDist3\",
            \"LtdHeight\",
            \"SplitZone\",
            \"BldgClass\",
            \"LandUse\",
            CAST(\"Easements\" AS smallint) as \"Easements\",
            \"OwnerType\",
            \"OwnerName\",
            \"LotArea\",
            \"BldgArea\",
            \"ComArea\",
            \"ResArea\",
            \"OfficeArea\",
            \"RetailArea\",
            \"GarageArea\",
            \"StrgeArea\",
            \"FactryArea\",
            \"OtherArea\",
            \"AreaSource\",
            \"NumBldgs\",
            \"NumFloors\",
            \"UnitsRes\",
            \"UnitsTotal\",
            \"LotFront\",
            \"LotDepth\",
            \"BldgFront\",
            \"BldgDepth\",
            \"Ext\",
            \"ProxCode\",
            \"IrrLotCode\",
            \"LotType\",
            \"BsmtCode\",
            \"AssessLand\",
            \"AssessTot\",
            \"ExemptTot\",
            CAST(\"YearBuilt\" AS smallint) as \"YearBuilt\",
            CAST(\"YearAlter1\" AS smallint) as \"YearAlter1\",
            CAST(\"YearAlter2\" AS smallint) as \"YearAlter2\",
            \"HistDist\",
            \"Landmark\",
            \"BuiltFAR\",
            \"ResidFAR\",
            \"CommFAR\",
            \"FacilFAR\",
            \"BoroCode\",
            \"BBL\",
            \"CondoNo\",
            \"Tract2010\",
            \"XCoord\",
            \"YCoord\",
            \"ZoneMap\",
            \"ZMCode\",
            \"Sanborn\",
            \"TaxMap\",
            \"EDesigNum\",
            \"APPBBL\",
            \"APPDate\",
            \"PLUTOMapID\",
            \"FIRM07_FLAG\",
            \"PFIRM15_FLAG\",
            \"Version\",
            \"DCPEdited\",
            \"Latitude\",
            \"Longitude\",
            \"Notes\"
          FROM unmapped"\
        -nln NOT_MAPPED_LOTS
      rm -f $@.gdb.zip
      zip -r $@.gdb.zip $@.gdb
      rm -rf $@.gdb
    )
}
register 'export' 'gdb' 'export pluto.gdb' FGDB_export

function SHP_export {
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

function Upload {
  mc rm -r --force spaces/edm-publishing/db-pluto/$@
  mc cp -r output spaces/edm-publishing/db-pluto/$@
}

function run {
  psql $BUILD_ENGINE -f $1
}
register 'run' 'sql' 'run pluto sql script' run

# Set Environmental variables
set_env .env version.env

# Parse URL
urlparse $BUILD_ENGINE

# Set Date
DATE=$(date "+%Y-%m-%d")
