#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/pluto.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/pluto.config.json | jq -r '.DBUSER')

start=$(date +'%T')
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/corr_create.sql

echo "Applying corrections to PLUTO"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/corr_lotarea.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/corr_yearbuilt_lpc.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/corr_ownername_city.sql