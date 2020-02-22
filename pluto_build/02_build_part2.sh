#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
if [ -f version.env ]
then
  export $(cat version.env | sed 's/#.*//g' | xargs)
fi
echo '\nPopulating PLUTO tags and version fields \e[32m'
# psql $BUILD_ENGINE -f sql/plutomapid.sql
psql $BUILD_ENGINE -f sql/plutomapid_1.sql
psql $BUILD_ENGINE -f sql/plutomapid_2.sql
psql $BUILD_ENGINE -c "UPDATE pluto SET version = '$VERSION'";

echo '\nBackfilling'
psql $BUILD_ENGINE -f sql/backfill.sql