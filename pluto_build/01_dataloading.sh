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
node loader.js install dcp_edesignation
node loader.js install dcas_facilities_colp
node loader.js install dcas_ipis
node loader.js install lpc_historic_districts
node loader.js install lpc_landmarks
## Once edm version is published: node loader.js install dcp_zoning_taxlot

## Other_datasets - PULLING FROM FTP or PLUTO GitHub repo
echo 'Loading datasets from PLUTO GitHub repo...'
node loader.js install dcp_zoning_maxfar
node loader.js install pluto_input_bsmtcode
node loader.js install pluto_input_landuse_bldgclass

echo 'Loading datasets from FTP...'
node loader.js install pluto_rpad
node loader.js install pluto_input_cama_dof
node loader.js install dof_dtm
node loader.js install dof_shoreline
node loader.js install dof_condo
## node loader.js install dof_condo_units