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

## Other_datasets - PULLING FROM PLUTO GitHub repo
echo 'Loading datasets from PLUTO GitHub repo...'
node loader.js install pluto_input_allocated
node loader.js install pluto_input_geocodes
node loader.js install pluto_input_tc234
node loader.js install pluto_input_landuse_bldgclass
node loader.js install pluto_input_bsmtcode
node loader.js install pluto_input_cama_dof