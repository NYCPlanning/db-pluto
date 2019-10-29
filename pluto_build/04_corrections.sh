#!/bin/bash
DBNAME='postgres'
DBUSER='postgres'

docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_create.sql

echo "Applying corrections to PLUTO"
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_lotarea.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_yearbuilt_lpc.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_ownername_city.sql