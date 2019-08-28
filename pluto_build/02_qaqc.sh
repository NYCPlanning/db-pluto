#!/bin/bash

start=$(date +'%T')
echo "Starting to QA QC PLUTO input data"

docker exec pluto psql -U postgres -h localhost -f sql/qc_bldgclass.sql
docker exec pluto psql -U postgres -h localhost -f sql/qc_condonums.sql
# psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/qc_lotarea.sql
# (^ cannot run yet because requires previous version of RPAD)
