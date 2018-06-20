#!/bin/bash

################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires you to setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using the civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

cd '/prod/data-loading-scripts'

## Open_datasets - PULLING FROM OPEN DATA
echo 'Loading open source datasets...'
node loader.js install dcp_zoning_taxlot
node loader.js install lpc_historic_districts
node loader.js install lpc_landmarks
node loader.js install dcas_ipis
node loader.js install dcp_edesignation
node loader.js install dof_dtm
node loader.js install doitt_buildingfootprints
node loader.js install dcas_facilities_colp

## Other_datasets - PULLING FROM FTP or PLUTO GitHub repo
echo 'Loading datasets from PLUTO GitHub repo...'
node loader.js install pluto_input_allocated
node loader.js install pluto_input_geocodes
node loader.js install pluto_input_tc234
node loader.js install pluto_input_landuse_bldgclass
node loader.js install pluto_input_bsmtcode
node loader.js install pluto_input_cama_dof
node loader.js install dcp_zoning_comm
node loader.js install dcp_zoning_mnf
node loader.js install dcp_zoning_res1to5
node loader.js install dcp_zoning_res6to10
node loader.js install dof_condo
node loader.js install dof_condo_units

DBSOURCE=$(cat $REPOLOC/cpdb.config.json | jq -r '.DBSOURCE')

echo $DBSOURCE

# create helper views
#default to run on scraped data from Capital Commitment Plan
if [ $DBSOURCE = 'fisa_capitalcommitments' ]; then
    psql -U $DBUSER -d $DBNAME -f $REPOLOC/capitalprojects_build/sql/projects_fisa.sql
else
    psql -U $DBUSER -d $DBNAME -f $REPOLOC/capitalprojects_build/sql/projects.sql
fi